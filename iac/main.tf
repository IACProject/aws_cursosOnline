terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-2"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "dax_role_arn" {
  description = "ARN of the DAX service role"
  type        = string
}

module "cognito" {
  source        = "./modules/cognito"
  environment   = var.environment
  callback_urls = ["http://localhost:3000/callback"]
  logout_urls   = ["http://localhost:3000/logout"]
}

module "cloudfront" {
  source             = "./modules/cloudfront"
  environment        = var.environment
  bucket_name        = module.s3_web.bucket_name
  bucket_domain_name = module.s3_web.bucket_domain_name
  bucket_arn         = module.s3_web.bucket_arn
}

module "s3_web" {
  source       = "./modules/s3_bucket/s3_web"
  bucket_name  = "online-ready-web-${var.environment}"
  environment  = var.environment
}

module "api_gateway" {
  source                      = "./modules/api_gateway"
  api_name                    = "OnlineReadyAPI"
  api_description             = "API for interacting with DynamoDB"
  lambda_notify_invoke_arn    = module.lambda_notify.invoke_arn
  lambda_notify_function_name = module.lambda_notify.function_name
  lambda_cursos_invoke_arn    = module.lambda_courses.invoke_arn
}

module "lambda_api_handler" {
  source              = "./modules/lambdas/api_handler"
  role_arn            = module.iam_roles.api_handler_role_arn
  dynamodb_table_name = module.dynamodb_archivos.table_name
  environment         = var.environment
<<<<<<< Updated upstream
=======
}

module "iam_roles" {
  source = "./modules/iam_roles/iam_roles"
  s3_bucket_arn      = module.s3_archivos.bucket_arn
  dynamodb_table_arn = module.dynamodb_archivos.table_arn
  rds_instance_arn   = module.rds_usuarios.arn 
  environment        = var.environment
}

module "lambda_notify" {
  source      = "./modules/lambdas/notify"
  role_arn    = module.iam_roles.lambda_notify_role_arn
  environment = var.environment
>>>>>>> Stashed changes
}