variable "CUR_RANGE" {
  type        = string
  default     = "daily"
  description = "Accepted value is daily/weekly/monthly. This value is used as cost and usage data for last 1 day, 7 days or a month"
}

variable "lambda_trigger_expression" {
  type    = string
  default = "cron(0 0 * * ? *)" #for daily
  #   default = "cron(0 0 * * SUN *)" #for weekly
  #   default = "cron(0 0 1 * ? *)" #for monthly
  description = "based on CUR_RANGE, select the schedule expression which will trigger the lambda"
}