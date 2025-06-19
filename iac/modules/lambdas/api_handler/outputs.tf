output "lambda_function_name" {
  value       = aws_lambda_function.api_handler.function_name
  description = "Nombre de la función Lambda creada"
}

output "lambda_arn" {
  value       = aws_lambda_function.api_handler.arn
  description = "ARN de la función Lambda"
}