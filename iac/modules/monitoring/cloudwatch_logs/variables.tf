variable "retention_days" {
  description = "Días que se retendrán los logs"
  type        = number
  default     = 14
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}