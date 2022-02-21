variable "github_teams" {
  type = list(object({
    slug    = string
    members = set(string)
  }))
  description = "GitHub teams"
}

variable "grafana_users" {
  type = map(object({
    email = string
  }))
  description = "Grafana user resources for mapping username to email."
}

variable "grafana_admin_teams" {
  type        = set(string)
  default     = []
  description = "Grafana team with Admin role to create; its members will by synced from GitHub team with the same name."
}

variable "grafana_editor_teams" {
  type        = set(string)
  default     = []
  description = "Grafana team with Editor role to create; its members will by synced from GitHub team with the same name."
}

variable "grafana_viewer_teams" {
  type        = set(string)
  default     = []
  description = "Grafana team with Viewer role to create; its members will by synced from GitHub team with the same name."
}
