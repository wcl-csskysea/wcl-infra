variable "github_teams" {
  type = list(object({
    slug    = string
    members = set(string)
  }))
  description = "GitHub teams"
}

variable "grafana_server_admin_teams" {
  type        = set(string)
  default     = []
  description = "GitHub teams whose members will have Grafana Admin role."
}

variable "grafana_server_admin_users" {
  type        = set(string)
  default     = []
  description = "Users who will have Grafana Admin role."
}

variable "grafana_teams" {
  type        = set(string)
  default     = []
  description = "GitHub teams whose members will be added to Grafana."
}

variable "grafana_users" {
  type        = set(string)
  default     = []
  description = "Users who will be added to Grafana."
}
