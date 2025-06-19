output "table_name" {
  value = aws_dynamodb_table.registro_archivos.name
}

output "table_arn" {
  value = aws_dynamodb_table.registro_archivos.arn
}