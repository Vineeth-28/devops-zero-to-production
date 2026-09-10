# Troubleshooting — State Issues

## Scenario 6: State is locked

**Symptoms:**
```
Error: Error acquiring the state lock
Lock Info:
  ID:        d1f2e3...
  Path:      my-team-terraform-state/networking/terraform.tfstate
  Operation: OperationTypeApply
  Who:       ci-runner@build-42
```

**Commands:**
```bash
terraform plan   # will also fail/report lock info if lock is held
terraform force-unlock <LOCK_ID>
```

**Investigation:**
- Check whether another `apply`/`plan` is genuinely still running (a
  concurrent CI job, a teammate's terminal) — the lock is doing exactly
  its job in that case; wait for it to finish.
- Check whether the lock is **stale** — a previous run crashed or was
  killed without releasing the lock cleanly.

**Root Cause (typical):** either a legitimate concurrent operation, or a
crashed/interrupted previous run left a stale lock behind.

**Fix:**
- If genuinely concurrent → wait.
- If confirmed stale (the process that held it is definitely dead) →
  `terraform force-unlock <LOCK_ID>`, using the lock ID from the error
  message. Do this deliberately, never as a reflex — force-unlocking a
  lock that's actually still in use can corrupt state.

**Verification:** `terraform plan` runs without a lock error.

---

## Scenario 7: State drift

**Symptoms:** `terraform plan` proposes reverting a change you didn't
make in code.

See `terraform-plan-failures.md` Scenario 3 for the full drift
investigation and fix pattern — this is the same underlying issue,
specifically framed around state vs. reality rather than plan mechanics.

**Quick summary:**
```
State says:        EC2 instance_type = t3.small
Someone manually
changes AWS to:    EC2 instance_type = t3.large

terraform plan → proposes changing it back to t3.small
```

**Fix:** Either let `apply` revert the manual change, or update code to
intentionally accept the new value — never leave the diff unresolved
long-term, since every future `plan` will keep flagging it.

---

## Scenario 8: Resource exists in AWS but Terraform doesn't manage it

**Symptoms:**
```
Error: creating S3 Bucket: BucketAlreadyOwnedByYou
Error: creating Security Group: InvalidGroup.Duplicate
```

**Commands:**
```bash
terraform state list
terraform import aws_s3_bucket.artifacts my-existing-bucket-name
```

**Investigation:**
- Confirm the resource in the AWS console actually is the one your code
  is trying to create — same name/identifier, and it isn't in another
  state file already.
- Check `terraform state list` to confirm it's genuinely absent from
  *this* state (as opposed to a stale plan artifact).

**Root Cause (typical):** infrastructure was created manually, by an old
script, or by a different Terraform state/workspace, and your current
code is trying to create it fresh.

**Fix:** Import it (see `../commands/terraform-import.md`) instead of
trying to create a duplicate. Write your resource block to closely match
the existing resource's real attributes, then `import`, then `plan`
until the diff is empty.

**Verification:** `terraform state list` includes the resource;
`terraform plan` shows no changes for it.
