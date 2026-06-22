data "infisical_secrets" "r2" {
  env_slug     = var.infisical_env_slug
  workspace_id = var.infisical_project_id
  folder_path  = var.infisical_folder_path
}

provider "infisical" {}

provider "cloudflare" {
  api_token = data.infisical_secrets.r2.secrets["cloudflare_api_token"].value
}
