#Application load balancer for ECS Service

resource "aws_lb" "this" {
  name                       = var.app_name
  internal                   = var.alb_type
  load_balancer_type         = "application"
  ip_address_type            = "ipv4"
  drop_invalid_header_fields = true
  security_groups            = [aws_security_group.alb.id]
  subnets                    = module.demo_vpc.public_subnets
  tags                       = local.tags

  dynamic "access_logs" {
    for_each = var.access_logs_config
    content {
      bucket  = access_logs.value["bucket"]
      prefix  = access_logs.value["prefix"]
      enabled = access_logs.value["enabled"]
    }
  }
  depends_on = [module.demo_vpc]

}

#ALB Listner for port 80

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
  tags = local.tags
}

#Will comment this since we dont have ssl certificate however recommended for production environment 

/*resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}*/

#target group for alb
resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.app_name}-app-lb-tg"
  port     = 3000
  protocol = "HTTP"
  health_check {
    path                = "/status"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  target_type = "ip"
  vpc_id      = module.demo_vpc.vpc_id
  tags        = local.tags
  depends_on  = [module.demo_vpc]
}

#security_groups for alb load_balancer

resource "aws_security_group" "alb" {
  vpc_id      = module.demo_vpc.vpc_id
  name        = "${var.app_name}-app-lb-sg"
  description = "Security Group for ${var.app_name} ECS"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outbound traffic from AWS VPC"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow traffic from public internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow traffic from public internet"
  }

  tags       = local.tags
  depends_on = [module.demo_vpc]
}