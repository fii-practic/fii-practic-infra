module "fe_cd" {
  source           = "../../modules/aws_codedeploy"
  name             = "fe"
  ecs_cluster_name = module.levi9_cinema_ecs_cluster.name
  ecs_service_name = module.levi9_cinema_ecs_fe_service.name
  alb_listner      = module.levi9_aio_alb.listner_arn
  fe_green_tg      = module.levi9_aio_alb.fe_tg_green_name
  fe_blue_tg       = module.levi9_aio_alb.fe_tg_blue_name
  environment      = var.env
  team_name        = "DevOps"
}


module "api_cd" {
  source           = "../../modules/aws_codedeploy"
  name             = "api"
  ecs_cluster_name = module.levi9_cinema_ecs_cluster.name
  ecs_service_name = module.levi9_cinema_ecs_api_service.name
  alb_listner      = module.levi9_aio_alb.listner_arn
  fe_green_tg      = module.levi9_aio_alb.api_tg_green_name
  fe_blue_tg       = module.levi9_aio_alb.api_tg_blue_name
  environment      = var.env
  team_name        = "DevOps"
}