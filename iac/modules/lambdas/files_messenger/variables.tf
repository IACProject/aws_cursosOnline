variable "role_arn" {
  description = "ARN del rol de ejecución para Lambda"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue (dev, prod)"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN de la cola SQS que activará Lambda"
  type        = string
}