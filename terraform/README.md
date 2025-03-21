# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.92.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.monthly_cost_alert](https://registry.terraform.io/providers/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_cloudwatch_event_rule.cur_lambda_trigger](https://registry.terraform.io/providers/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.cur_invoke_lambda](https://registry.terraform.io/providers/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.cur_lambda_log](https://registry.terraform.io/providers/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.cur_lambda_policy](https://registry.terraform.io/providers/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cur_lambda_role](https://registry.terraform.io/providers/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cur_attach_lambda_policy](https://registry.terraform.io/providers/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.cur_lambda](https://registry.terraform.io/providers/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.cur_allow_eventbridge](https://registry.terraform.io/providers/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.cur_bucket](https://registry.terraform.io/providers/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.cur_bucket_intelligent_tiering](https://registry.terraform.io/providers/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.cur_bucket_restrict_access](https://registry.terraform.io/providers/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.cur_bucket_public_access](https://registry.terraform.io/providers/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.cur_bucket_encryption](https://registry.terraform.io/providers/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CUR_RANGE"></a> [CUR\_RANGE](#input\_CUR\_RANGE) | Accepted value is daily/weekly/monthly. This value is used as cost and usage data for last 1 day, 7 days or a month | `string` | `"daily"` | no |
| <a name="input_REGION_NAME"></a> [REGION\_NAME](#input\_REGION\_NAME) | n/a | `string` | `"eu-west-1"` | no |
| <a name="input_lambda_trigger_expression"></a> [lambda\_trigger\_expression](#input\_lambda\_trigger\_expression) | based on CUR\_RANGE, select the schedule expression in UTC which will trigger the lambda code | `string` | `"cron(0 13 * * ? *)"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
