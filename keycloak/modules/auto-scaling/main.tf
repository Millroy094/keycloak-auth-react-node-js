resource "aws_appautoscaling_target" "keycloak_ecs_target" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${var.keycloak_cluster.name}/${var.keycloak_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "keycloak_ecs_scaling_policy" {
  name               = "keycloak-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.keycloak_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.keycloak_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.keycloak_ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80.0
  }
}
