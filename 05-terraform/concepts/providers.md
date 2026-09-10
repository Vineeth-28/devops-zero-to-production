# Providers

## What Is a Provider?

A provider is a plugin that lets Terraform talk to a specific platform's
API — AWS, Azure, GCP, Kubernetes, GitHub, Cloudflare, and hundreds of
others. Terraform's core engine knows nothing about "EC2 instances" or
"S3 buckets" — the AWS provider is what translates HCL resource blocks
into AWS API calls.

```
Terraform Core (state, graph, plan/apply engine)
      +
Provider Plugin (AWS, Azure, GCP, Kubernetes, ...)
      =
Ability to manage that platform's resources
```

## Why Providers Are Required

Without a provider, Terraform has no idea how to create anything. Every
`resource` block belongs to a provider, and Terraform needs that
provider's plugin downloaded (via `terraform init`) before it can plan or
apply anything referencing it.

## Common Providers

- `aws` — Amazon Web Services
- `azurerm` — Microsoft Azure
- `google` — Google Cloud Platform
- `kubernetes` — Kubernetes clusters
- `github` — GitHub repos, teams, branch protection
- `cloudflare` — DNS, CDN, WAF rules

## Safe AWS Provider Example

```hcl
# provider.tf
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # No hardcoded access keys here — see authentication note below.
}
```

## Authentication — Never Hardcode Secrets

Do **not** put `access_key` / `secret_key` directly in `.tf` files. Use
one of these instead:

- Environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`,
  `AWS_SESSION_TOKEN`)
- A shared credentials file (`~/.aws/credentials`) with a named profile
- An IAM role attached to the execution environment (EC2 instance
  profile, ECS task role, CI/CD runner's assumed role) — this is the
  preferred approach in production and avoids long-lived credentials
  entirely
- Identity federation (OIDC) from CI/CD systems like GitHub Actions
  assuming an IAM role directly, with no stored secret at all

Whatever mechanism you choose, the `.tf` files themselves should contain
**zero** secrets. Terraform files get committed to Git; credentials do
not.
