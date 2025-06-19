data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/bin/notify.zip"
  
  source {
    content  = "exports.handler = async (event) => { return { statusCode: 200, body: 'Notify Lambda' }; };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "notify" {
  function_name    = "lambda-notify"
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  role             = var.role_arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = {
    Name        = "NotifyLambda"
    Environment = var.environment
  }
}