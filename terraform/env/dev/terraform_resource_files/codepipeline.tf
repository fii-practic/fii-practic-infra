module "levi9_cinema_fe_codepipeline_pipe" {
  source        = "../../modules/aws_codepipeline"
  name          = "levi9-cinema-fe"
  team_name     = "Levi9-FE-Dev"
  description   = "Levi9 cinema frontend pipeline"
  cd_d_grp_name = "fe-deploymentgroup"
  cd_app_name   = module.fe_cd.cd_app_name
  environment   = var.env
  code_repo_arn = module.levi9_cinema_fe_git_repo.arn
}

module "levi9_cinema_api_codepipeline_pipe" {
  source        = "../../modules/aws_codepipeline"
  name          = "levi9-cinema-api"
  team_name     = "Levi9-BE-Dev"
  description   = "Levi9 cinema api pipeline"
  cd_d_grp_name = "api-deploymentgroup"
  cd_app_name   = module.api_cd.cd_app_name
  environment   = var.env
  code_repo_arn = module.levi9_cinema_api_git_repo.arn

}