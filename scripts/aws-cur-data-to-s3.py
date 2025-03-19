import boto3
import csv
import os
import datetime
import logging
from dateutil.relativedelta import relativedelta

# configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# setting up aws clients
cost_explorer_client = boto3.client("ce", region_name= "eu-west-1")
s3_client = boto3.client("s3")
sts_client = boto3.client("sts")

# fetching account id
account_id = sts_client.get_caller_identity()["Account"]
logger.info(f"fetching aws account id: {account_id}")

CUR_S3_BUCKET = os.getenv("CUR_S3_BUCKET", f"{account_id}-aws-cost-usage-reports")
CUR_RANGE = os.getenv("CUR_RANGE", "daily")

logger.info(f"Using CUR Bucket: {CUR_S3_BUCKET}")

# gets the data from cost and usage api
def get_cur_data(time_range):
    end_date = datetime.date.today()
    if time_range == "daily":
        start_date = end_date - datetime.timedelta(days=1)
    elif time_range == "weekly":
        start_date = end_date - datetime.timedelta(weeks=1)
    elif time_range == "monthly":
        start_date = end_date - relativedelta(months=1)
    else:
        logger.error("Invalid time range specified")
        raise ValueError("Invalid time range")
    logger.info(f"Fetching AWS Cost and Usage data from {start_date} to {end_date}...")
    try:
        response = cost_explorer_client.get_cost_and_usage(
            TimePeriod={
                "Start": str(start_date), 
                "End": str(end_date)
                },
            Granularity="DAILY",
            Metrics=["UnblendedCost"],
            GroupBy=[{"Type": "DIMENSION", "Key": "SERVICE"}]
        )
        data = [["Date", "Service", "Cost (USD)"]]
        for result in response["ResultsByTime"]:
            #print(result)
            for group in result["Groups"]:
                #print(group)
                date = result["TimePeriod"]["Start"]
                service = group["Keys"][0]
                cost = group["Metrics"]["UnblendedCost"]["Amount"]
                data.append([date, service, cost])
        logger.info("Successfully fetched cost data.")
        return data
    except Exception as e:
       logger.error(f"Error fetching cost data: {e}")
       raise

#store the data in CSV file
def save_to_s3(data):
   date_str = datetime.date.today().strftime("%Y-%m-%d")
   file_name = f"cost-usage-report-{date_str}.csv"
   file_path = f"/tmp/{file_name}"
   try:
       logger.info(f"Saving cost data to CSV file: {file_name}")
       with open(file_path, "w", newline="") as f:
           writer = csv.writer(f)
           writer.writerows(data)
       logger.info("CSV file saved successfully.")
       logger.info(f"Uploading {file_name} to s3://{CUR_S3_BUCKET}/{file_name}...")
       s3_client.upload_file(file_path, CUR_S3_BUCKET, file_name)
       logger.info(f"File successfully uploaded to S3.")
   except Exception as e:
       logger.error(f"Error saving/uploading CSV: {e}")
       raise


def lambda_handler(event, context):
   logger.info("Lambda function triggered.")
   try:
       data = get_cur_data(CUR_RANGE)
       save_to_s3(data)
       return {"statusCode": 200, "body": f"Cost data saved to S3 as CSV."}
   except Exception as e:
       logger.error(f"Lambda execution failed: {e}")
       return {"statusCode": 500, "body": "Error processing cost data"}
   
if __name__ == "__main__":
   logger.info("Starting script execution...")
   try:
       data = get_cur_data(CUR_RANGE)
       save_to_s3(data)
       logger.info("Script execution completed successfully.")
   except Exception as e:
       logger.error(f"Script execution failed: {e}")