data "aws_caller_identity" "current" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../scripts/aws-cur-data-to-s3.py"
  output_path = "../scripts/aws-cur-data-to-s3.zip"
}