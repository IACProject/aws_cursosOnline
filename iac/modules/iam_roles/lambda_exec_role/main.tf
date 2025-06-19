resource "aws_iam_role" "lambda_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.role_name}_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:*:*:*"
      },
      # Solo agregar statements si las variables no están vacías
      {
        Effect   = "Allow",
        Action   = ["s3:PutObject", "s3:GetObject"],
        Resource = var.s3_bucket_arn != "" ? "${var.s3_bucket_arn}/*" : "*"
      },
      {
        Effect   = "Allow",
        Action   = ["dynamodb:PutItem", "dynamodb:GetItem", "dynamodb:Query", "dynamodb:Scan"],
        Resource = var.dynamodb_table_arn != "" ? var.dynamodb_table_arn : "*"
      },
      {
        Effect   = "Allow",
        Action   = ["rds:DescribeDBInstances", "rds:ExecuteStatement"],
        Resource = var.rds_instance_arn != "" ? var.rds_instance_arn : "*"
      }
    ]
  })
}