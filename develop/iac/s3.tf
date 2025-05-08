resource "aws_s3_bucket" "bucket" {
  bucket = "notifier-bucket-project-${var.environment}"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.logs.id
    target_prefix = "s3-logs/"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "online-ready-logs-${var.environment}"
  acl    = "log-delivery-write"
}