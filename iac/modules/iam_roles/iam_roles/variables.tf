variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the main S3 bucket for Lambda access"
  type        = string
  default     = ""
}

variable "dynamodb_table_arn" {
  description = "ARN of the main DynamoDB table for Lambda access"
  type        = string
  default     = ""
}

variable "rds_instance_arn" {
  description = "ARN of the RDS instance for Lambda access"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "cursos-online"
}

# Variables específicas para diferentes tipos de roles
variable "enable_s3_access" {
  description = "Whether to enable S3 access for Lambda roles"
  type        = bool
  default     = true
}

variable "enable_dynamodb_access" {
  description = "Whether to enable DynamoDB access for Lambda roles"
  type        = bool
  default     = true
}

variable "enable_rds_access" {
  description = "Whether to enable RDS access for Lambda roles"
  type        = bool
  default     = true
}

# Variables opcionales para personalización de roles específicos
variable "api_handler_extra_policies" {
  description = "Extra policy statements for API handler role"
  type        = list(any)
  default     = []
}

variable "notify_extra_policies" {
  description = "Extra policy statements for notify role"
  type        = list(any)
  default     = []
}