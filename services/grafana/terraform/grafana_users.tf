module "grafana_users" {
  source = "./users"

  github_teams = local.github_teams

  grafana_server_admin_teams = var.grafana_server_admin_teams
  grafana_server_admin_users = var.grafana_server_admin_users

  grafana_teams = flatten([
    var.grafana_teams,
    [
      for org in var.grafana_orgs : [
        coalesce(org.admin_teams, []),
        coalesce(org.editor_teams, []),
        coalesce(org.viewer_teams, []),
      ]
    ]
  ])
  grafana_users = flatten([
    var.grafana_users,
    [
      for org in var.grafana_orgs : [
        coalesce(org.admin_users, []),
        coalesce(org.editor_users, []),
        coalesce(org.viewer_users, []),
      ]
    ]
  ])
}
