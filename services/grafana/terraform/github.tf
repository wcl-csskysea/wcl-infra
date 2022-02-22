provider "github" {
  owner = var.github_organization
}

data "github_organization_teams" "all" {}

locals {
  github_teams = data.github_organization_teams.all.teams
}
