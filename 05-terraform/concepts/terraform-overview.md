# What Is Terraform?

Terraform is a tool for defining and provisioning infrastructure using a
declarative configuration language (HCL — HashiCorp Configuration
Language), then letting Terraform figure out how to make real
infrastructure match that configuration.

## Why Infrastructure as Code Exists

Manually creating infrastructure has real problems:

```
Manual Infrastructure                Terraform-Managed Infrastructure
----------------------               ---------------------------------
Click console buttons                Write code, review it, commit it
No history of "why"                  Git history explains every change
Hard to reproduce                    terraform apply reproduces it
Config drifts silently               Plan shows drift before it bites you
One person "just knows" the setup    Anyone can read the .tf files
Scaling = manual repetition          Scaling = reuse a module
Rollback = tribal memory             Rollback = revert a commit + apply
```

## Declarative vs Imperative

- **Imperative** (a shell script): "run these commands, in this order, to
  reach the end state." You describe the *steps*.
- **Declarative** (Terraform): "this is what I want to exist." You describe
  the *outcome*. Terraform works out the steps.

This matters because declarative configuration is idempotent by design —
running `terraform apply` twice in a row with no code changes should
produce **no changes** the second time.

## Desired State

Your `.tf` files describe *desired state*. Terraform's job, every time you
run it, is:

```
Desired State (code)
       ↓
Compare against Current State (state file)
       ↓
Compare against Real Infrastructure (cloud API)
       ↓
Compute a diff
       ↓
Apply only what's needed to reconcile
```

## Reproducibility, Version Control, Automation

- **Reproducibility** — the same `.tf` files can build the same
  infrastructure in a new AWS account, a new region, or after a disaster.
- **Version control** — infrastructure changes go through the same review
  process as application code: pull requests, diffs, approvals.
- **Automation** — `terraform plan`/`apply` can run inside CI/CD, removing
  manual, undocumented changes from the loop entirely.
- **Consistency** — dev, staging, and prod can be built from the same
  modules with different variables, instead of three different snowflakes.

## What Terraform Is Not

- It is **not** a configuration management tool (that's Ansible's job —
  installing packages, managing config files on existing servers).
- It is **not** a container orchestrator (that's Kubernetes).
- It is **not** a CI/CD engine (that's Jenkins/GitHub Actions — although
  Terraform commonly *runs inside* one).

Terraform's job stops once the infrastructure exists. What runs on top of
it is a different tool's responsibility.
