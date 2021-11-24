# entrypoint for terraform

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-infrastructure-state"
    dynamodb_table = "terraform-infrastructure-state-lock"
    key            = "terraform.tfstate"
    region         = "cn-north-1"
  }
}

data "aws_caller_identity" "current" {}
