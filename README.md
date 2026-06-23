# Backend Bootstrapping Terraform Module

This Terraform module bootstraps Cloudflare R2 buckets and generates read-write tokens for them.

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
- `bucket_names`: A set of R2 bucket names to create.

Optional variables:

- `bucket_location`: The location of the R2 bucket to create. Available values: "apac", "eeur", "enam", "weur", "wnam", "oc".

### Bucket Creation

With everything set up, we can now run:

```bash
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

### Using the Newly Created S3 Backend

After successfully running the above commands, check the S3 backend info. Since the bucket credentials are sensitive outputs, you can retrieve them in JSON format:

```bash
terraform output -json buckets
```

This will return a JSON list of the created buckets and their credentials:
```json
[
  {
    "name": "<bucket-name>",
    "token_key_id": "<token-key-id>",
    "token_key_secret": "<hashed-token-key-secret>"
  }
]
```

Get the backend endpoint:
- `endpoints.s3`: `terraform output -raw endpoint`

To use one of the created S3 buckets as a backend:

1. Retrieve the credentials (`token_key_id` and `token_key_secret`) for your chosen bucket from the JSON output list and keep them exported as `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` for your backend configuration.
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
