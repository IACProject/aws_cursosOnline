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
    Environment = "dev"
  }
}