data "aws_caller_identity" "current" {}

data "aws_region" "current" {}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" #Managed policy from AWS required for Fargate execution
  ]
  tags = local.tags
}

resource "aws_iam_role_policy" "dynamodb_inline_policy" {
  name = "DynamoDBInlinePolicy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Effect   = "Allow",
        Resource = ["arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.app_name}"]
      }
    ]
  })
}
