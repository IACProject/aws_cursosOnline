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

resource "aws_iam_role_policy" "lambda_combined_policy" {
  name = "lambda_combined_policy"
  role = aws_iam_role.lambda_notifier_exec_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.notifier_table.arn
      },
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_lambda_function" "notifier" {
  function_name    = "notifier"
  handler         = "index.handler"
  runtime         = "nodejs18.x"
  role            = aws_iam_role.lambda_notifier_exec_role.arn
  filename        = data.archive_file.lambda_notifier.output_path
  source_code_hash = data.archive_file.lambda_notifier.output_base64sha256

  environment {
    variables = {
      SOURCE_EMAIL      = "vascojekins@gmail.com"
      DESTINATION_EMAIL = "vascofrann@gmail.com"
      DYNAMODB_TABLE    = aws_dynamodb_table.notifier_table.name
    }
  }

  tags = {
    Name        = "notifier"
    Environment = "dev"
    Project     = "cursosonline"
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notifier.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.notifier.arn
    events             = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

resource "aws_ses_email_identity" "sender" {
  email = "vascojekins@gmail.com"
}