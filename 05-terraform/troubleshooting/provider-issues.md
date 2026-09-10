# Troubleshooting — Provider Issues

## Problem: Provider Authentication / Configuration Errors

**Symptoms:**
```
Error: error configuring Terraform AWS Provider: no valid credential sources found
Error: failed to refresh cached credentials
Error: NoCredentialProviders: no valid providers in chain
```

**Commands:**
```bash
aws sts get-caller-identity
terraform providers
TF_LOG=DEBUG terraform plan
```

**Investigation:**
- Confirm the credential chain Terraform is using matches what you
  expect (env vars vs profile vs role) — see `concepts/providers.md` for
  the full list of valid mechanisms.
- Check for a `region` mismatch between the provider block and where
  your credentials/role are actually valid.
- Check `terraform providers` output to confirm the correct provider
  version is actually being used (a stale lock file can pin an old,
  misbehaving version).

**Root Cause (typical):** expired/missing credentials, wrong region, or
a provider version bug fixed in a later release.

**Fix:** Refresh credentials, correct the region, or run
`terraform init -upgrade` to pick up a newer provider version if the
issue is a known provider bug.

**Verification:** `aws sts get-caller-identity` succeeds and matches the
expected account/role; `terraform plan` runs cleanly.

---

## Problem: Provider Version Conflicts Between Modules

**Symptoms:**
```
Error: Failed to query available provider packages
Could not retrieve a matching version for constraint <= 4.0, >= 5.0
```

**Investigation:**
- Different modules in the same configuration declared incompatible
  `required_providers` version constraints.
- Check every module's `required_providers` block for the same
  provider.

**Root Cause:** conflicting version pins across modules that all share
one provider configuration in the root.

**Fix:** Align version constraints across modules (usually by loosening
overly strict pins like `= 4.2.0` to a range like `~> 4.0`), or upgrade
older modules to support the newer provider version.

**Verification:** `terraform init` resolves a single version satisfying
every module's constraint.
