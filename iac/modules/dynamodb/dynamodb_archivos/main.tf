resource "aws_dynamodb_table" "registro_archivos" {
  name           = "registro_archivos"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "archivo_id"

  attribute {
    name = "archivo_id"
    type = "S"
  }

  tags = {
    Name        = "registro_archivos"
    Environment = var.environment
  }
}