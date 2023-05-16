resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-vpc"
  })
}



#NAT 

resource "aws_eip" "nat" {
  vpc = true
  tags = merge(local.tags, {
    Name = "${local.name_prefix}-elastic_ip"
  })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.app.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-nat_gateway"
  })
}

#Internet Gateway

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-public_igw"
  })
}
