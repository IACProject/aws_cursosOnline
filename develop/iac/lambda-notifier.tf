data "archive_file" "lambda_notifier" {
  type        = "zip"
  source_dir  = "${path.module}/../notifier"
  output_path = "${path.module}/bin/lambda-notifier.zip"
}

resource "aws_iam_role" "lambda_notifier_exec_role" {
  name               = "notifier_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  }) 
}

resource "aws_lambda_function" "notifier" {
  function_name = "notifier"
  handler       = "index.handler"
  runtime       = "nodejs22.x"
  role          = aws_iam_role.lambda_notifier_exec_role.arn
  filename     = data.archive_file.lambda_notifier.output_path
  source_code_hash = data.archive_file.lambda_notifier.output_base64sha256
}