# Backend Bootstrapping Terraform Module

This Terraform module bootstraps a Cloudflare R2 bucket and then generates a read-write token for the newly created bucket.

The module was made for fast bootstrapping of S3 backends.

## Usage Guide

### Prerequisites

Before running the module, make sure the following requirements are met:

#### Tools

- **Terraform CLI**: version `~> 1.15.2`.

#### Environment Variables

- `AWS_DEFAULT_REGION`: Set to `auto` or any dummy value to satisfy the AWS S3 SDK (since connections are routed via S3 endpoints).
- `CLOUDFLARE_API_TOKEN`: A Cloudflare Account API token with the following permissions:
  - Account API Tokens Write
  - Account API Tokens Read
  - Workers R2 Storage Write
  - Workers R2 Storage Read

#### Terraform Variables

Ensure these input variables are supplied (e.g., in a `terraform.tfvars` file or via `TF_VAR_*` environment variables):

- `cloudflare_account_id`: Your Cloudflare account ID.
- `bucket_name`: The name of the R2 bucket to create.

### Bucket Creation

With everything set up, we can now run:

```bash
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

### Using the Newly Created S3 Backend

After successfully running the above commands, check the S3 backend info:

- `endpoints.s3`: `terraform output endpoint`
- `AWS_ACCESS_KEY_ID`: `terraform output token_key_id`
- `AWS_SECRET_ACCESS_KEY`: `terraform output token_key_secret`

To use the created S3 backend:

1. Keep `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` exported for backend configuration.
2. Set up this block in the `terraform` block:

```terraform
  backend "s3" {
    bucket       = "<bucket-name>"
    key          = "<path/to/state>"
    use_lockfile = true
    endpoints = {
      s3 = "<endpoint>"
    }

    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
```

3. Run `terraform init -migrate-state`
