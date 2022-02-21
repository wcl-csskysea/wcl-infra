terraform {
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
}
