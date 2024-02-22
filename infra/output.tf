output "db_address" {
  value = aws_db_instance.keycloak_db.address
}

output "alb_dns_name" {
  value = aws_lb.keycloak_alb.dns_name
}
