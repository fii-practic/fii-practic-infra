resource "aws_codecommit_repository" "default" {
  repository_name = var.repository_name
  description     = var.description
  tags = {
    Name    = var.repository_name
    Team    = var.team_name
    Creator = var.creator
  }

  lifecycle {
    prevent_destroy = false
  }
}