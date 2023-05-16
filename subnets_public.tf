# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-route_table_public"
    Tier = "Public"
  })
}



# web subnet 
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.subnets_web[0]

  tags = merge(var.tags, {
    Name    = "${local.name_prefix}-subnet_web"
    Tier    = "Public"
    SubTier = "web"
  })
}

resource "aws_route_table_association" "web" {
  count = length(var.subnets_web)

  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.public.id
}

