variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
}

resource "aws_api_gateway_rest_api" "online_ready_api" {
  name        = "online-ready-api-${var.environment}"
  description = "API para la plataforma OnlineReady"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "courses" {
  rest_api_id = aws_api_gateway_rest_api.online_ready_api.id
  parent_id   = aws_api_gateway_rest_api.online_ready_api.root_resource_id
  path_part   = "courses"
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "online-ready-cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.online_ready_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.cognito_user_pool.arn]
}

resource "aws_api_gateway_method" "get_courses" {
  rest_api_id   = aws_api_gateway_rest_api.online_ready_api.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "courses_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.online_ready_api.id
  resource_id             = aws_api_gateway_method.get_courses.resource_id
  http_method             = aws_api_gateway_method.get_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.notifier.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notifier.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.online_ready_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.courses_lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.online_ready_api.id
  stage_name  = var.environment
}

output "api_gateway_invoke_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}