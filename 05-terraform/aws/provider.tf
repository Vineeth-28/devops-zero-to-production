# provider.tf
# Terraform + provider version constraints, and the AWS provider itself.
# No credentials live here — see ../concepts/providers.md for authentication.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Example remote backend (commented out — enable for real/team use).
  # See ../concepts/backends.md for why remote state matters.
  #
  # backend "s3" {
  #   bucket = "my-team-terraform-state"
  #   key    = "revision/aws/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region
  # Authentication comes from environment variables, a shared credentials
  # file/profile, or an assumed IAM role — never hardcoded here.
}
