# # CodeCommit a.k.a git code repository

module "fii_infra_git_repo" {
  source          = "../../modules/aws_codecommit"
  repository_name = "fii-practic-infra"
  team_name       = "Levi9-DevOps-Team"
  description     = "Fii Terraform git repository"
}

module "levi9_cinema_fe_git_repo" {
  source          = "../../modules/aws_codecommit"
  repository_name = "levi9-cinema-fe"
  team_name       = "Levi9-Frontend-Developers-Team"
  description     = "Frontend App repository"
}

module "levi9_cinema_api_git_repo" {
  source          = "../../modules/aws_codecommit"
  repository_name = "levi9-cinema-api"
  team_name       = "Levi9-Backend-Developers-Team"
  description     = "Backend App repository"
}