output "cursos_resource_id" {
  description = "Resource ID for /cursos endpoint"
  value       = aws_api_gateway_resource.cursos.id
}

output "usuarios_resource_id" {
  description = "Resource ID for /usuarios endpoint"
  value       = aws_api_gateway_resource.usuarios.id
}