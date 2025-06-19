output "cloudfront_distribution_id" {
  description = "ID de la distribución de CloudFront"
  value       = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_domain_name" {
  description = "Dominio asignado a la distribución de CloudFront"
  value       = aws_cloudfront_distribution.cdn.domain_name
}