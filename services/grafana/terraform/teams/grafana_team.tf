resource "grafana_team" "teams" {
  for_each = toset(flatten([
    coalesce(var.grafana_admin_teams, []),
    coalesce(var.grafana_editor_teams, []),
    coalesce(var.grafana_viewer_teams, []),
  ]))

  name = each.key
  # Map username to email, and sort in username order, in order to be consistent with Grafana representation.
  members = [
    for username in sort(var.github_teams[index(var.github_teams.*.slug, each.key)].members) :
    var.grafana_users[username].email
  ]
}
