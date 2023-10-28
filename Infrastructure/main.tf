#Defina tags for cost allocation

locals {
  tags = {
    "team"  = "abc-engineering"
    "Name"  = "demo-app"
    "Owner" = "manoj.bhagwat@xyz.com"
  }
}

#ECS Cluster for application deployment

resource "aws_ecs_cluster" "demo" {
  name = var.app_name
  tags = local.tags
}

#Define fargate as capacity_provider

resource "aws_ecs_cluster_capacity_providers" "demo" {
  cluster_name = aws_ecs_cluster.demo.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

#ECR repository for ECS

resource "aws_ecr_repository" "ecr" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = local.tags
}
