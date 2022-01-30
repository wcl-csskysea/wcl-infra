resource "github_team" "teams" {
  count       = length(var.teams)
  name        = var.teams[count.index].name
  description = var.teams[count.index].description
  privacy     = "closed"
}

resource "github_team_membership" "team_1_membership" {
  count    = length(var.team_1_membership)
  team_id  = github_team.teams[0].id
  username = var.team_1_membership[count.index]
  role     = "member"
}