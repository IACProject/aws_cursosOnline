module "lambda_api_handler_role" {
  source = "../lambda_exec_role"
  role_name = "lambda-api-handler-role"
  
  s3_bucket_arn            = var.s3_bucket_arn
  dynamodb_table_arn       = var.dynamodb_table_arn
  rds_instance_arn         = var.rds_instance_arn
  extra_policy_statements  = []
}

module "lambda_notify_role" {
  source = "../lambda_exec_role"
  role_name = "lambda-notify-role"
  
  s3_bucket_arn            = var.s3_bucket_arn
  dynamodb_table_arn       = var.dynamodb_table_arn
  rds_instance_arn         = var.rds_instance_arn
  extra_policy_statements  = []
}