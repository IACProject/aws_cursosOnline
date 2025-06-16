data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/bin/files-manager.zip"
  
  source {
    content  = "exports.handler = async (event) => { return { statusCode: 200, body: 'Files Manager Lambda' }; };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "files_manager" {
  function_name    = "lambda-files-manager"
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  role             = var.role_arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      S3_BUCKET        = var.s3_bucket_name
      DYNAMODB_TABLE   = var.dynamodb_table_name
    }
  }

  tags = {
    Name        = "FilesManagerLambda"
    Environment = var.environment
  }
}