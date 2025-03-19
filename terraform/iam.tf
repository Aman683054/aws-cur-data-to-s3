resource "aws_iam_role" "cur_lambda_role" {
  name = "aws-cur-data-to-s3-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "cur_lambda_policy" {
  name        = "aws-cur-data-to-s3-policy"
  description = "Policy for Lambda to fetch cost data and upload to S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ce:GetCostAndUsage"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
        "s3:ListBucket"]
        Resource = "${aws_s3_bucket.cur_bucket.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cur_attach_lambda_policy" {
  role       = aws_iam_role.cur_lambda_role.name
  policy_arn = aws_iam_policy.cur_lambda_policy.arn
}