resource "aws_dynamodb_table" "data_table" {
  name           = var.app_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1 # Modify based on your needs
  write_capacity = 1 # Modify based on your needs
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
  tags = local.tags
}
