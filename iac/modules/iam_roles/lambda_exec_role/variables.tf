variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
  default     = ""
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  type        = string
  default     = ""
}

variable "rds_instance_arn" {
  description = "ARN of the RDS instance"
  type        = string
  default     = ""
}

variable "extra_policy_statements" {
  description = "Additional policy statements"
  type        = list(any)
  default     = []
}