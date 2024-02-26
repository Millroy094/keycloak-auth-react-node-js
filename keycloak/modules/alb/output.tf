output "keycloak_alb" {
  value = aws_lb.keycloak_alb
}

output "keycloak_alb_tg" {
  value = aws_lb_target_group.keycloak_alb_tg
}
