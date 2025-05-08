output "cloudfront_distribution_id" {
  description = "ID de la distribución CloudFront"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "opensearch_endpoint" {
  description = "Endpoint de OpenSearch"
  value       = aws_opensearch_domain.courses_search.endpoint
}

output "step_function_arn" {
  description = "ARN de la Step Function"
  value       = aws_sfn_state_machine.course_approval_flow.id
}

output "waf_acl_arn" {
  description = "ARN del WAF ACL"
  value       = aws_wafv2_web_acl.online_ready.arn
}

output "api_gateway_url" {
  description = "URL base del API Gateway"
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}"
}