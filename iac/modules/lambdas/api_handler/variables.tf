variable "role_arn" {
  description = "ARN del rol de ejecución de Lambda"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB que utilizará la Lambda"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, prod)"
  type        = string
}