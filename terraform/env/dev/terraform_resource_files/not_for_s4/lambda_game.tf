# Create ZIP file for Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/number_game.zip"
  source {
    content  = file("${path.module}/game.py")
    filename = "game.py"
  }
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "number_game_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create Lambda function
resource "aws_lambda_function" "number_game" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "number_guessing_game"
  role             = aws_iam_role.lambda_role.arn
  handler          = "game.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.12"

  environment {
    variables = {
      DEMO_VAR  = 42
      DEMO_VAR2 = "/var/runtime"
    }
  }
}

# # Optional: Create API Gateway to expose the Lambda function
# resource "aws_apigatewayv2_api" "lambda_api" {
#   name          = "number-game-api"
#   protocol_type = "HTTP"
# }

# resource "aws_apigatewayv2_stage" "lambda_stage" {
#   api_id      = aws_apigatewayv2_api.lambda_api.id
#   name        = "$default"
#   auto_deploy = true
# }

# resource "aws_apigatewayv2_integration" "lambda_integration" {
#   api_id           = aws_apigatewayv2_api.lambda_api.id
#   integration_type = "AWS_PROXY"

#   integration_uri    = aws_lambda_function.number_game.invoke_arn
#   integration_method = "POST"
# }

# resource "aws_apigatewayv2_route" "lambda_route" {
#   api_id    = aws_apigatewayv2_api.lambda_api.id
#   route_key = "POST /play"
#   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# }

# resource "aws_lambda_permission" "api_gw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.number_game.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
# }

# # Output the API Gateway URL
# output "api_endpoint" {
#   value = aws_apigatewayv2_api.lambda_api.api_endpoint
# }

# bash command line testing
# curl -X POST -H "Content-Type: application/json" -d '{"guess": 5}' <api_endpoint_here>/play && echo