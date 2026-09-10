# Day 31 — Terraform in Production

## Objective

Pull everything together into something close to how a real team would
structure and operate Terraform: modules, remote backend, variables per
environment, CI/CD, and a troubleshooting mindset.

## Prerequisites

- Day 29 and Day 30 completed
- Read `../../concepts/modules.md`, `../../concepts/production-terraform.md`,
  and `../../workflows/terraform-cicd-workflow.md`

## Concepts Covered

- Modules (VPC, EC2, Security Group)
- AWS provisioning end-to-end
- Remote backend
- Variables and outputs across module boundaries
- Production folder structure
- CI/CD integration
- Security practices
- Troubleshooting workflow

## Hands-On Tasks

1. Refactor the Day 29/30 single-file config into the three modules
   under `../../modules/` (vpc, security-group, ec2) — call them from a
   root configuration, wiring outputs into inputs as shown in
   `../../modules/README.md`.
2. Configure a remote S3 backend with locking for this root
   configuration.
3. Create two `.tfvars` files (e.g. `dev.tfvars`, `prod.tfvars`) with
   different `instance_type` and `vpc_cidr` values, and run
   `terraform plan -var-file=dev.tfvars` vs `-var-file=prod.tfvars` to
   see the same code produce different-shaped plans.
4. Set up a minimal CI pipeline (GitHub Actions or Jenkins — whichever
   you already know) that runs `terraform fmt -check`,
   `terraform validate`, and `terraform plan` on every pull request
   touching this configuration. See
   `../../workflows/terraform-cicd-workflow.md` for the shape.
5. Add a `prevent_destroy` lifecycle rule to a resource you'd consider
   critical (e.g. the S3 artifacts bucket) and confirm `terraform
   destroy` refuses to remove it until the rule is lifted.
6. Deliberately break something (wrong variable type, missing required
   argument, bad AMI filter) and walk through
   `../../troubleshooting/` to diagnose and fix it using the
   Problem → Investigation → Root Cause → Fix → Verification pattern.

## Expected Output

- A working modular configuration that provisions VPC + security group +
  EC2 + S3, using remote state.
- Two distinct `plan` outputs from the same code with different tfvars
  files.
- A CI pipeline that fails the PR check if `terraform fmt` or `validate`
  fails, and posts/shows the `plan` output for review.
- A resource protected by `prevent_destroy` that correctly blocks
  destruction.

## Interview Questions

- How would you structure Terraform for multiple environments in a real
  team?
- Walk me through what happens when a pull request touching Terraform
  code is opened, from commit to production apply.
- How do you keep AWS credentials out of a CI/CD pipeline while still
  letting Terraform authenticate?
- What's your process when `terraform apply` fails partway through in
  production?

## Common Mistakes

- Building modules that are actually only used once, adding indirection
  without buying reusability.
- Letting CI auto-approve production applies with no human review step.
- Storing real secrets in `.tfvars` files that end up committed to Git.
- Skipping `plan` review because "it's just a small change."

## Key Takeaways

- Production Terraform is less about advanced syntax and more about
  process: review, remote state, least privilege, and treating
  infrastructure changes with the same rigor as application code
  changes.
- The mental model that ties the whole module together:

```
Terraform
    ↓
Desired Infrastructure
    ↓
Provider
    ↓
Plan
    ↓
State
    ↓
Apply
    ↓
Cloud Infrastructure
```
