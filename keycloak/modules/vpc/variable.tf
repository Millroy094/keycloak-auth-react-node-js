variable "availability_zones" {
  type        = list(string)
  description = "The AWS availability zones for regions"
  default     = ["us-west-2a", "us-west-2b"]
}
