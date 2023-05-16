# DB Subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${local.name_prefix}-rds-subnet-group"
  description = "Allowed subnets for DB instances"
  subnet_ids  = aws_subnet.db

  tags = merge(local.tags_common, {
    Name = "${local.name_prefix}-rds-subnet-group"
  })
}



# DB instance 

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.default.id
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t2.micro"
  name                   = "nestjs_db"
  username               = "admin"
  password               = local.random_password.rds_password.result
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}
