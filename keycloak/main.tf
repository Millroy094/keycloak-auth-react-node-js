provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source       = "./modules/security-groups"
  keycloak_vpc = module.vpc.keycloak_vpc
}

module "db" {
  source                   = "./modules/db"
  keycloak_db_subnet_group = module.vpc.keycloak_db_subnet_group
  keycloak_db_sg           = module.security_groups.keycloak_db_sg
}

module "alb" {
  source              = "./modules/alb"
  keycloak_vpc        = module.vpc.keycloak_vpc
  keycloak_alb_subnet = module.subnet.keycloak_alb_subnet
  keycloak_alb_sg     = module.security_groups.keycloak_alb_sg
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source                  = "./modules/ecs"
  aws_region              = var.aws_region
  ecs_task_execution_role = module.iam.ecs_task_execution_role
  ecs_task_role           = module.iam.ecs_task_role
  keycloak_ecs_subnet     = module.vpc.keycloak_ecs_subnet
  keycloak_ecs_sg         = module.security_groups.keycloak_ecs_sg
  keycloak_db             = module.db.keycloak_db
  keycloak_alb            = module.alb.keycloak_alb
  keycloak_abl_tg         = module.alb.keycloak_abl_tg

  depends_on = [ecr, db, alb]
}
