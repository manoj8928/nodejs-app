# Define the task definition
resource "aws_ecs_task_definition" "task" {
  family = "${var.app_name}-task"
  cpu    = var.container_cpu
  memory = var.container_memory
  container_definitions = jsonencode([
    {
      name  = "demo-container"
      image = var.docker_image
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
           logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = "${data.aws_region.current.name}"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  tags                     = local.tags
}

#Define cloudwatch loggroup for logging application

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/${var.app_name}"
  retention_in_days = 14
}

# Define the ECS service
resource "aws_ecs_service" "demo_service" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.demo.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    security_groups = [aws_security_group.ecs_sg.id]
    subnets         = [module.demo_vpc.private_subnets]
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
  vpc_id      = module.demo_vpc.vpc_id
  name        = "${var.app_name}-app-lb-sg"
  description = "Security Group for ${var.app_name} ALB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outbound traffic from AWS VPC"
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "Allow traffic from alb"
  }

  tags = local.tags
}
