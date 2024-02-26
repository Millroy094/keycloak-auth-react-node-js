terraform {
  backend "s3" {
    bucket = var.s3_keycloak_state_bucket
    region = var.aws_region
    key    = "terraform.tfstate"
  }
}
