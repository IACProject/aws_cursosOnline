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

  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  supported_identity_providers = ["COGNITO"]
  prevent_user_existence_errors = "ENABLED"
  enable_token_revocation       = true
}

resource "aws_cognito_user_pool_domain" "cognito_domain" {
  domain       = "online-ready-${var.environment}"
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
}
