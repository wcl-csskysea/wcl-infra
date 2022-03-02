inputs = {
  grafana_server_admin_teams = []

  grafana_server_admin_users = [
    "JuhaS",
    "kaleocheng",
    "pallxk",
    "xuqingfeng",
    "zbal",
  ]

  grafana_teams = []

  grafana_users = [
    "developer",
  ]

  grafana_orgs = {
    # org_id=1
    "Main Org." = {
      admin_teams = [
        "wcl-devops-lead"
      ]
      editor_teams = [
         "wcl-devops",
         "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users = []
      editor_users = []
      viewer_users = [
        "developer",
      ]
    },

    # org_id=2
    "starbucks" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = []
      viewer_teams = []
      admin_users = []
      editor_users = []
      viewer_users = []
    },

    # org_id=3
    "samsclub" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = []
      viewer_teams = []
      admin_users = []
      editor_users = []
      viewer_users = []
    },

    # org_id=4
    "wiredcraft" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users  = []
      editor_users = []
      viewer_users = []
    },

    # org_id=5
    "hilton" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users = []
      editor_users = []
      viewer_users = [
        "James.Sun3",
        "William.Tan",
        "frank.gu",
      ]
    },

    # org_id=8
    "Wiredcraft" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users = []
      editor_users = []
      viewer_users = [
        "developer",
      ]
    },

    # org_id=10
    "burberry" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users = []
      editor_users = []
      viewer_users = [
        "developer"
      ]
    },

    # org_id=11
    "goat" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users = []
      editor_users = []
      viewer_users = [
        "vincent.huang"
      ]
    },

    # org_id=12
    "Bei" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = []
      viewer_teams = []
      admin_users = []
      editor_users = []
      viewer_users = [
        "wcl-access-grafana"
      ]
    },

    # org_id=13
    "omni" = {
      admin_teams  = [
        "wcl-devops-lead",
      ]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users  = []
      editor_users = []
      viewer_users = []
    },

    # org_id=14
    "tiffany" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users = []
      editor_users = []
      viewer_users = [
        "Candy.Hou@tiffany.com",
        "JuhaPersonal",
        "developer",
      ]
    },

    # org_id=15
    "timevallee" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = []
      viewer_teams = []
      admin_users = []
      editor_users = []
      viewer_users = []
    },

    # org_id=16
    "swire" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = []
      viewer_teams = []
      admin_users = [
      ]
      editor_users = []
      viewer_users = []
    },

    # org_id=17
    "zara" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users = []
      editor_users = []
      viewer_users = []
    },

    # org_id=18
    "omnisaas" = {
      admin_teams  = [
        "wcl-devops-lead"
      ]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users = []
      editor_users = []
      viewer_users = []
    },

    # org_id=19
    "teleport" = {
      admin_teams  = ["wcl-devops-lead"]
      editor_teams = []
      viewer_teams = []
      admin_users  = []
      editor_users = []
      viewer_users = []
    },

    # org_id=20
    "blue" = {
      admin_teams  = ["wcl-devops-lead"]
      editor_teams = []
      viewer_teams = []
      admin_users = []
      editor_users = []
      viewer_users = []
    },

    # org_id=21
    "Github-Runner" = {
      admin_teams  = ["wcl-devops-lead"]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = []
      admin_users = []
      editor_users = []
      viewer_users = []
    },

    # org_id=22
    "SuitSupply" = {
      admin_teams  = ["wcl-devops-lead"]
      editor_teams = [
        "wcl-devops",
        "wcl-devops-new"
      ]
      viewer_teams = [
        "wcl-access-grafana"
      ]
      admin_users = []
      editor_users = []
      viewer_users = []
    },
  }
}
