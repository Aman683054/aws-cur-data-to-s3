variable "CUR_RANGE" {
  type        = string
  default     = "daily" #daily/weekly/monthly
  description = "Accepted value is daily/weekly/monthly. This value is used as cost and usage data for last 1 day, 7 days or a month"
}

variable "lambda_trigger_expression" {
  type    = string
  default = "cron(0 13 * * ? *)" #for daily
  #   default = "cron(0 13 ? * MON *)" #for weekly
  #   default = "cron(0 13 1 * ? *)" #for monthly
  description = "based on CUR_RANGE, select the schedule expression in UTC which will trigger the lambda code"
}

variable "REGION_NAME" {
  type        = string
  default     = "eu-west-1"
  description = "region"
}