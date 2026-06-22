# Backend bootstraping terraform module

This module bootstraps terraform backend, using `Cloudflare R2 S3 buckets`.

## Usage guide

### Prerequisites

Before running the module, make sure the following requirements are met:

#### Tools

- **Terraform CLI**: version `~> 1.15.2`.

#### Environment Variables

- `INFISICAL_UNIVERSAL_AUTH_CLIENT_ID`: Machine identity client ID with read access to the project.
- `INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET`: Machine identity client secret.
- `AWS_DEFAULT_REGION`: Set to `auto` or any dummy value to satisfy the AWS S3 SDK (since connections are routed via S3 endpoints).

#### Infisical Secrets

In the Infisical workspace (specified by `infisical_project_id`) under the folder path (specified by `infisical_folder_path`) for the environment (specified by `infisical_env_slug`), ensure the following secret exists:

- `cloudflare_api_token`: A Cloudflare Account API token with these permissions:
  - Account API Tokens Write
  - Account API Tokens Read
  - Workers R2 Storage Write
  - Workers R2 Storage Read

#### Terraform Variables

Ensure these input variables are supplied (e.g., in a `terraform.tfvars` file or via `TF_VAR_*` environment variables):

- `cloudflare_account_id`: Your Cloudflare account ID.
- `bucket_name`: The name of the R2 bucket to create.
- `infisical_project_id`: Infisical project/workspace ID.
- `infisical_folder_path`: Folder path to secrets in Infisical.
- `infisical_env_slug`: Infisical environment slug.

### Bucket creation

With all the things set up, we can now run:

```bash
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

### Using the newly created s3 backend

After successfully running the above scripts, check the s3 backend info:

- `endpoints.s3`: `terraform output endpoint`
- `AWS_ACCESS_KEY_ID`: `terraform output token_key_id`
- `AWS_SECRET_ACCESS_KEY`: `terraform output token_key_secret`

To use the created s3 backend:

1. Keep the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY exported for backend config
2. Setup this block in the `terraform` block

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
