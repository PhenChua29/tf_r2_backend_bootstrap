terraform {
  required_version = "~> 1.15.2"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.21.0"
    }
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.16.28"
    }
  }

  # backend "local" {
    # path = "state/terraform.state"
  # }

  backend "s3" {
    bucket       = "tfstate-cloudflare-r2"
    key          = "state/terraform.state"
    use_lockfile = true
    endpoints = {
      s3 = "https://3b75aa4988913843d56d261129f9a9c4.r2.cloudflarestorage.com"
    }

    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
}
