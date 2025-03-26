output "arn_ec2_start_stop_lfunc" {
  value = aws_lambda_function.ec2_start_stop_l_func.arn
}

output "invoke_arn_ec2_start_stop_lfunc" {
  value = aws_lambda_function.ec2_start_stop_l_func.invoke_arn
}

output "version_ec2_start_stop_lfunc" {
  value = aws_lambda_function.ec2_start_stop_l_func.version
}

output "last_modified_ec2_start_stop_lfunc" {
  value = aws_lambda_function.ec2_start_stop_l_func.last_modified
}

output "source_code_size_ec2_start_stop_lfunc" {
  value = aws_lambda_function.ec2_start_stop_l_func.source_code_size
}
