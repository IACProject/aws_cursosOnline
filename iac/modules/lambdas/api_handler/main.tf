data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/bin/api-handler.zip"
  
  source {
    content  = "exports.handler = async (event) => { return { statusCode: 200, body: 'API Handler Lambda' }; };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "api_handler" {
  function_name    = "api-handler"
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  role             = var.role_arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }

  tags = {
    Name        = "APIHandler"
    Environment = var.environment
  }
}