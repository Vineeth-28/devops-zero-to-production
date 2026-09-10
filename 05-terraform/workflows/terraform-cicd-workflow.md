# Terraform CI/CD Workflow

## The Production Pipeline

```
Developer
    ↓
GitHub
    ↓
Pull Request
    ↓
CI
    ↓
terraform fmt
    ↓
terraform validate
    ↓
terraform plan
    ↓
Review
    ↓
Approval
    ↓
terraform apply
    ↓
Infrastructure
```

## Why `terraform plan` Must Be Reviewed Before a Production Apply

`plan` is the actual diff of what's about to happen to real
infrastructure — the same review discipline applied to application code
diffs should apply here, arguably more so, since a bad infrastructure
apply can take down a whole environment rather than one code path.

Best practice: have CI post the `plan` output directly on the pull
request (as a comment or check output) so reviewers see exactly what
will change without needing local access to run it themselves.

## Example Pipeline Stages (Tool-Agnostic — Works for Jenkins or GitHub Actions)

```
Stage 1: fmt check       → terraform fmt -check -recursive
Stage 2: validate        → terraform validate
Stage 3: plan             → terraform plan -out=tfplan
Stage 4: publish plan     → post plan output to the PR for human review
Stage 5: manual approval  → gate before Stage 6, required for prod
Stage 6: apply             → terraform apply tfplan (only after approval,
                             only on merge to the protected branch)
```

## Connecting to Jenkins / GitHub Actions

This mirrors the same CI/CD concepts from earlier modules
(`07-cicd/`) — Terraform stages slot into the same
build → test → deploy pipeline shape you already know from application
CI/CD, just with `fmt/validate/plan/apply` in place of
`build/test/deploy`.

```
GitHub
    ↓
Jenkins / GitHub Actions
    ↓
Terraform
    ↓
Infrastructure
```

## Authentication in CI/CD

- Prefer OIDC federation (GitHub Actions assuming an IAM role directly)
  over long-lived access keys stored as CI secrets.
- If access keys must be used, store them only in the CI system's secret
  store, scoped with least privilege, and rotate regularly.
- Never echo credentials in pipeline logs — enable secret masking.

## Gating Production Applies

- Require a human approval step before `apply` runs against production,
  even in an otherwise fully automated pipeline.
- Apply should run from the CI system itself (not a developer's laptop)
  so the exact reviewed plan is what executes, and the process is
  auditable.
