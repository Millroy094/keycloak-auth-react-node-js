resource "aws_ecs_cluster" "keycloak_cluster" {
  name = "keycloak-cluster"
}

resource "aws_ecs_task_definition" "keycloak" {
  family                   = "keycloak"
  cpu                      = "2048"
  memory                   = "1024"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_execution_role.arn
  task_role_arn            = var.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name   = "keycloak-container"
      image  = "${data.aws_ecr_image.keycloak_image.image_uri}"
      cpu    = 2048
      memory = 1024

      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${var.keycloak_log_group.name}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        {
          name  = "KC_DB"
          value = "postgres"
        },
        {
          name  = "KC_DB_URL"
          value = "jdbc:postgresql://${var.keycloak_db.endpoint}/${var.keycloak_db.db_name}"
        },
        {
          name  = "KC_DB_USERNAME"
          value = "${var.keycloak_db.username}"
        },
        {
          name  = "KC_DB_PASSWORD"
          value = var.keycloak_db.password
        },
        {
          name  = "KEYCLOAK_ADMIN"
          value = "admin"
        },
        {
          name  = "KEYCLOAK_ADMIN_PASSWORD"
          value = "admin"
        },
        {
          name  = "KEYCLOAK_PASSWORD"
          value = "password123!"
        },
        {
          name  = "KC_HOSTNAME_STRICT"
          value = jsonencode(false)
        },
        {
          name  = "KC_EDGE"
          value = jsonencode(false)
        },
        {
          name  = "KC_HEALTH_ENABLED"
          value = jsonencode(true)
        },
        {
          name  = "KC_METRICS_ENABLED"
          value = jsonencode(true)
        },
        {
          name  = "KC_HOSTNAME"
          value = var.keycloak_alb.dns_name
        },
        {
          name  = "KC_FEATURES"
          value = "token-exchange,account-api,admin-api"
        }
      ],
      command = [
        "start-dev"
      ]
    }
  ])
}

resource "aws_ecs_service" "keycloak_service" {
  name            = "keycloak-service"
  cluster         = aws_ecs_cluster.keycloak_cluster.id
  task_definition = aws_ecs_task_definition.keycloak.arn
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.keycloak_alb_tg.arn
    container_name   = "keycloak-container"
    container_port   = 8080
  }

  network_configuration {
    subnets         = var.keycloak_ecs_subnet.*.id
    security_groups = [var.keycloak_ecs_sg.id]
  }

  desired_count = 1
}
