output "repository_id" {
  value = aws_codecommit_repository.default.repository_id
}

output "arn" {
  value = aws_codecommit_repository.default.arn
}

output "clone_url_http" {
  value = aws_codecommit_repository.default.clone_url_http
}