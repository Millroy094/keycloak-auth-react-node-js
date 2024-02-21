provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "auth" {
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
  cidr_block                       = "10.0.0.0/16"

  tags = {
    Name = "auth"
  }
}

resource "aws_subnet" "auth_subnet" {
  count                           = 2
  vpc_id                          = aws_vpc.auth.id
  availability_zone               = var.availability_zones[count.index]
  cidr_block                      = cidrsubnet(aws_vpc.auth.cidr_block, 4, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.auth.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "Auth Subnet ${count.index}"
  }
}

resource "aws_internet_gateway" "auth-gateway" {
  vpc_id = aws_vpc.auth.id

  tags = {
    Name = "Auth internet gateway"
  }
}

resource "aws_route_table" "auth-routing" {
  vpc_id = aws_vpc.auth.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.auth-gateway.id
  }

  tags = {
    Name = "Auth Net rules"
  }
}

resource "aws_route_table_association" "subnet_association" {
  count          = 2
  subnet_id      = element(aws_subnet.auth_subnet.*.id, count.index)
  route_table_id = aws_route_table.auth-routing.id
}

resource "aws_security_group" "keycloak_sg" {
  name   = "keycloak-sg"
  vpc_id = aws_vpc.auth.id

  # Default rule to allow inbound traffic from anywhere on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Default rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
