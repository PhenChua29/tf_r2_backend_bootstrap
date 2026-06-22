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

  backend "local" {
    path = "state/terraform.state"
  }
}

provider "cloudflare" {}
