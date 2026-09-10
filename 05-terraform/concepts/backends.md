# Backends

## What Is a Backend?

A backend determines **where and how Terraform's state is stored**, and
whether Terraform performs operations locally or remotely. It answers:
"when I run `terraform apply`, where does the resulting state file
live?"

## Backend vs Provider — Do Not Confuse These

```
Backend                                Provider
--------                               --------
Controls WHERE STATE IS STORED         Controls HOW RESOURCES ARE CREATED
Example: S3 backend                    Example: AWS provider
Configured in a `terraform {}` block   Configured in a `provider {}` block
Has nothing to do with what            Has nothing to do with where
resources you can create               state lives
```

It's entirely possible (and common) to use the AWS **provider** while
storing state in an S3 **backend** — the two configurations are
independent even though both happen to involve AWS.

## Local Backend

```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```

This is the default if you configure nothing. Fine for solo experiments;
not appropriate for team or production use — no locking guarantees beyond
a single machine, no shared access, easy to lose the file.

## Remote Backend (Example: S3)

```hcl
terraform {
  backend "s3" {
    bucket = "my-team-terraform-state"
    key    = "networking/terraform.tfstate"
    region = "us-east-1"
  }
}
```

Backend configuration lives in its own block, separate from any
`resource` blocks. Changing backend configuration requires running
`terraform init` again (Terraform will offer to migrate existing state
to the new backend).

## Why Backend Matters for Production

- **Shared access** — every team member and every CI job reads/writes the
  same state, instead of each person having their own local copy that
  drifts.
- **Locking** — prevents two simultaneous applies from corrupting state.
- **Durability/backup** — remote object storage typically offers
  versioning and redundancy that a laptop file does not.
- **Security** — state can contain sensitive values; a remote backend can
  be locked down with proper access controls and encryption, unlike a
  plaintext file sitting in a repo checkout.

Full detail on remote state patterns (including locking mechanisms) is in
`production-terraform.md` and `commands/terraform-state.md`.
