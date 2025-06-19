output "api_handler_role_arn" {
  description = "ARN of the API handler Lambda role"
  value       = module.lambda_api_handler_role.role_arn
}

output "lambda_notify_role_arn" {
  description = "ARN of the Lambda notify role"
  value       = module.lambda_notify_role.role_arn
}