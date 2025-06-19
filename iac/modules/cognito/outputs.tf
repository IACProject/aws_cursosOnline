output "cognito_user_pool_id" {
  description = "ID del User Pool de Cognito"
  value       = aws_cognito_user_pool.cognito_user_pool.id
}

output "cognito_user_pool_client_id" {
  description = "ID del User Pool Client"
  value       = aws_cognito_user_pool_client.cognito_user_client.id
}

output "cognito_user_pool_domain" {
  description = "Dominio asignado al user pool"
  value       = aws_cognito_user_pool_domain.cognito_domain.domain
}