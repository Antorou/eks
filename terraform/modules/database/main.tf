resource "random_password" "db" {
  length  = 24
  special = false
}

resource "aws_db_subnet_group" "this" {
  name       = var.name_prefix
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "rds" {
  name   = "${var.name_prefix}-rds"
  vpc_id = var.vpc_id

  ingress {
    description     = "PostgreSQL from EKS nodes only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "this" {
  identifier = var.name_prefix

  engine         = "postgres"
  engine_version = "16"
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db.result

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # No multi-AZ, no automated backups — lab settings to keep cost minimal
  multi_az                = false
  backup_retention_period = 0
  skip_final_snapshot     = true
  publicly_accessible     = false
}
