variable "bucket_name" {
  type        = string
  description = "Name of the backend s3 bucket for creation"
}

variable "bucket_location" {
  type        = string
  description = "Location of the bucket. Available values: \"apac\", \"eeur\", \"enam\", \"weur\", \"wnam\", \"oc\""
  default     = "apac"
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account id"
}

