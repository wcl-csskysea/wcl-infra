module "grafana_orgs" {
  for_each = var.grafana_orgs
  source   = "./org"

  github_teams  = local.github_teams
  grafana_users = module.grafana_users.grafana_users

  grafana_org_name     = each.key
  grafana_admin_teams  = each.value.admin_teams
  grafana_editor_teams = each.value.editor_teams
  grafana_viewer_teams = each.value.viewer_teams
  grafana_admin_users  = each.value.admin_users
  grafana_editor_users = each.value.editor_users
  grafana_viewer_users = each.value.viewer_users
}
