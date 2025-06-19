resource "aws_s3_bucket" "private" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}
