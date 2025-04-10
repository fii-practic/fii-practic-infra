module "levi9_cinema_fe_codebuild_project" {
  source      = "../../modules/aws_codebuild"
  name        = "levi9-cinema-fe"
  description = "Levi9 cinema front end codebuild project"
  team_name   = "Levi9-FE-Dev"
  github_repo = "https://github.com/fii-practic/levi9-cinema-fe"
  environment = var.env
}

module "levi9_cinema_api_codebuild_project" {
  source      = "../../modules/aws_codebuild"
  name        = "levi9-cinema-api"
  description = "Levi9 cinema backend api codebuild project"
  team_name   = "Levi9-BE-Dev"
  github_repo = "https://github.com/fii-practic/levi9-cinema-api.git"
  environment = var.env
}