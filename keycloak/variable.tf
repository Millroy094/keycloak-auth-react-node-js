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

variable "s3_keycloak_state_bucket" {
  type        = string
  description = "Keycloak State Bucket Name on S3"
  nullable    = false
}
