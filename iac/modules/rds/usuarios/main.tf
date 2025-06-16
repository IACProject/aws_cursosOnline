resource "aws_db_instance" "usuarios_db" {
  identifier             = "online-ready-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                   = "onlineready"
  username               = "dbadmin"
  password               = var.db_password
  publicly_accessible    = true
  skip_final_snapshot    = true
  deletion_protection    = false
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name        = "OnlineReadyRDS"
    Environment = var.environment
  }
}