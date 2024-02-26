resource "aws_vpc" "keycloak_vpc" {
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Keycloak VPC"
  }
}

resource "aws_subnet" "keycloak_alb_subnet" {
  count                           = 2
  vpc_id                          = aws_vpc.keycloak_vpc.id
  availability_zone               = var.availability_zones[count.index]
  cidr_block                      = cidrsubnet(aws_vpc.keycloak_vpc.cidr_block, 4, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.keycloak_vpc.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "Keycloak load balancer Subnet ${count.index}"
  }
}

resource "aws_subnet" "keycloak_db_subnet" {
  count                           = 2
  vpc_id                          = aws_vpc.keycloak_vpc.id
  availability_zone               = var.availability_zones[count.index]
  cidr_block                      = cidrsubnet(aws_vpc.keycloak_vpc.cidr_block, 4, 4 + count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.keycloak_vpc.ipv6_cidr_block, 8, 4 + count.index)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "Keycloak DB Subnet"
  }
}

resource "aws_db_subnet_group" "keycloak_db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.keycloak_db_subnet.*.id
}


resource "aws_subnet" "keycloak_ecs_subnet" {
  count                           = 2
  vpc_id                          = aws_vpc.keycloak_vpc.id
  availability_zone               = var.availability_zones[count.index]
  cidr_block                      = cidrsubnet(aws_vpc.keycloak_vpc.cidr_block, 4, 8 + count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.keycloak_vpc.ipv6_cidr_block, 8, 8 + count.index)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "Keycloak ECS Subnet"
  }
}

resource "aws_internet_gateway" "keycloak_gateway" {
  vpc_id = aws_vpc.keycloak_vpc.id

  tags = {
    Name = "Keycloak internet gateway"
  }
}

resource "aws_route_table" "keycloak_routing" {
  vpc_id = aws_vpc.keycloak_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.keycloak_gateway.id
  }

  tags = {
    Name = "Keycloak Net rules"
  }
}

resource "aws_route_table_association" "keycloak_subnet_association" {
  count          = 2
  subnet_id      = element(aws_subnet.keycloak_alb_subnet.*.id, count.index)
  route_table_id = aws_route_table.keycloak_routing.id
}


