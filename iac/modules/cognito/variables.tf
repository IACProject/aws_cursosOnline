variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
}

variable "callback_urls" {
  description = "URLs de retorno para login exitoso"
  type        = list(string)
}

variable "logout_urls" {
  description = "URLs de retorno para logout"
  type        = list(string)
}