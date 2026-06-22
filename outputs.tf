output "token_key_id" {
  value       = cloudflare_account_token.backend_bucket.id
  sensitive   = true
  description = "Token id for s3 backend"
}

output "token_key_secret" {
  value       = sha256(cloudflare_account_token.backend_bucket.value)
  sensitive   = true
  description = "Token secret for s3 backend"
}

output "endpoint" {
  value       = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
  description = "Endpoint for s3 backend"
}
