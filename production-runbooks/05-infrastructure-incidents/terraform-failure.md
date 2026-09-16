# Incident: Terraform Failure

## 1. Incident Summary
A `terraform plan` or `terraform apply` fails, blocking infrastructure
changes — or worse, partially applies, leaving infrastructure in an
inconsistent state relative to the configuration.

## 2. Symptoms
- `terraform plan`/`apply` exits with an error (auth, provider, state, or
  resource-level)
- State lock errors when a previous run didn't release cleanly
- Drift: `plan` shows unexpected changes because real infrastructure no
  longer matches the state file

## 3. Impact
Blocks infrastructure changes; in the worst case (a failed apply mid-way)
can leave real infrastructure partially created/modified and out of sync
with state, risking further errors on the next run if not handled carefully.

## 4. Possible Causes
- Provider authentication failure (expired/invalid cloud credentials)
- Insufficient IAM permissions for the action being attempted
- State lock held by another concurrent run (or a crashed run that didn't release it)
- Resource conflict (trying to create something that already exists outside Terraform's knowledge)
- Dependency ordering issue (a resource referencing another that doesn't exist yet/failed)
- Drift — real infrastructure changed outside Terraform (manual console
  edit, another tool), so state no longer matches reality

## 5. Systematic Troubleshooting Flow
```
terraform command fails
      |
terraform init      -> confirms backend/provider setup is even valid
      |
terraform validate  -> confirms configuration syntax/internal consistency
      |
terraform plan      -> shows what Terraform intends to do; read the diff carefully
      |
Error at which stage?
      |
init -----------> backend/provider config or auth issue
validate --------> syntax/reference error in .tf files
plan ------------> often a provider API error (auth/permissions) or drift
apply -----------> as above, plus potential partial-apply state issues
      |
Find root cause
```

## 6. Commands

```bash
terraform init
```
**What it checks:** backend configuration and provider plugin installation.
**Why we run it:** the earliest possible failure point — if this fails,
nothing downstream can work regardless of your actual resource config.
**What to look for:** backend auth errors (e.g. can't reach the S3 bucket/
DynamoDB table for remote state), provider download failures.

```bash
terraform validate
```
**What it checks:** configuration syntax and internal consistency
(references, types) without touching any real infrastructure or state.
**Why we run it:** catches structural errors cheaply before you even get
to a plan/apply attempt.
**What to look for:** clear, file/line-referenced syntax or reference errors.

```bash
terraform plan
```
**What it checks:** what changes Terraform intends to make, and any
provider-level errors encountered while refreshing state.
**Why we run it:** always run and actually read this before `apply` —
it's your last chance to catch an unintended or dangerous change.
**What to look for:** unexpected resource replacements (not just updates —
Terraform sometimes must destroy+recreate), or an explicit provider error
during refresh.

```bash
terraform state list
terraform state show <resource>
```
**What it checks:** what Terraform currently believes exists, and that
resource's recorded attributes.
**Why we run it:** compares Terraform's model of the world against reality
when you suspect drift or a conflict.
**What to look for:** a resource Terraform thinks it manages that doesn't
actually exist (or vice versa).

```bash
terraform force-unlock <lock-id>
```
**What it checks:** N/A — this is a remediation action for a stuck state lock.
**Why we run it:** releases a lock left behind by a crashed/interrupted run.
**⚠️ DANGEROUS**: only run this after confirming no other apply is
actually still in progress — force-unlocking during a genuinely active
run can cause concurrent, conflicting state writes.

## 7. How to Interpret the Output
- `init` fails with a backend auth error → cloud credentials expired or
  wrong profile/role being used — fix before anything else.
- `plan` shows a resource being destroyed and recreated instead of updated
  in place → some attribute change forces replacement; confirm this is
  actually intended before applying (this is often how outages happen —
  an "update" that's actually a destroy+recreate).
- `apply` fails partway through → some resources were created/modified,
  others weren't; re-running `plan` afterward shows the corrected diff
  from the new (partial) state — don't panic, but don't blindly re-apply
  without reading that diff first.
- Error mentions a resource "already exists" → likely created manually or
  by a previous run outside Terraform's tracked state; may need `terraform
  import` to reconcile, rather than trying to create it again.

## 8. Root Cause Examples
- A service account's credentials expired and weren't rotated in the CI pipeline
- An engineer manually deleted a resource in the cloud console, causing
  the next plan to show it as needing recreation (drift)
- Two pipeline runs triggered concurrently, one held the state lock while
  the other failed to acquire it and errored out
- A required IAM permission was never granted for a newly added resource type

## 9. Fix / Recovery
**Immediate mitigation:**
- Fix credentials/auth and re-run `plan` to get a clean diff before touching `apply` again
- If a lock is confirmed stale (no other run actually active),
  `force-unlock` — ⚠️ DANGEROUS, verify first
- If drift is the cause, decide deliberately: `terraform import` to
  reconcile state with reality, or adjust configuration to match intended
  reality, rather than blindly re-applying

**Permanent fix:**
- Automate credential rotation and add expiry alerts
- Restrict manual console changes to managed infrastructure (or require
  them to be reconciled back into Terraform promptly)
- Add automation/locking discipline in CI (single-run-at-a-time per state) to prevent lock contention

## 10. Verification
- `terraform plan` shows no unexpected diff (ideally "No changes" if
  nothing new was intended, or exactly the intended diff)
- `terraform apply` completes successfully end to end
- Real infrastructure matches what the configuration describes

## 11. Prevention
- Alert on credential expiry well ahead of time
- Enforce "no manual console changes" for Terraform-managed resources via
  policy/process, or use drift-detection tooling to catch it early
- Use remote state with locking (S3+DynamoDB, Terraform Cloud, etc.) properly configured
- Review `plan` output as a mandatory step in CI before any `apply` runs, including for destroy+recreate diffs

## 12. Post-Incident Checklist
- [ ] Identified which stage failed (init/validate/plan/apply)
- [ ] Confirmed auth/permissions were valid
- [ ] Checked for state lock contention or drift
- [ ] Applied a deliberate reconciliation (import, config fix, or unlock) rather than blind retry
- [ ] `plan` shows clean diff before final `apply`
- [ ] Root cause documented

## 13. Interview Explanation
"I troubleshoot Terraform failures in the same order the tool itself
runs: init first (backend/provider/auth), then validate (syntax), then
plan (the actual intended diff, which is also where most provider-level
and drift issues surface), and only then apply. If apply fails partway,
my first move is always another plan against the now-partial state before
touching anything else — that shows me exactly what's really there versus
what the config expects, rather than guessing and potentially compounding
a partial-apply situation."
