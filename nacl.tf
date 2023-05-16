# Public NACLS
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main_vpc.id
  subnet_ids = [aws_subnet.web.id]

  # Ingress rules
  # Allow all local traffic
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main_vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  # Allow HTTPS traffic from the internet
  ingress {
    protocol   = "tcp"
    rule_no    = 105
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allow HTTP traffic from the internet
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Allow the ephemeral ports from the internet
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1025
    to_port    = 65534
  }

  ingress {
    protocol   = "udp"
    rule_no    = 125
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1025
    to_port    = 65534
  }

  # Egress rules
  # Allow all ports, protocols, and IPs outbound
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-public-nacl"
  })
}

#Private Nacls 

#App layer
resource "aws_network_acl" "app" {
  vpc_id     = aws_vpc.main_vpc.id
  subnet_ids = [aws_subnet.app.id]

  # Ingress rules
  # Allow only local traffic
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main_vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  # Egress rules
  # Allow all ports, protocols, and IPs outbound
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-app-nacl"
  })
}

# RDS MS SQL NACL
resource "aws_network_acl" "db" {
  vpc_id     = aws_vpc.main_vpc.id
  subnet_ids = [aws_subnet.db.id]

  # Ingress rules
  # Allow MSSQL port from internal network
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 1433
    to_port    = 1433
  }

  # Egress rules
  # Allow MSSQL port to internal network
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 1433
    to_port    = 1433
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-db-nacl"
  })
}