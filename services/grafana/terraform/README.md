# services/grafana/terraform

This directory is the Terraform project to manage Grafana users, teams and organizations, with teams info sourced from GitHub.


## How does this work

From a 10000 foot view of the project, we use Terraform to manage Grafana resources in the following steps:

1.  Read data;

    a.  Read in GitHub organization name (`var.github_organization`), and fetch its teams and team members (`data.github_organization_teams`);
    a.  Read in Grafana server admins (`var.grafana_server_admin_teams` and `var.grafana_server_admin_users`);
    a.  Read in Grafana normal users (`var.grafana_teams` and `var.grafana_users`);
    a.  Read in Grafana organization definitions (`var.grafana_orgs`), this includes organization name, membership and their roles.

1.  Create all Grafana users as defined in `grafana_users.tf`. Users include `var.grafana_server_admin_users`, `var.grafana_users`, `var.grafana_orgs.*.*_users` and their *team* counterparts;

1.  Create all Grafana organizations as defined in `grafana_orgs.tf`. This includes the organization itself and user membership and roles of the organization;

1.  Create all Grafana teams as defined in the generated `grafana_teams.tf`.


## Project Hierarchy

```
services/grafana/terraform
├── org/                # Terraform module for managing Grafana organizations
├── teams/              # Terraform module for managing Grafana teams
├── users/              # Terraform module for managing Grafana users
|
├── terragrunt.hcl      # Terragrunt main config
├── grafana_teams.hcl   # Terragrunt config for generating team related tf files
|
├── grafana_provider.tf.tmpl    # Template for generating `grafana_providers.tf`
├── grafana_team.tf.tmpl        # Template for generating `grafana_teams.tf`
|
├── variables.tf        # Terraform variable definitions
├── inputs.hcl          # Terraform variable values
|
├── github.tf           # Terraform data source for GitHub teams
└── *.tf                # Terraform configs to call orgs/teams/users modules
```


## How to run

1.  Fill in required environment variables in `.env`.

    An example can be found at `.env.example`. The requirements of those env vars and how they are used are also documented in `.env.example`.

1.  Update `inputs.hcl` file to configure Terraform variables.

1.  Apply the configuration:

    ```sh
    # Source and export required environment variables
    set -a
    . .env

    # Apply the configuration
    terragrunt init
    terragrunt apply
    ```


## Import existing users/teams/organizations

1.  To import an existing user, find its ID in *Server Admin -> Users -> User* page, the user ID is shown in URL.

    For example, the `admin` user has an ID of 1 as shown in `https://monitoring.service.wiredcraft.com:4443/admin/users/edit/1`

    Then import it with `terragrunt` command:

    ```sh
    GITHUB_USERNAME=admin
    GRAFANA_USER_ID=1
    terragrunt import \
        "module.grafana_users.grafana_user.users[\"$GITHUB_USERNAME\"]" \
        "$GRAFANA_USER_ID"
    ```

1.  To import an existing organization, find its ID in *Server Admin -> Orgs* page, the org ID is shown along side its name.

    For example, the `Main Org.` organization usually has an ID of 1.

    Then import it with `terragrunt` command:

    ```sh
    GRAFANA_ORG_NAME="Main Org."
    GRAFANA_ORG_ID=1
    terragrunt import \
        "module.grafana_orgs[\"$GRAFANA_ORG_NAME\"].grafana_organization.org" \
        "$GRAFANA_ORG_ID"
    ```

1.  To import an existing team of an existing organization, first make sure you've already import the organization;
    then switch to the organization of the team, navigate to *Configuration -> Teams -> Team* page, the team ID is shown in URL.

    Then import it with `terragrunt` command:

    ```sh
    GITHUB_TEAM_SLUG=wcl-devops
    GRAFANA_TEAM_ID=1
    GRAFANA_ORG_NAME="Main Org."
    terragrunt import \
        "module.grafana_teams_${GRAFANA_ORG_NAME//[^A-Za-z0-9_-]/}.grafana_team.teams[\"$GITHUB_TEAM_SLUG\"]" \
        "$GRAFANA_TEAM_ID"
    ```
