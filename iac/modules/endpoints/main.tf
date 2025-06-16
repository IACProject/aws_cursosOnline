# Recurso para la ruta "/api/cursos"
resource "aws_api_gateway_resource" "cursos" {
  rest_api_id = var.api_id
  parent_id   = var.parent_id 
  path_part   = "cursos"
}

# Método POST para "/api/cursos"
resource "aws_api_gateway_method" "cursos_post" {
  rest_api_id   = var.api_id
  resource_id   = aws_api_gateway_resource.cursos.id
  http_method   = "POST"
  authorization = "AWS_IAM" # Use AWS_IAM for IAM-based authorization
}

# Integración de la ruta "/api/cursos" con la Lambda correspondiente
resource "aws_api_gateway_integration" "cursos_post_integration" {
  rest_api_id             = var.api_id 
  resource_id             = aws_api_gateway_resource.cursos.id
  http_method             = aws_api_gateway_method.cursos_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_cursos_invoke_arn
}

# Recurso para la ruta "/api/archivos"
resource "aws_api_gateway_resource" "archivos" {
  rest_api_id = var.api_id
  parent_id   = var.parent_id
  path_part   = "archivos"
}

# Método POST para "/api/archivos"
resource "aws_api_gateway_method" "archivos_post" {
  rest_api_id   = var.api_id
  resource_id   = aws_api_gateway_resource.archivos.id
  http_method   = "POST"
  authorization = "AWS_IAM" # Use AWS_IAM for IAM-based authorization
}

# Integración de la ruta "/api/archivos" con la Lambda correspondiente
resource "aws_api_gateway_integration" "archivos_post_integration" {
  rest_api_id             = var.api_id  # Corregido de aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.archivos.id
  http_method             = aws_api_gateway_method.archivos_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_files_manager_invoke_arn
}

# Recurso para la ruta "/api/usuarios"
resource "aws_api_gateway_resource" "usuarios" {
  rest_api_id = var.api_id
  parent_id   = var.parent_id
  path_part   = "usuarios"
}

# Método POST para "/api/usuarios"
resource "aws_api_gateway_method" "usuarios_post" {
  rest_api_id   = var.api_id
  resource_id   = aws_api_gateway_resource.usuarios.id
  http_method   = "POST"
  authorization = "AWS_IAM" # Use AWS_IAM for IAM-based authorization
}

# Integración de la ruta "/api/usuarios" con la Lambda correspondiente
resource "aws_api_gateway_integration" "usuarios_post_integration" {
  rest_api_id             = var.api_id
  resource_id             = aws_api_gateway_resource.usuarios.id
  http_method             = aws_api_gateway_method.usuarios_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_users_invoke_arn
}

# Permisos para que API Gateway pueda invocar las Lambdas
resource "aws_lambda_permission" "allow_lambda_cursos" {
  statement_id  = "AllowLambdaCursos"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_cursos_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_lambda_users" {
  statement_id  = "AllowLambdaUsers"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_users_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_lambda_archivos" {
  statement_id  = "AllowLambdaArchivos"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_files_manager_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/*/*"
}