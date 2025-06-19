output "endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.curso_docente_db.endpoint
}

output "name" {
  description = "Database name"
  value       = aws_db_instance.curso_docente_db.db_name
}

output "arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.curso_docente_db.arn
}

output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.curso_docente_db.id
}