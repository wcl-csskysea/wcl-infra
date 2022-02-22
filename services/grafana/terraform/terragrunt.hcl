retryable_errors = [
  # Grafana errors out sometimes when creating users; a simple retry fixes it.
  # Depending on Grafana version, 422 or 400 error may be returned.
  "status: 422",
  "status: 400",
]
retry_sleep_interval_sec = 3

include "inputs" {
  path = "./inputs.hcl"
}

include "teams" {
  path = "./grafana_teams.hcl"
}
