# DataBase subnet 1

# Route Table
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(local.tags, {
    Name    = "${local.name_prefix}-route_table_db1"
    SubTier = "db"
  })
}

resource "aws_subnet" "db" {
  vpc_id                  = aws_vpc.main_vpc.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = var.subnets_db[0]
  map_public_ip_on_launch = false

  tags = merge(local.tags, {
    Name    = "${local.name_prefix}-subnet_db1"
    Tier    = "Private"
    SubTier = "db"
  })
}



resource "aws_route_table_association" "db_route_table" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.db.id
}



# DataBase subnet 2

resource "aws_subnet" "db2" {
  vpc_id                  = aws_vpc.main_vpc.id
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = var.subnets_db[1]
  map_public_ip_on_launch = false

  tags = merge(local.tags, {
    Name    = "${local.name_prefix}-subnet_db2"
    Tier    = "Private"
    SubTier = "db2"
  })
}



resource "aws_route_table_association" "db_route_table2" {
  subnet_id      = aws_subnet.db2.id
  route_table_id = aws_route_table.db.id
}



# app subnet

# Route Table
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(local.tags, {
    Name    = "${local.name_prefix}-route_table_app"
    SubTier = "app"
  })
}

resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.subnets_app[0]



  tags = merge(local.tags, {
    Name    = "${local.name_prefix}-subnet_app"
    Tier    = "Private"
    SubTier = "app"
  })
}



resource "aws_route_table_association" "app_route_table" {
  subnet_id      = aws_subnet.app.id
  route_table_id = aws_route_table.app.id
}
