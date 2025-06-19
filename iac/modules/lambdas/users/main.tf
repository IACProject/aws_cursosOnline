data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/bin/lambda-users.zip"
  
  source {
    content  = "exports.handler = async (event) => { return { statusCode: 200, body: 'Users Lambda' }; };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "users" {
  function_name    = "lambda-users"
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  role             = var.role_arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      DB_HOST       = var.db_host
      DB_NAME       = var.db_name
      DB_USER       = var.db_user
      DB_PASSWORD   = var.db_password
      S3_PUBLIC_URL = var.s3_public_url
    }
  }

  tags = {
    Name        = "LambdaUsers"
    Environment = var.environment
  }
}