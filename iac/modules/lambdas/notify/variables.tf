variable "role_arn" {
  description = "ARN del rol para ejecutar Lambda"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, prod)"
  type        = string
}