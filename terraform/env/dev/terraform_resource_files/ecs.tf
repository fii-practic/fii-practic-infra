# ECS Cluster:
module "levi9_cinema_ecs_cluster" {
  source      = "../../modules/aws_ecs"
  name        = "levi9-cinema"
  team_name   = "DevOps"
  environment = var.env
}

module "levi9_cinema_ecs_fe_service" {
  source           = "../../modules/aws_ecs_service"
  name             = "levi9-cinema-fe"
  team_name        = "Levi9-FE-Developers"
  environment      = var.env
  docker_image     = "${var.account_ids["dev"]}.dkr.ecr.eu-west-1.amazonaws.com/docker-levi9-cinema-fe:latest"
  tpl_name         = "fe_task_definition.tpl"
  ecs_cluster_id   = module.levi9_cinema_ecs_cluster.id
  subnets          = module.vpc.public_subnets
  target_group_arn = module.levi9_aio_alb.fe_tg_blue_arn
  region           = data.aws_region.current.name
  vpc_id           = module.vpc.id
}

module "levi9_cinema_ecs_api_service" {
  source           = "../../modules/aws_ecs_service"
  name             = "levi9-cinema-api"
  team_name        = "Levi9-BE-Developers"
  environment      = var.env
  docker_image     = "${var.account_ids["dev"]}.dkr.ecr.eu-west-1.amazonaws.com/docker-levi9-cinema-api:latest"
  tpl_name         = "api_task_definition.tpl"
  ecs_cluster_id   = module.levi9_cinema_ecs_cluster.id
  subnets          = module.vpc.public_subnets
  target_group_arn = module.levi9_aio_alb.api_tg_blue_arn
  region           = data.aws_region.current.name
  vpc_id           = module.vpc.id
}