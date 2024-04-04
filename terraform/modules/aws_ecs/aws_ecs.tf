resource "aws_cloudwatch_log_group" "default_log_group" {
  name              = "/aws/ecs/${var.name}"
  retention_in_days = 7
  tags = {
    Team        = var.team_name
    Environment = var.environment
    Creator     = var.creator
  }

}

resource "aws_ecs_cluster" "default_ecs_cluster" {
  name = "${var.name}-cluster"

  tags = {
    Team        = var.team_name
    Environment = var.environment
    Creator     = var.creator
  }
}

resource "aws_ecs_cluster_capacity_providers" "default_capacity_provider" {
  cluster_name = aws_ecs_cluster.default_ecs_cluster.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }

}
