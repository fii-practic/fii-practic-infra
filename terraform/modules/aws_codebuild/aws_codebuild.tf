resource "aws_cloudwatch_log_group" "default_log_group" {
  name              = "/aws/codebuild/${var.name}"
  retention_in_days = 7
  tags = {
    Team        = var.team_name
    Environment = var.environment
    Creator     = var.creator
  }

}

resource "aws_iam_role" "default" {
  name = var.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# resource "aws_iam_role_policy" "default" {
#   role = aws_iam_role.default.name

# policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Resource": [
#         "*"
#       ],
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:CreateNetworkInterface",
#         "ec2:DescribeDhcpOptions",
#         "ec2:DescribeNetworkInterfaces",
#         "ec2:DeleteNetworkInterface",
#         "ec2:DescribeSubnets",
#         "ec2:DescribeSecurityGroups",
#         "ec2:DescribeVpcs"
#       ],
#       "Resource": "*"
#     },
#   ]
# }
# POLICY
# }

resource "aws_iam_role_policy_attachment" "attach_AdministratorAccessPolicy" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codebuild_project" "default" {
  name          = "${var.name}-project"
  description   = var.description
  build_timeout = "5"
  service_role  = aws_iam_role.default.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.default_log_group.name
    }

  }

  source {
    type            = "CODECOMMIT"
    location        = var.codecommit_repo
    git_clone_depth = 0

    git_submodules_config {
      fetch_submodules = false
    }
  }

  source_version = "refs/heads/master"

  tags = {
    Team        = var.team_name
    Environment = var.environment
    Creator     = var.creator
  }
}