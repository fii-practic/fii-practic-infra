output "fe_tg_blue_arn" {
  value = aws_alb_target_group.fe_tg_blue.arn
}

output "fe_tg_blue_name" {
  value = aws_alb_target_group.fe_tg_blue.name
}

output "fe_tg_green_name" {
  value = aws_alb_target_group.fe_tg_green.name
}

output "api_tg_blue_arn" {
  value = aws_alb_target_group.api_tg_blue.arn
}

output "api_tg_blue_name" {
  value = aws_alb_target_group.api_tg_blue.name
}

output "api_tg_green_name" {
  value = aws_alb_target_group.api_tg_green.name
}

output "listner_arn" {
  value = aws_lb_listener.default_listener_https.arn
}