resource "aws_sqs_queue" "files_queue" {
  name = "files-processing-queue"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name        = "FilesQueue"
    Environment = var.environment
  }
}

resource "aws_sqs_queue" "dlq" {
  name = "files-dlq"

  tags = {
    Name        = "FilesDeadLetterQueue"
    Environment = var.environment
  }
}
