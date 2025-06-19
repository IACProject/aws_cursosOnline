output "invoke_arn" {
  description = "ARN to invoke the Lambda function"
  value       = aws_lambda_function.files_manager.invoke_arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.files_manager.function_name
}

output "arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.files_manager.arn
}