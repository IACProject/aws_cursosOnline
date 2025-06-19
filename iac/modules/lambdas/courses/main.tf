data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/bin/lambda-courses.zip"
  
  source {
    content  = "exports.handler = async (event) => { return { statusCode: 200, body: 'Courses Lambda' }; };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "courses" {
  function_name    = "lambda-courses"
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
      S3_BUCKET     = var.s3_bucket_name
      DAX_ENDPOINT  = var.dax_endpoint
    }
  }

  tags = {
    Name        = "LambdaCourses"
    Environment = var.environment
  }
}