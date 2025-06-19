output "function_name" {
  value       = aws_lambda_function.notify.function_name
  description = "Nombre de la Lambda de notificaciones"
}

output "invoke_arn" {
  value       = aws_lambda_function.notify.invoke_arn
  description = "ARN de invocación de la función Lambda"
}