resource "aws_lb" "keycloak_alb" {
  name               = "keycloak-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.keycloak_alb_sg.id]
  subnets            = aws_subnet.auth_subnet.*.id

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
    target_group_arn = aws_lb_target_group.keycloak_abl_tg.arn
  }
}

resource "aws_lb_target_group" "keycloak_abl_tg" {
  name        = "keycloak-abl-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.auth.id

  health_check {
    path     = "/auth/realms/master"
    protocol = "HTTP"
  }
}
