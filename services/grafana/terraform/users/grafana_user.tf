# Combine users and teams into a set of users
locals {
  admins = toset(
    flatten([
      var.grafana_server_admin_users,
      [
        for team in var.grafana_server_admin_teams :
        var.github_teams[index(var.github_teams.*.slug, team)].members
      ],
    ])
  )
  users = toset(
    flatten([
      var.grafana_users,
      [
        for team in var.grafana_teams :
        var.github_teams[index(var.github_teams.*.slug, team)].members
      ]
    ])
  )
}

resource "random_password" "grafana_users" {
  for_each = toset(flatten([local.admins, local.users]))

  length  = 16
  special = false
}

resource "grafana_user" "users" {
  for_each = toset(flatten([local.admins, local.users]))

  email    = each.key
  login    = each.key
  password = random_password.grafana_users[each.key].result
  is_admin = contains(local.admins, each.key)

  lifecycle {
    ignore_changes = [
      email,    // Synced via GitHub
      login,    // Synced via GitHub
      name,     // Synced via GitHub
      password, // Do not change password of existing/imported users
    ]
  }
}
