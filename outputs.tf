locals {
  buckets_list = [
    for v in cloudflare_account_token.backend_bucket : {
      name             = v.name
      token_key_id     = v.id
      token_key_secret = sha256(v.value)
    }
  ]
}

output "buckets" {
  value     = local.buckets_list
  sensitive = true
}

output "endpoint" {
  value       = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
  description = "Endpoint for s3 backend"
}
