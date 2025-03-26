output "arn" {
  value = aws_codedeploy_app.default_app.arn
}

output "cd_app_name" {
  value = aws_codedeploy_app.default_app.name
}
