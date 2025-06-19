resource "aws_lambda_function" "files_messenger" {
  function_name = "lambda-files-messenger"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = var.role_arn
  filename      = "${path.module}/bin/files-messenger.zip"
  source_code_hash = filebase64sha256("${path.module}/bin/files-messenger.zip")

  tags = {
    Name        = "LambdaFilesMessenger"
    Environment = var.environment
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.files_messenger.arn
  batch_size       = 5
  enabled          = true
}