output "keycloak_vpc" {
  value = aws_vpc.keycloak_vpc
}

output "keycloak_db_subnet_group" {
  value = aws_db_subnet_group.keycloak_db_subnet_group
}

output "keycloak_alb_subnet" {
  value = aws_subnet.keycloak_alb_subnet
}

output "keycloak_ecs_subnet" {
  value = aws_subnet.keycloak_ecs_subnet
}
output "private_keycloak_routing" {
  value = aws_route_table.private_keycloak_routing
}