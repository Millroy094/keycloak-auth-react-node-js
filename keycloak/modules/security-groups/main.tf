resource "aws_security_group" "keycloak_alb_sg" {
  name   = "keycloak-alb-sg"
  vpc_id = var.keycloak_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "keycloak_ecs_sg" {
  name        = "keycloak-ecs-sg"
  description = "Security group for Keycloak ECS service"
  vpc_id      = var.keycloak_vpc.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.keycloak_alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

}
resource "aws_security_group" "keycloak_vpc_endpoint_sg" {
  name_prefix = "keycloak-vpc-endpoint-sg"
  description = "Associated to ECR/S3 VPC Endpoints"
  vpc_id      = var.keycloak_vpc.id

  ingress {
    description     = "Allow Nodes to pull images from ECR via VPC endpoints"
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = [aws_security_group.keycloak_ecs_sg.id]
  }
}

resource "aws_security_group" "keycloak_db_sg" {
  name        = "keycloak-db-sg"
  vpc_id      = var.keycloak_vpc.id
  description = "Security group for RDS instance"

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_security_group_rule" "ecs_to_postgres" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.keycloak_ecs_sg.id
  security_group_id        = aws_security_group.keycloak_db_sg.id
}
