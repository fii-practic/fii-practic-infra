resource "aws_security_group" "default_sg" {
  name        = "${var.name}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-sg"
    Team        = var.team_name
    Environment = var.environment
  }
}

resource "aws_alb" "default_alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.default_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}-alb"
    Environment = var.environment
    Team        = var.team_name
  }
}

resource "aws_alb_target_group" "default_tg" {
  name        = "${var.name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_alb_target_group" "fe_tg_blue" {
  name        = "frondend-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_alb_target_group" "fe_tg_green" {
  name        = "frondend-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_alb_target_group" "api_tg_blue" {
  name        = "api-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_alb_target_group" "api_tg_green" {
  name        = "api-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "default_listener_https" {
  load_balancer_arn = aws_alb.default_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = var.cert_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "<p> Hello FiiPractic, this is default LB response</p>"
      status_code  = "200"
    }
  }
}

# Forward action
resource "aws_alb_listener_rule" "fe_routing" {
  listener_arn = aws_lb_listener.default_listener_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.fe_tg_blue.arn
  }

  condition {
    host_header {
      values = ["fe.${var.domain_name}"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}

resource "aws_alb_listener_rule" "api_routing" {
  listener_arn = aws_lb_listener.default_listener_https.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.api_tg_blue.arn
  }

  condition {
    host_header {
      values = ["api.${var.domain_name}"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}

resource "aws_route53_record" "fe_record" {
  zone_id = var.zone_id
  name    = "fe"
  type    = "A"
  alias {
    name                   = element(aws_alb.default_alb.*.dns_name, 0)
    zone_id                = element(aws_alb.default_alb.*.zone_id, 0)
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api_record" {
  zone_id = var.zone_id
  name    = "api"
  type    = "A"
  alias {
    name                   = element(aws_alb.default_alb.*.dns_name, 0)
    zone_id                = element(aws_alb.default_alb.*.zone_id, 0)
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "default_record" {
  zone_id = var.zone_id
  name    = "alb"
  type    = "A"
  alias {
    name                   = element(aws_alb.default_alb.*.dns_name, 0)
    zone_id                = element(aws_alb.default_alb.*.zone_id, 0)
    evaluate_target_health = false
  }
}