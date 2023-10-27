# Define the task definition
resource "aws_ecs_task_definition" "${var.app_name}" {
  family = "${var.app_name}-task"
  cpu    = var.container_cpu
  memory = var.container_memory
  container_definitions = jsonencode([
    {
      name  = "${var.app_name}-container"
      image = var.image
      portMappings = [
        {
          containerPort = var.containerPort
          protocol      = "tcp"
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  tags                     = local.tags
}

# Fetch VPC ID
data "aws_vpc" "mkt_admin_panel" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Fetch the private subnet IDs
data "aws_subnet" "private_subnet1" {
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc-private-eu-central-1a"]
  }
}

data "aws_subnet" "private_subnet2" {
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-vpc-private-eu-central-1b"]
  }
}

# Define the ECS service
resource "aws_ecs_service" "${var.app_name}_service" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.${var.app_name}.id
  task_definition = aws_ecs_task_definition.${var.app_name}.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    security_groups = [aws_security_group.ecs_sg.id]
    subnets         = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "${var.app_name}-container"
    container_port   = 3000
  }
  tags = local.tags
}


# Define the security group using existng module

#security_groups for alb load_balancer

resource "aws_security_group" "ecs_sg" {
  vpc_id      = data.aws_vpc.this.id
  name        = "${var.app_name}-app-lb-sg"
  description = "Security Group for ${var.lb_name}"

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outbound traffic from AWS VPC"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
    description = "Allow traffic from alb"
  }

  tags = local.tags
}
