variable "teams" {
  type = list(map(string))
  default = [
    {
      "name" : "team-1",
      "description" : "Team 1",
    }
  ]

}

variable "team_1_membership" {
  type = list(string)
  default = [
    "xuqingfeng",
  ]
}