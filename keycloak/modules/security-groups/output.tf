output "keycloak_db_sg" {
  value = aws_security_group.keycloak_db_sg
}

output "keycloak_alb_sg" {
  value = aws_security_group.keycloak_alb_sg
}

output "keycloak_ecs_sg" {
  value = aws_security_group.keycloak_ecs_sg
}

output "keycloak_vpc_endpoint_sg" {
  value = aws_security_group.keycloak_vpc_endpoint_sg
}