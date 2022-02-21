variable "github_organization" {
  type        = string
  default     = "Wiredcraft"
  description = "The GitHub organization to operate on."
}

variable "grafana_server_admin_teams" {
  type        = set(string)
  default     = []
  description = "GitHub teams whose members will have Grafana Admin role."
}

variable "grafana_server_admin_users" {
  type        = set(string)
  default     = []
  description = "GitHub users who will have Grafana Admin role."
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

variable "grafana_orgs" {
  type = map(object({
    admin_teams  = optional(set(string))
    editor_teams = optional(set(string))
    viewer_teams = optional(set(string))
    admin_users  = optional(set(string))
    editor_users = optional(set(string))
    viewer_users = optional(set(string))
  }))
  default = {}
}
