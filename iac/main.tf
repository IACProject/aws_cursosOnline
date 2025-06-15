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
}

module "cloudwatch_logs_notify" {
  source         = "./modules/monitoring/cloudwatch_logs"
  environment    = var.environment
  retention_days = 14
}

# SQS
module "sqs_files" {
  source = "./modules/sqs_files"
  environment = var.environment
}

# Lambda Files Messenger 
module "iam_files_messenger" {
  source        = "./modules/iam_roles/lambda_exec_role"
  role_name     = "lambda-files-messenger-role"
  s3_bucket_arn = module.s3_archivos.bucket_arn
  dynamodb_table_arn = module.dynamodb_archivos.table_arn
  rds_instance_arn   = module.rds_usuarios.arn
}

# SNS para notificación
module "sns_files" {
  source         = "./modules/sns_files"
  email_receiver = "vascofrann@gmail.com"
}
# Módulo para crear tablas DynamoDB
module "dynamodb" {
  source      = "./modules/dynamodb"
}

module "dynamodb_archivos" {
  source      = "./modules/dynamodb/dynamodb_archivos"
  environment = var.environment
}

module "dynamodb_metadatos_cursos" {
  source      = "./modules//dynamodb/dynamodb_metadatos_cursos"
  environment = var.environment
}

module "dynamodb_dax" {
  source        = "./modules/dynamodb/dynamodb_dax"
  dax_role_arn  = aws_iam_role.dax_service_role.arn
  environment   = var.environment
}

# Crear rol DAX
resource "aws_iam_role" "dax_service_role" {
  name = "dax-service-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dax.amazonaws.com"
        }
      }
    ]
  })
}