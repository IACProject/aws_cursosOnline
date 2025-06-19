output "log_group_name" {
  description = "Nombre del log group"
  value       = aws_cloudwatch_log_group.lambda_notify_logs.name
}