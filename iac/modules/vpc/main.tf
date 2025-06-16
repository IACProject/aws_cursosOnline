# Crear la VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "OnlineReadyVPC"
    Environment = var.environment
  }
}

# Crear una subnet pública
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "OnlineReadyPublicSubnet"
    Environment = var.environment
  }
}

# Crear una subnet privada 
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.private_availability_zone

  tags = {
    Name        = "OnlineReadyPrivateSubnet"
    Environment = var.environment
  }
}

# Crear un Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "OnlineReadyInternetGateway"
    Environment = var.environment
  }
}
resource "aws_db_subnet_group" "main" {
  name       = "my-db-subnet"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]

  tags = {
    Name        = "OnlineReady-DB-SubnetGroup"
    Environment = var.environment
  }
}

# Security Group para RDS
resource "aws_security_group" "database" {
  name_prefix = "database-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "DatabaseSecurityGroup"
    Environment = var.environment
  }
}