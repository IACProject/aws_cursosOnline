variable "bucket_domain_name" {
  description = "Dominio del bucket S3"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue (dev, prod)"
  type        = string
}

variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}

variable "bucket_arn" {
  description = "ARN del bucket S3"
  type        = string
}