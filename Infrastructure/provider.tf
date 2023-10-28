provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      env        = "demo"
      managed_by = "terraform"
    }
  }
}
