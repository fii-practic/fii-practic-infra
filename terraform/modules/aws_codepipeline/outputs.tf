output "codestar_connection_arn" {
  description = "ARN of the AWS CodeStar connection to GitHub"
  value       = aws_codestarconnections_connection.github.arn
}

output "pipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = aws_codepipeline.dafault_codepipeline.arn
}

