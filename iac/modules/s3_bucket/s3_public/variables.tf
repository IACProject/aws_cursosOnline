variable "bucket_name" {
  description = "Nombre del bucket S3 público"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue (dev, prod)"
  type        = string
}
