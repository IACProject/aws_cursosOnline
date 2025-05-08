resource "aws_cognito_user_pool" "cognito_user_pool" {
  name = "online-ready-user-pool"

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 12
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  tags = {
    Name        = "OnlineReady"
    Environment = var.environment
  }
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
  
}

resource "aws_cognito_user_pool_client" "cognito_user_client" {
  name         = "online-ready-client"
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]

  generate_secret = false

  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_flows = ["code", "implicit"]

  allowed_oauth_scopes = [
    "phone",
    "email",
    "openid",
    "profile",
    "aws.cognito.signin.user.admin"
  ]

  callback_urls = [
    "http://localhost:3000/callback"
  ]

  logout_urls = [
    "http://localhost:3000/logout"
  ]

  supported_identity_providers = ["COGNITO"]

  prevent_user_existence_errors = "ENABLED"

  enable_token_revocation = true
}

resource "aws_cognito_user_pool_domain" "cognito_domain" {
  domain       = "online-ready-${var.environment}"
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
}

output "cognito_user_pool_id" {
  description = "ID del User Pool de Cognito"
  value       = aws_cognito_user_pool.cognito_user_pool.id
}

output "cognito_user_pool_client_id" {
  description = "ID del User Pool Client"
  value       = aws_cognito_user_pool_client.cognito_user_client.id
}

output "cognito_user_pool_domain" {
  description = "Dominio del User Pool"
  value       = aws_cognito_user_pool_domain.cognito_domain.domain
}

# Al final de cognito.tf

data "aws_region" "current" {}

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "online-ready-identity-pool-${var.environment}"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.cognito_user_client.id
    provider_name = "cognito-idp.${data.aws_region.current.name}.amazonaws.com/${aws_cognito_user_pool.cognito_user_pool.id}"
  }
}

resource "aws_iam_role" "cognito_authenticated_role" {
  name = "online-ready-authenticated-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "cognito-identity.amazonaws.com"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.main.id
        }
        "ForAnyValue:StringLike" = {
          "cognito-identity.amazonaws.com:amr" = "authenticated"
        }
      }
    }]
  })
}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.main.id
  roles = {
    authenticated = aws_iam_role.cognito_authenticated_role.arn
  }
}

output "cognito_identity_pool_id" {
  value = aws_cognito_identity_pool.main.id
}

output "cognito_authenticated_role_arn" {
  value = aws_iam_role.cognito_authenticated_role.arn
}