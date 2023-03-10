# ECS Service
resource "aws_cloudwatch_log_group" "default_log_group_ecs" {
  name              = "/aws/ecs/${var.name}"
  retention_in_days = 7
  tags              = {
    Team         = var.team_name
    Environment  = var.environment
  }

}

data "template_file" "task_definition" {
  template = file("../../templates/${var.tpl_name}")

  vars = {
    name                  = var.name
    image                 = var.docker_image
    region                = var.region
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecs-task-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_AdministratorAccessPolicy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_ecs_task_definition" "default_task_definition" {
  family                   = var.name
  container_definitions    = data.template_file.task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  #TODO: fix the role later
  execution_role_arn       = aws_iam_role.ecs_task_role.arn

  lifecycle {
    ignore_changes = [ container_definitions ]
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.name}-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.default_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = var.security_groups
    subnets         = var.subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.name
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [
      load_balancer,
      task_definition
    ]
  }
}

