output "keycloak_cluster" {
  value = aws_ecs_cluster.keycloak_cluster
}

output "keycloak_service" {
  value = aws_ecs_service.keycloak_service
}
