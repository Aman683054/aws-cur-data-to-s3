resource "aws_cloudwatch_event_rule" "cur_lambda_trigger" {
  name                = "aws-cur-data-to-s3"
  schedule_expression = var.lambda_trigger_expression
}
resource "aws_cloudwatch_event_target" "cur_invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.cur_lambda_trigger.name
  target_id = "invoke-lambda"
  arn       = aws_lambda_function.cur_lambda.arn
}
resource "aws_lambda_permission" "cur_allow_eventbridge" {
  statement_id  = "AllowCURLambdaExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cur_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cur_lambda_trigger.arn
}