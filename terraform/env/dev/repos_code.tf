# CodeCommit a.k.a git code repository

module "fii_infra_git_repo" {
  source          = "../../modules/aws_codecommit"
  repository_name = "fii-infra"
  description     = "Fii Terraform git repository"
  team_name       = "Levi9-DevOps"
}

module "levi9_cinema_fe_git_repo" {
  source          = "../../modules/aws_codecommit"
  repository_name = "levi9-cinema-fe"
  team_name       = "Levi9-FE-Dev"
  description     = "Frontend repository"
}

module "levi9_cinema_api_git_repo" {
  source          = "../../modules/aws_codecommit"
  repository_name = "levi9-cinema-api"
  team_name       = "L9-BeDev"
  description     = "Backend App repository"
}