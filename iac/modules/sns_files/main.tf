resource "aws_sns_topic" "files_topic" {
  name = "files-notification-topic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.files_topic.arn
  protocol  = "email"
  endpoint  = var.email_receiver  # ejemplo: tu_correo@correo.com
}