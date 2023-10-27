provider "aws" {
  region = var.region

  default_tags {
    tags = {
      env        = "demo"
      managed_by = "terraform"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-example-state-f6v" #replace it with your S3 backend bucket
    encrypt        = true
    key            = "terraform.tfstate"
    region         = var.region
  }
}