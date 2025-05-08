# CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Access Identity for CloudFront to access S3 bucket"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = "S3-Bucket-Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Bucket-Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "OnlineReady-CDN"
    Environment = var.environment
  }
}

# S3 Bucket Policy for CloudFront
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontAccess",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "OnlineReadyAPI"
  description = "API for interacting with DynamoDB"
}

# Lambda Function for API Gateway
resource "aws_lambda_function" "api_handler" {
  function_name    = "api-handler"
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  role             = aws_iam_role.api_lambda_exec_role.arn
  filename         = "${path.module}/bin/api-handler.zip"
  source_code_hash = filebase64sha256("${path.module}/bin/api-handler.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.notifier_table.name
    }
  }

  tags = {
    Name        = "APIHandler"
    Environment = var.environment
  }
}

# IAM Role for API Lambda
resource "aws_iam_role" "api_lambda_exec_role" {
  name = "api_lambda_exec_role"
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

resource "aws_iam_role_policy" "api_lambda_policy" {
  name = "api_lambda_policy"
  role = aws_iam_role.api_lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["dynamodb:*"],
        Resource = aws_dynamodb_table.notifier_table.arn
      },
      {
        Effect   = "Allow",
        Action   = ["logs:*"],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# SNS Topic
resource "aws_sns_topic" "notifications" {
  name = "OnlineReadyNotifications"

  tags = {
    Name        = "Notifications"
    Environment = var.environment
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/api-handler"
  retention_in_days = 14

  tags = {
    Name        = "LambdaLogs"
    Environment = var.environment
  }
}