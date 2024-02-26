data "aws_ecr_image" "keycloak_image" {
  repository_name = "keycloak"
  most_recent       = true
}

