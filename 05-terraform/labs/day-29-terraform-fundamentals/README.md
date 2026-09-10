# Day 29 — Terraform Fundamentals

## Objective

Get comfortable with the full local Terraform loop — write, format,
validate, init, plan, apply, inspect, destroy — using a single resource
before touching anything more complex.

## Prerequisites

- Terraform CLI installed (`terraform version` works)
- An AWS account and credentials configured (env vars, profile, or role)
- Read `../../concepts/terraform-overview.md`,
  `../../concepts/resources.md`, and `../../concepts/providers.md` first

## Concepts Covered

- Provider configuration
- Resource blocks
- The init → plan → apply loop
- Outputs
- Safe destroy

## Hands-On Tasks

1. Create a new directory and a Terraform configuration in it.
2. Configure the AWS provider (region only — no hardcoded credentials).
3. Create a single `aws_instance` resource using a `t3.micro` instance
   type and a data-sourced Ubuntu AMI (see
   `../../modules/ec2/main.tf` for the AMI data source pattern).
4. Run `terraform fmt`.
5. Run `terraform validate`.
6. Run `terraform init`.
7. Run `terraform plan` and read every line of the output before
   proceeding.
8. Run `terraform apply` and confirm.
9. Run `terraform output` (after adding an `instance_ip` output) and
   `terraform state list` to inspect what got created.
10. Run `terraform destroy` to safely tear everything down again.

## Expected Output

- A running EC2 instance visible in the AWS console matching your `.tf`
  config.
- `terraform state list` shows exactly one resource plus (if used) one
  data source is *not* listed in state — data sources aren't managed
  resources.
- `terraform plan` after `apply` (with no code changes) shows "No
  changes."
- `terraform destroy` removes the instance cleanly with no leftover
  state entries (`terraform state list` returns empty afterward).

## Interview Questions

- What's the difference between `terraform plan` and `terraform apply`?
- Why does Terraform need `terraform init` before it can do anything
  else?
- What happens if you run `terraform apply` twice in a row with no code
  changes?

## Common Mistakes

- Forgetting `terraform init` after adding a new provider and being
  confused by the resulting error.
- Hardcoding an AMI ID that becomes stale, instead of using a data
  source.
- Running `terraform apply -auto-approve` out of habit, even while
  learning — skipping the review step defeats the point of `plan`.
- Not checking `terraform plan` output carefully before typing "yes."

## Key Takeaways

- The loop (`fmt → validate → init → plan → apply`) is muscle memory you
  should build now, before adding complexity like modules or remote
  state.
- `plan` is not optional to skim — it's the actual diff of what's about
  to happen to real infrastructure.
