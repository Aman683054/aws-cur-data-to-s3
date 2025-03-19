resource "aws_s3_bucket" "cur_bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-aws-cost-usage-reports"
}

resource "aws_s3_bucket_public_access_block" "cur_bucket_public_access" {
  bucket                  = aws_s3_bucket.cur_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "cur_bucket_intelligent_tiering" {
  bucket = aws_s3_bucket.cur_bucket.id
  rule {
    id     = "move-to-intelligent-tiering"
    status = "Enabled"
    transition {
      days          = 0 # Move objects to Intelligent-Tiering once the file is uploaded
      storage_class = "INTELLIGENT_TIERING"
    }
    filter {
      prefix = "/"
    }
  }
}

resource "aws_s3_bucket_policy" "cur_bucket_restrict_access" {
  bucket = aws_s3_bucket.cur_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowOnlyAccountAccess"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.cur_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.cur_bucket.id}/*"
        ]
        Condition = {
          StringNotEquals = {
            "aws:PrincipalAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cur_bucket_encryption" {
  bucket = aws_s3_bucket.cur_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
