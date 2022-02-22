terraform {
  backend "s3" {
    bucket  = "terraform-infrastructure-state"
    key     = "terraform-grafana/terraform.tfstate"
    region  = "cn-north-1"
    encrypt = true

    dynamodb_table = "terraform-infrastructure-state-lock"
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.20"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.19"
    }
  }
  required_version = "~> 1.1"

  experiments = [
    module_variable_optional_attrs,
  ]
}
