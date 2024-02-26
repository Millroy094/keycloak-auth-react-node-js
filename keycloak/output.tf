output "db_address" {
  value = module.db.keycloak_db.address
}

output "alb_dns_name" {
  value = module.alb.keycloak_alb.dns_name
}
