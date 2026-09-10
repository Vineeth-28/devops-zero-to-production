# Troubleshooting — terraform init Failures

## Workflow for Any Terraform Problem

```
Problem
 ↓
terraform plan
 ↓
Inspect state
 ↓
Inspect provider/configuration
 ↓
Check cloud resource
 ↓
Find root cause
 ↓
Fix
 ↓
plan again
 ↓
apply
```

---

## Scenario 1: `terraform init` fails

**Problem:** Running `terraform init` errors out before any plan/apply
can happen.

**Symptoms:**
```
Error: Failed to install provider
Error: Could not retrieve the list of available versions for provider hashicorp/aws
Error: Backend initialization required, please run "terraform init"
```

**Commands:**
```bash
terraform version
terraform init -upgrade
TF_LOG=DEBUG terraform init
```

**Investigation:**
- Check network access — provider downloads require reaching the
  Terraform registry (or a configured private mirror).
- Check `required_providers` version constraints for typos or impossible
  ranges (e.g. `>= 6.0` when only `5.x` exists).
- Check whether the backend configuration changed since the last `init`
  (new bucket name, new key, new region) — Terraform needs `init` re-run
  to pick that up.
- Check `.terraform.lock.hcl` — a stale lock file referencing a provider
  version no longer available can cause failures.

**Root Cause (typical):** version constraint mismatch, network/registry
access blocked, or backend config changed without re-running init.

**Fix:**
```bash
rm -rf .terraform .terraform.lock.hcl   # only if you're sure — regenerates cleanly
terraform init
```
Or correct the version constraint in `required_providers` and re-run
`terraform init -upgrade`.

**Verification:** `terraform init` completes successfully, followed by a
clean `terraform validate` and `terraform plan`.

---

## Scenario: Backend Migration Confusion

**Problem:** Changed backend configuration (e.g. added an S3 backend
where local was used before) and `init` prompts unexpectedly or fails.

**Symptoms:**
```
Backend configuration changed!
Do you want to copy existing state to the new backend?
```

**Investigation:** This prompt is expected and safe to answer — it's
Terraform detecting the backend block changed and offering to migrate
existing local state into the new remote backend.

**Fix:** Answer `yes` if you intend to migrate existing state; verify
with `terraform state list` immediately after that all resources are
still present in the new backend.

**Verification:** `terraform state list` from the new backend shows the
same resources as before migration.
