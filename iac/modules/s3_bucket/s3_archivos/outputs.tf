output "bucket_name" {
  value = aws_s3_bucket.private.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.private.arn
}