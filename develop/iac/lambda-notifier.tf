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

resource "aws_iam_policy" "lambda_notifier_policy" {
  name        = "notifier_policy"
  description = "IAM policy para función Lambda notifier"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_notifier_policy_attachment" {
  role       = aws_iam_role.lambda_notifier_exec_role.name
  policy_arn = aws_iam_policy.lambda_notifier_policy.arn
}

resource "aws_lambda_function" "notifier" {
  function_name = "notifier"
  handler       = "index.handler"
  runtime       = "nodejs22.x"
  role          = aws_iam_role.lambda_notifier_exec_role.arn
  filename     = data.archive_file.lambda_notifier.output_path
  source_code_hash = data.archive_file.lambda_notifier.output_base64sha256

  environment {
    variables = {
      HELLO = "world"
    }
  }
}