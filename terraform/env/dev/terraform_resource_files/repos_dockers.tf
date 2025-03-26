# ECR a.k.a Docker repository

module "fe_app_docker_repo" {
  source    = "../../modules/aws_ecr"
  name      = "docker-levi9-cinema-fe"
  team_name = "L9-FeDev"
}

module "be_app_docker_repo" {
  source    = "../../modules/aws_ecr"
  name      = "docker-levi9-cinema-api"
  team_name = "L9-FeDev"
}
