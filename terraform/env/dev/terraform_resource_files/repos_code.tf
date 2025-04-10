# GitHub code repositories

# https://registry.terraform.io/providers/integrations/github/latest/docs

# resource "github_repository" "fii_infra" {
#   name        = "fii-practic-infra"
#   description = "Fii Terraform git repository"
#   visibility  = "private"  # or "public"

#   # Optional configurations
#   has_issues    = true
#   has_wiki      = true
#   has_projects  = true
#   auto_init     = true  # Initialize with README
# }

# resource "github_repository" "cinema_frontend" {
#   name        = "levi9-cinema-fe"
#   description = "Frontend App repository"
#   visibility  = "private"

#   # Optional configurations
#   has_issues    = true
#   has_wiki      = true
#   has_projects  = true
#   auto_init     = true
# }

# resource "github_repository" "cinema_backend" {
#   name        = "levi9-cinema-api"
#   description = "Backend App repository"
#   visibility  = "private"

#   # Optional configurations
#   has_issues    = true
#   has_wiki      = true
#   has_projects  = true
#   auto_init     = true
# }

# # Add a repository to the team
# resource "github_team" "some_team" {
#   name        = "SomeTeam"
#   description = "Some cool team"
# }

# resource "github_repository" "some_repo" {
#   name = "some-repo"
# }

# resource "github_team_repository" "some_team_repo" {
#   team_id    = github_team.some_team.id
#   repository = github_repository.some_repo.name
#   permission = "pull"
# }