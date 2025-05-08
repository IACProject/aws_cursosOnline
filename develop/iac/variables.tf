variable "environment" {
  description = "Ambiente de despliegue (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "domain_name" {
  description = "vascofrann@gmail.com"
  type        = string
}

variable "notification_email" {
  description = "Email para notificaciones"
  type        = string
  default     = "vascofrann@gmail.com"
}

variable "opensearch_master_password" {
  description = "Diego"
  type        = string
  sensitive   = true
}