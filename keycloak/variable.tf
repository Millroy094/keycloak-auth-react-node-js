variable "access_key" {
  type        = string
  description = "The AWS development account access key"
  nullable    = false
}

variable "secret_key" {
  type        = string
  description = "The AWS development account secret key"
  nullable    = false
}

variable "aws_region" {
  type        = string
  description = "The AWS development account region"
  default     = "us-west-2"
}

variable "keycloak_admin_password" {
  type        = string
  description = "Keycloak Admin Password"
  default     = ""
}

