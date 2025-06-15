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