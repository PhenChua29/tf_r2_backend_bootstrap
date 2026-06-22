variable "bucket_name" {
  type        = string
  description = "Name of the backend s3 bucket for creation."
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account id"
}

variable "infisical_project_id" {
  type        = string
  description = "Infisical workspace/project ID"
}

variable "infisical_folder_path" {
  type        = string
  description = "Folder path to secrets in Infisical"
}

variable "infisical_env_slug" {
  type        = string
  description = "Infisical environment slug"
}
