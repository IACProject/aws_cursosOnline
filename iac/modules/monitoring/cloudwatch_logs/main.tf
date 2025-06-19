resource "aws_cloudwatch_log_group" "lambda_notify_logs" {
  name              = "/aws/lambda/lambda-notify"
  retention_in_days = var.retention_days

  tags = {
    Name        = "LambdaNotifyLogs"
    Environment = var.environment
  }
}