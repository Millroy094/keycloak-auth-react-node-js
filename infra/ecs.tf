resource "aws_db_instance" "keycloak_db" {
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "keycloak"
  username               = "keycloak"
  password               = "keycloak"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.keycloak_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.keycloak_db_sg.id]
  tags = {
    Name = "Keycloak DB"
  }
}

resource "aws_ecs_cluster" "keycloak_cluster" {
  name = "keycloak-cluster"
}

resource "aws_ecs_task_definition" "keycloak" {
  family                   = "keycloak"
  cpu                      = "1024"
  memory                   = "2048"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  depends_on = [aws_db_instance.keycloak_db, aws_lb.keycloak_alb]

  container_definitions = jsonencode([
    {
      name      = "keycloak-container"
      image     = "quay.io/keycloak/keycloak:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      environment = [
        {
          name  = "KC_DB"
          value = "postgres"
        },
        {
          name  = "KC_DB_URL"
          value = "jdbc:postgresql://${aws_db_instance.keycloak_db.endpoint}/${aws_db_instance.keycloak_db.db_name}"
        },
        {
          name  = "KC_DB_USERNAME"
          value = "${aws_db_instance.keycloak_db.username}"
        },
        {
          name  = "KC_DB_PASSWORD"
          value = aws_db_instance.keycloak_db.password
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
          value = aws_lb.keycloak_alb.dns_name
        }
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
    target_group_arn = aws_lb_target_group.keycloak_abl_tg.arn
    container_name   = "keycloak-container"
    container_port   = 8080
  }

  network_configuration {
    subnets          = aws_subnet.auth_subnet.*.id
    security_groups  = [aws_security_group.keycloak_service_sg.id]
    assign_public_ip = true
  }

  desired_count = 1
}
