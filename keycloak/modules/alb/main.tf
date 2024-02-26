resource "aws_lb" "keycloak_alb" {
  name               = "keycloak-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.keycloak_alb_sg.id]
  subnets            = var.keycloak_alb_subnet.*.id
  ip_address_type    = "dualstack"

  tags = {
    Name = "keycloak-alb"
  }
}

resource "aws_lb_listener" "keycloak_alb_listener" {
  load_balancer_arn = aws_lb.keycloak_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.keycloak_alb_tg.arn
  }
}

resource "aws_lb_target_group" "keycloak_alb_tg" {
  name        = "keycloak-alb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.keycloak_vpc.id
  health_check {
    path     = "/health"
    protocol = "HTTP"
    port     = "traffic-port"
    matcher  = "200-399"
    interval = 30
  }
}
