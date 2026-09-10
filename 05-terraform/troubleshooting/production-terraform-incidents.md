# Troubleshooting — Production Terraform Incidents

## Incident Pattern: Unexpected Destroy/Recreate on a Critical Resource

**Symptoms:** `terraform plan` against production shows
`-/+ destroy and recreate` on a resource that should never be replaced
(a database, a stateful volume, a production S3 bucket).

**Investigation:**
- Identify which changed argument forced replacement — Terraform marks
  "requires replacement" against the specific attribute in `plan`
  output.
- Check whether that attribute is genuinely immutable for this resource
  type (some AWS resource attributes can only be changed by
  replacement, by design) or whether it's an accidental change that
  should be reverted instead.

**Root Cause (typical):** a code change touched an attribute that forces
replacement, often unintentionally (e.g. changing an S3 bucket's `name`,
or an RDS engine version bump that requires a new instance in some
configurations).

**Fix:**
- If the replacement is unintended → revert the code change.
- If the replacement is intended and unavoidable → plan the cutover
  carefully: consider `create_before_destroy`, snapshotting/backups
  first, and a maintenance window — don't let CI auto-apply a
  destroy/recreate against a stateful production resource unattended.

**Verification:** `terraform plan` shows only the intended, reviewed
change; any data-bearing resource has a backup/snapshot taken
immediately before the apply.

---

## Incident Pattern: `prevent_destroy` Blocked a Necessary Change

**Symptoms:**
```
Error: Instance cannot be destroyed
  Resource aws_s3_bucket.critical_data has lifecycle.prevent_destroy set,
  but the plan calls for this resource to be destroyed.
```

**Investigation:** Confirm this is a genuinely intended destroy (not
another accidental replacement scenario from the previous section) —
`prevent_destroy` is working as designed here.

**Fix:** Deliberately remove the `prevent_destroy` lifecycle argument in
a reviewed code change, run `plan` to confirm exactly what will happen,
get sign-off, then `apply`. Never remove `prevent_destroy` "just to get
past the error" without confirming the destroy is actually wanted.

**Verification:** The resource is destroyed only as part of a reviewed,
intentional change — not as a side effect of an unrelated apply.

---

## Postmortem Checklist for Any Production Terraform Incident

- What was the exact `plan` output right before the incident? (Save
  plan output as a CI artifact so this is always available.)
- Was the apply run through CI/CD with a reviewed plan, or manually from
  a local machine?
- Did state locking work as expected, or was there a race?
- What check (code review, `plan` review, `prevent_destroy`) could have
  caught this earlier, and is it missing from the current pipeline?
- Update `production-terraform.md`'s checklist and this troubleshooting
  file with anything genuinely new learned from the incident.
