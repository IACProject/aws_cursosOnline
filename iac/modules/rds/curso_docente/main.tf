resource "aws_db_instance" "curso_docente_db" {
  identifier             = "curso-docente-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "OnlineReady"
  username               = "dbadmin"
  password               = var.db_password
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name        = "CursoDocenteDB"
    Environment = var.environment
  }
}