data "aws_ecr_image" "keycloak_ecr_image" {
  repository_name = "keycloak"
  image_tag       = "latest"
}
