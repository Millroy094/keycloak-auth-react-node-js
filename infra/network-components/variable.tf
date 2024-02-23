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

variable "availability_zones" {
  type        = list(string)
  description = "The AWS availability zones for regions"
  default     = ["us-west-2a", "us-west-2b"]
}
