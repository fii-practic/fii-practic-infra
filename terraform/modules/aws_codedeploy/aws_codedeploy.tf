resource "aws_codedeploy_app" "default_app" {
  compute_platform = "ECS"
  name             = "${var.name}-codedeploy-app"
  tags_all = {
    Team        = var.team_name
    Environment = var.environment
  }
}

resource "aws_iam_role" "default_role" {
  name = "${var.name}-codedeploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.default_role.name
}

resource "aws_codedeploy_deployment_group" "default_deployment_group" {
  app_name               = aws_codedeploy_app.default_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.name}-deploymentgroup"
  service_role_arn       = aws_iam_role.default_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listner]
      }

      target_group {
        name = var.fe_blue_tg
      }

      target_group {
        name = var.fe_green_tg
      }
    }
  }
}