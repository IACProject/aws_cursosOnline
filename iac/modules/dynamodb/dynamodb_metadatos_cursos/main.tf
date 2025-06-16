resource "aws_dynamodb_table" "metadatos_cursos" {
  name           = "metadatos_cursos"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "curso_id"

  attribute {
    name = "curso_id"
    type = "S"
  }

  tags = {
    Name        = "MetadatosCursos"
    Environment = var.environment
  }
}