
# module "ec2_start_stop"{
#   source                          = "../../modules/aws_lambda_ec2_start_stop"
#   vpc_id                          = module.vpc.id
#   name                            = var.account
#   subnet_ids                      = module.vpc.private_subnets
#   stop_schedule_expression        = "cron(0 16 ? * MON-SUN *)"
#   later_stop_schedule_expression  = "cron(0 20 ? * MON-SUN *)"
#   #start_schedule_expression       = "rate(1 minute)"
#   start_schedule_expression       = "cron(0 7 ? * MON-FRI *)"
# }
