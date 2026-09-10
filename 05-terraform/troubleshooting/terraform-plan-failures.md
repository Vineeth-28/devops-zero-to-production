# Troubleshooting — terraform plan Failures / Unexpected Output

## Scenario 2: `terraform validate` fails

**Problem:** Configuration doesn't pass validation before you even get
to `plan`.

**Symptoms:**
```
Error: Unsupported argument
Error: Missing required argument
Error: Invalid value for "cidr_block"
```

**Commands:**
```bash
terraform fmt -recursive
terraform validate
```

**Investigation:**
- Read the error's file and line number — `validate` errors are almost
  always precise (unlike some `plan`/`apply` errors that only surface at
  the API layer).
- Check for a typo'd argument name, wrong type (string vs number vs
  list), or a required argument left out entirely.
- Check for a resource referencing another resource/module that doesn't
  exist under that exact address.

**Root Cause (typical):** typo, wrong type, or a renamed resource
address that wasn't updated everywhere it's referenced.

**Fix:** Correct the argument in the `.tf` file; re-run `terraform fmt`
then `terraform validate`.

**Verification:** `terraform validate` returns "Success! The
configuration is valid."

---

## Scenario 3: `terraform plan` wants unexpected changes

**Problem:** You didn't intentionally change anything, but `plan` shows
a diff you don't expect.

**Symptoms:**
```
~ update in-place
  ~ tags = {
      - "Owner" = "platform-team" -> null
    }
```

**Commands:**
```bash
terraform plan
terraform state show <resource_address>
terraform show
```

**Investigation:**
- Compare `terraform state show` against the real resource in the AWS
  console — is this **drift** (someone changed it manually) or did your
  own `.tf` code actually change (check `git diff`)?
- Check for a provider version upgrade that changed a resource's default
  behavior (read the provider's changelog — this happens more than
  people expect after `terraform init -upgrade`).
- Check for computed/default values the provider fills in that your
  config doesn't set explicitly — these can appear as "changes" on the
  first plan after adding a new attribute upstream.

**Root Cause (typical):** manual out-of-band change (drift), an
unnoticed code change, or a provider version bump changing defaults.

**Fix:**
- If it's drift and the manual change should be undone → let `apply`
  proceed to correct it back to code.
- If it's drift and the manual change should be *kept* → update your
  `.tf` code to match reality, then plan again to confirm no diff.
- If it's a provider default change → decide deliberately whether to
  accept it or pin the previous provider version while you investigate.

**Verification:** `terraform plan` shows either the intended change only,
or "No changes" once code and reality are reconciled.
