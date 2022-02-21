locals {
  # Deal with null values
  grafana_admin_teams  = coalesce(var.grafana_admin_teams, [])
  grafana_editor_teams = coalesce(var.grafana_editor_teams, [])
  grafana_viewer_teams = coalesce(var.grafana_viewer_teams, [])
  grafana_admin_users  = coalesce(var.grafana_admin_users, [])
  grafana_editor_users = coalesce(var.grafana_editor_users, [])
  grafana_viewer_users = coalesce(var.grafana_viewer_users, [])

  # Members in GitHub username format, including only ones belong to a team
  grafana_admin_members = flatten([
    for team in local.grafana_admin_teams :
    var.github_teams[index(var.github_teams.*.slug, team)].members
  ])
  grafana_editor_members = flatten([
    for team in local.grafana_editor_teams :
    var.github_teams[index(var.github_teams.*.slug, team)].members
  ])
  grafana_viewer_members = flatten([
    for team in local.grafana_viewer_teams :
    var.github_teams[index(var.github_teams.*.slug, team)].members
  ])

  # Users in Grafana user email format, including both ones belong to a team and ones do not
  grafana_admin_all_users  = flatten([local.grafana_admin_users, local.grafana_admin_members])
  grafana_editor_all_users = flatten([local.grafana_editor_users, local.grafana_editor_members])
  grafana_viewer_all_users = flatten([local.grafana_viewer_users, local.grafana_viewer_members])

  # Map username to email, in order to be consistent with Grafana provider representation.
  grafana_admin_emails  = [for user in local.grafana_admin_all_users : var.grafana_users[user].email]
  grafana_editor_emails = [for user in local.grafana_editor_all_users : var.grafana_users[user].email]
  grafana_viewer_emails = [for user in local.grafana_viewer_all_users : var.grafana_users[user].email]
}

resource "grafana_organization" "org" {
  name         = var.grafana_org_name
  admin_user   = var.grafana_site_admin
  create_users = false

  # Keep site admin in admins list
  admins = flatten([var.grafana_site_admin, local.grafana_admin_emails])
  # Avoid specifying a user multiple times; keep it with the highest possible role
  editors = setsubtract(local.grafana_editor_emails, local.grafana_admin_emails)
  viewers = setsubtract(setsubtract(local.grafana_viewer_emails, local.grafana_admin_emails), local.grafana_editor_emails)
}
