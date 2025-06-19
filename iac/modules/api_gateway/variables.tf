variable "lambda_notify_invoke_arn" {
  description = "ARN de invocación de la Lambda asociada a /notify"
  type        = string
}

variable "lambda_notify_function_name" {
  description = "Nombre de la Lambda que maneja /notify"
  type        = string
}

variable "api_name" {
  description = "Nombre del API Gateway"
  type        = string
}

variable "api_description" {
  description = "Descripción del API Gateway"
  type        = string
}

variable "lambda_cursos_invoke_arn" {
  description = "ARN de invocación para Lambda Cursos"
  type        = string
}