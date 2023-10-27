resource "aws_dynamodb_table" "data_table" {
  name         = var.app_name
  billing_mode = "PROVISIONED"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
  tags = local.tags
}
