data "archive_file" "lambda_courses" {
  type        = "zip"
  source_dir  = "${path.module}/../src/lambda-courses"
  output_path = "${path.module}/bin/lambda-courses.zip"
}

resource "aws_iam_role" "lambda_courses_role" {
  name               = "lambda-courses-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_courses_policy" {
  name = "lambda-courses-policy-${var.environment}"
  role = aws_iam_role.lambda_courses_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query"
        ],
        Resource = aws_dynamodb_table.notifier_table.arn
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "course_validator" {
  function_name    = "course-validator-${var.environment}"
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  role             = aws_iam_role.lambda_courses_role.arn
  filename         = data.archive_file.lambda_courses.output_path
  source_code_hash = data.archive_file.lambda_courses.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.notifier_table.name
    }
  }

  tags = {
    Service = "OnlineReady"
  }
}