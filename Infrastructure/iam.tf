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

data "aws_iam_policy_document" "dynamodb_demo_policy_doc" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = ["arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.app_name}"]
  }
}

resource "aws_iam_policy" "dynamodb_demo_policy" {
  name        = "DynamoDBDemoReadWrite"
  description = "Provides read and write access to the 'demo' DynamoDB table."

  policy = data.aws_iam_policy_document.dynamodb_demo_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "demo_policy_attachment" {
  policy_arn = aws_iam_policy.dynamodb_demo_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}


