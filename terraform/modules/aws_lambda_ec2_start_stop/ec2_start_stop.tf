
resource "aws_iam_policy" "ec2_start_stop_policy" {
  name        = "${var.name}-ec-start-stop-policy"
  path        = "/"
  description = "Ec2 start stop lambda access policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:StartInstances",
                "ec2:DescribeTags",
                "ec2:StopInstances"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_ec2_permissions_policy" {
  role       = aws_iam_role.ec2_start_stop_role.name
  policy_arn = aws_iam_policy.ec2_start_stop_policy.arn
}

resource "aws_iam_role" "ec2_start_stop_role" {
  name = "${var.name}-ec2-start-stop-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.ec2_start_stop_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "archive_file" "ec2-start-stop" {
  type        = "zip"
  source_file = "${path.module}/files/ec2_start_stop.py"
  output_path = "${path.module}/files/ec2_start_stop.zip"
}

data "aws_security_group" "default_vpc_sg" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_lambda_function" "ec2_start_stop_l_func" {
  filename         = "${path.module}/files/ec2_start_stop.zip"
  function_name    = "${var.name}-ec2-start-stop"
  role             = aws_iam_role.ec2_start_stop_role.arn
  handler          = "ec2_start_stop.lambda_handler"
  source_code_hash = data.archive_file.ec2-start-stop.output_base64sha256
  runtime          = "python3.6"
  timeout          = 15

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [data.aws_security_group.default_vpc_sg.id]
  }
}

resource "aws_cloudwatch_event_rule" "start_event_rule" {
  name                = "${var.name}-start_event_rule"
  description         = "Trigger start ec2 instances by lambda"
  schedule_expression = var.start_schedule_expression
}

resource "aws_cloudwatch_event_rule" "stop_event_rule" {
  name                = "${var.name}-stop_event_rule"
  description         = "Trigger stop ec2 instances by lambda"
  schedule_expression = var.stop_schedule_expression
}

resource "aws_cloudwatch_event_rule" "later_stop_event_rule" {
  name                = "${var.name}-later-stop-event-rule"
  description         = "Later trigger stop ec2 instances by lambda"
  schedule_expression = var.later_stop_schedule_expression
}

resource "aws_cloudwatch_event_target" "start_event_target" {
  target_id = "${var.name}-start-event-target"
  rule      = aws_cloudwatch_event_rule.start_event_rule.name
  arn       = aws_lambda_function.ec2_start_stop_l_func.arn
  input     = "{\"command\":\"start\"}"
}

resource "aws_cloudwatch_event_target" "stop_event_target" {
  target_id = "${var.name}-stop-event-target"
  rule      = aws_cloudwatch_event_rule.stop_event_rule.name
  arn       = aws_lambda_function.ec2_start_stop_l_func.arn
  input     = "{\"command\":\"stop\"}"
}

resource "aws_cloudwatch_event_target" "recheck_stop_event_target" {
  target_id = "${var.name}-later-stop-event-target"
  rule      = aws_cloudwatch_event_rule.later_stop_event_rule.name
  arn       = aws_lambda_function.ec2_start_stop_l_func.arn
  input     = "{\"command\":\"stop\"}"
}

resource "aws_lambda_permission" "allow_cloudwatch_start" {
  statement_id  = "AllowExecutionFromCloudWatchStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_start_stop_l_func.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_event_rule.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_stop" {
  statement_id  = "AllowExecutionFromCloudWatchStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_start_stop_l_func.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_event_rule.arn
}

resource "aws_cloudwatch_log_group" "start_stop_log_group" {
  name              = "/aws/lambda/${var.name}-ec2-start-stop"
  retention_in_days = 7
}