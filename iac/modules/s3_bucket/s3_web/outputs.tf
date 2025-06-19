output "bucket_name" {
  description = "Nombre del bucket creado"
  value       = aws_s3_bucket.bucket.id
}

output "bucket_domain_name" {
  description = "Dominio regional del bucket"
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
}

output "bucket_arn" {
  description = "ARN del bucket"
  value       = aws_s3_bucket.bucket.arn
}