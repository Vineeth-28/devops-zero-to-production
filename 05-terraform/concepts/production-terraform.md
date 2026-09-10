# Production Terraform

## Checklist

- **Remote state** — never local state for a shared/production
  environment. See `backends.md`.
- **State locking** — ensure your backend provides it and that it's
  actually enforced (don't let CI jobs bypass locking with `-lock=false`
  as a routine habit).
- **Version pinning** — pin the Terraform CLI version (`required_version`)
  and provider versions (`required_providers { version = "~> 5.0" }`).
  Unpinned versions mean "works on my machine, breaks in CI next week."
- **Modules** — reusable, tested, versioned building blocks instead of
  copy-pasted resource blocks per environment.
- **Code review** — infrastructure changes go through pull requests like
  application code.
- **`terraform fmt`** — consistent formatting, enforced in CI.
- **`terraform validate`** — catches syntax/type errors before `plan`.
- **`terraform plan`** — always reviewed by a human before a production
  `apply`. Plan output is the actual diff of what's about to happen.
- **CI checks** — fmt/validate/plan should run automatically on every
  pull request touching Terraform code.
- **Least privilege** — the credentials Terraform runs with should have
  only the permissions needed for the resources it manages, not full
  account admin.
- **Secret management** — secrets come from a secrets manager or CI
  secret store, referenced via data sources or environment variables —
  never committed in `.tf`/`.tfvars`.
- **Environment isolation** — separate state (and ideally separate
  accounts) per environment, so a mistake in dev can't touch prod.
- **Backups** — rely on your backend's versioning/backup capabilities for
  state; don't assume state can never be lost or corrupted.
- **Drift detection** — periodically run `terraform plan` against prod
  even when no code changed, to catch manual changes early.
- **Change review** — every `apply` against prod should have a
  corresponding reviewed `plan` output, ideally captured as part of a
  CI/CD run rather than someone's local terminal.
- **Avoid manual infrastructure changes** — every manual console/CLI
  change is a future drift incident waiting to happen.

## What NOT To Do

- Don't hardcode credentials in `.tf` files.
- Don't run `terraform apply` against production from a laptop with
  unreviewed local changes.
- Don't disable state locking as a routine workaround for "it's slow."
- Don't treat `-auto-approve` as safe for production applies outside of a
  carefully gated CI/CD pipeline.
- Don't let `ignore_changes` or overly broad `-target` usage become the
  normal way of working — both are meant for exceptions, not habits.

## The Production Mental Model

```
Terraform
    ↓
Desired Infrastructure
    ↓
Provider
    ↓
Plan (reviewed by a human or a gated pipeline)
    ↓
State (remote, locked, backed up)
    ↓
Apply
    ↓
Cloud Infrastructure
```
