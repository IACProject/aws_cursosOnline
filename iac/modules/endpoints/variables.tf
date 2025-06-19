variable "api_id" {
  description = "ID of the existing API Gateway"
  type        = string
}

variable "api_execution_arn" {
  description = "Execution ARN of the API Gateway"
  type        = string
}

variable "parent_id" {
  description = "Parent resource ID (root resource of API Gateway)"
  type        = string
}

variable "lambda_cursos_invoke_arn" {
  description = "ARN to invoke the cursos lambda function"
  type        = string
}

variable "lambda_users_invoke_arn" {
  description = "ARN to invoke the users lambda function"
  type        = string
}

variable "lambda_files_manager_invoke_arn" {
  description = "ARN to invoke the files manager lambda function"
  type        = string
}

variable "lambda_cursos_function_name" {
  description = "Name of the cursos lambda function"
  type        = string
}

variable "lambda_users_function_name" {
  description = "Name of the users lambda function"
  type        = string
}

variable "lambda_files_manager_function_name" {
  description = "Name of the files manager lambda function"
  type        = string
}