variable "aws_region" {}
variable "ecs_task_execution_role" {}
variable "ecs_task_role" {}
variable "keycloak_db" {}
variable "keycloak_alb" {}
variable "keycloak_alb_tg" {}
variable "keycloak_ecs_subnet" {}
variable "keycloak_ecs_sg" {}
variable "keycloak_log_group" {}
variable "keycloak_admin_password" {
  type        = string
  description = "Keycloak Admin Password"
  default     = ""
}
