resource "aws_vpc_endpoint" "ecr_dkr_vpc_endpoint" {
  vpc_id            = var.keycloak_vpc.id
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"

  security_group_ids = [var.keycloak_vpc_endpoint_sg.id]
  subnet_ids         = var.keycloak_ecs_subnet.*.id

  private_dns_enabled = true

  tags = {
    Name = "ecr-dkr-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_api_vpc_endpoint" {
  vpc_id            = var.keycloak_vpc.id
  vpc_endpoint_type = "Interface"

  service_name = "com.amazonaws.${var.aws_region}.ecr.api"

  security_group_ids = [var.keycloak_vpc_endpoint_sg.id]
  subnet_ids         = var.keycloak_ecs_subnet.*.id

  private_dns_enabled = true
  tags = {
    "Name" = "ecr-api-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  vpc_id            = var.keycloak_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [var.private_keycloak_routing.id]

  tags = {
    "Name" = "s3-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "cloudwatch_vpc_endpoint" {
  vpc_id            = var.keycloak_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [var.keycloak_vpc_endpoint_sg.id]
  subnet_ids         = var.keycloak_ecs_subnet.*.id

  private_dns_enabled = true
  tags = {
    "Name" = "cloudwatch-vpc-endpoint"
  }
}
