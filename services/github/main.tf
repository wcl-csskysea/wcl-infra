terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }

  backend "oss" {
    bucket              = "terraform-state-omnisaas"
    prefix              = "tfstates"
    key                 = "wiredcraft-infrastructure.tfstate"
    region              = "cn-shanghai"
    tablestore_endpoint = "https://terraform-remote.cn-shanghai.ots.aliyuncs.com"
    tablestore_table    = "wiredcraft_infrastructure_statelock"
  }
}

# define GITHUB_TOKEN in env var
provider "github" {
  owner = "wiredcraft"
}