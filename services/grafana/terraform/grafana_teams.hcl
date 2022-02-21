locals {
  grafana_orgs      = read_terragrunt_config("./inputs.hcl").inputs.grafana_orgs
  grafana_org_names = keys(local.grafana_orgs)
  # Clean up organization names to be valid identifiers
  grafana_org_names_clean = [for name in local.grafana_org_names : replace(name, "/[^A-Za-z0-9_-]/", "")]

  provider_template = file("./grafana_provider.tf.tmpl")
  provider_blocks = formatlist(
    local.provider_template,
    local.grafana_org_names_clean,
    local.grafana_org_names,
  )
  generated_providers = join("\n", local.provider_blocks)

  team_template = file("./grafana_team.tf.tmpl")
  team_blocks = formatlist(
    local.team_template,
    local.grafana_org_names_clean,
    local.grafana_org_names,
  )
  generated_teams = join("\n", local.team_blocks)
}

generate "providers" {
  path      = "grafana_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = local.generated_providers
}

generate "teams" {
  path      = "grafana_teams.tf"
  if_exists = "overwrite_terragrunt"
  contents  = local.generated_teams
}
