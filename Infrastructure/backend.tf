terraform {
  backend "s3" {
    bucket  = "terraform-example-state-f6v" #replace it with your S3 backend bucket
    encrypt = true
    key     = "terraform.tfstate"
    region  = "eu-central-1"
  }
}
