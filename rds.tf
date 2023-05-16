#Password for RDS
resource "random_password" "rds_password" {
  length  = 16
  special = false

  lifecycle {
    ignore_changes = all
  }
}

# DB Subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${local.name_prefix}-rds-subnet-group"
  description = "Allowed subnets for DB instances"
  subnet_ids  = [aws_subnet.db.id]

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-rds-subnet-group"
  })
}



# DB instance 

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t2.micro"
  name                   = "nestjs_db"
  username               = "admin"
  password               = random_password.rds_password.result
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}
