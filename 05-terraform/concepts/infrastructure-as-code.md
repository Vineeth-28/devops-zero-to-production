# Infrastructure as Code (IaC)

## Definition

Infrastructure as Code means managing and provisioning infrastructure
through machine-readable definition files, rather than manual
configuration or interactive tools.

## Two Flavors of IaC

```
Declarative                          Imperative
------------                         ------------
"I want a VPC with these subnets"    "Run these steps to create a VPC"
Terraform, CloudFormation, Pulumi    Bash scripts, Ansible tasks (mostly)
Tool computes the diff               You compute the diff yourself
```

Terraform is declarative. You describe the end state; Terraform figures
out create/update/destroy operations to get there.

## Why This Matters in Production

- **Auditability** — every infrastructure change is a diff in a pull
  request, reviewable before it happens.
- **Disaster recovery** — if an environment is destroyed, `terraform
  apply` against the same code rebuilds it.
- **Consistency across environments** — the same module, different
  variables, builds dev/staging/prod identically in shape.
- **Safety** — `terraform plan` shows you *exactly* what will change
  before anything actually changes.

## IaC Is Not Just "Scripts That Create Things"

A shell script that calls `aws ec2 run-instances` is automation, but it's
not really IaC in the Terraform sense — it has no concept of current
state, no diffing, and re-running it usually creates a *second* instance
instead of recognizing the first one already satisfies the requirement.

Terraform's state file is what makes it declarative and idempotent instead
of just "a script." See `terraform-state.md` for why that file is so
important.
