# Terraform S3 Services Example
# This file contains 10 different S3-related resources, each as a separate resource block

provider "aws" {
  region = "us-east-1"
}

# 1. S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = "example-main-bucket-123456"
  acl    = "private"
  tags = {
    Name = "MainBucket"
  }
}

# 2. S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. S3 Bucket Logging
resource "aws_s3_bucket_logging" "main" {
  bucket = aws_s3_bucket.main.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# 4. S3 Log Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "example-log-bucket-123456"
  acl    = "log-delivery-write"
  tags = {
    Name = "LogBucket"
  }
}

# 5. S3 Bucket Policy
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

# 6. S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 7. S3 Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    id     = "log"
    status = "Enabled"
    filter {
      prefix = "log/"
    }
    expiration {
      days = 30
    }
  }
}

# 8. S3 Bucket Notification
resource "aws_s3_bucket_notification" "main" {
  bucket = aws_s3_bucket.main.id
  topic {
    topic_arn = aws_sns_topic.s3_events.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

# 9. SNS Topic for S3 Notification
resource "aws_sns_topic" "s3_events" {
  name = "s3-events-topic"
}

# 10. S3 Bucket Object
resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.main.id
  key    = "example.txt"
  content = "This is an example object."
}
