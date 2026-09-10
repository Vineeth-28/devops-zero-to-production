# Terraform State — HIGH PRIORITY TOPIC

State is the single most misunderstood part of Terraform, and it's a
favorite interview topic. Spend real time here.

## What State Actually Is

`terraform.tfstate` is **not** simply "a copy of your infrastructure."

It is Terraform's own record of:

- Which real-world resources correspond to which resource blocks in your
  configuration
- Metadata Terraform needs to plan efficiently (resource attributes,
  dependency ordering, provider-specific data)
- The last-known values of every attribute of every managed resource

Think of it as **the mapping layer** between your code and reality —
without it, Terraform would have no way to know that the `aws_instance.
backend` block in your `.tf` file corresponds to the specific EC2
instance `i-0123456789abcdef0` that already exists.

```
Configuration (.tf files — what you want)
        ↓
State (terraform.tfstate — what Terraform believes exists, and the mapping)
        ↓
Real Infrastructure (what actually exists in AWS)
```

`terraform plan` compares **all three**: your code, your state, and (via
provider API calls) the real infrastructure — that's why plan can detect
drift even when your code hasn't changed.

## Why State Is Necessary

Without state, Terraform would have to either:

- Re-scan the entire cloud account on every run to guess what it manages
  (slow, ambiguous, and dangerous — it might act on something it doesn't
  actually own), or
- Require you to give it resource IDs manually every single time

State solves this by letting Terraform *remember*.

## Why You Should Never Manually Edit State

- The state file's format and internal invariants are managed by
  Terraform itself; hand-editing it can desynchronize it from both your
  config and reality.
- A broken state file can cause Terraform to try to recreate resources
  that already exist (causing duplicate infrastructure or naming
  conflicts) or to "forget" resources it should be managing.
- Use the `terraform state` subcommands instead — they modify state
  safely and predictably.

## State Drift

Drift = the real infrastructure no longer matches state/config, usually
because someone changed something outside of Terraform (console click,
another script, manual `aws` CLI command).

```
State says:        EC2 instance_type = t3.small
Someone manually
changes AWS to:    EC2 instance_type = t3.large

Next `terraform plan` → Terraform notices the difference and proposes
a change to bring the resource back to t3.small (matching your code) —
unless you update your code first to intentionally accept the new value.
```

Manual changes to Terraform-managed resources should generally be
avoided — they cause exactly this kind of surprise plan output, and in a
team setting nobody else knows the change happened.

## State Locking

When multiple people (or CI jobs) might run Terraform against the same
state simultaneously, state locking prevents two `apply` operations from
corrupting the same state file at the same time. Whether locking is
available and how it works depends on the backend in use — remote
backends generally provide native locking as part of the backend itself.

## Remote State

See `backends.md` for full detail, but in short: production teams store
state remotely (not on a laptop) so it can be shared, locked, backed up,
and kept secure. Local state (`terraform.tfstate` sitting in a project
folder) does not scale past "one person, one laptop, no team."

## State Backup

Most backends keep some form of state history/versioning (for example, a
versioned object storage bucket) so a bad apply or accidental
`state rm` can be recovered from a previous version.

## Key State Commands

```bash
terraform state list              # list every resource address in state
terraform state show <address>    # show full attributes of one resource
terraform state mv <src> <dst>    # rename/move a resource within state
terraform state rm <address>      # remove a resource from state
                                   # (does NOT destroy the real resource)
terraform show                    # human-readable dump of the whole state
```

`terraform state rm` is commonly confused with `terraform destroy`:

```
terraform state rm <address>
  → Terraform forgets about the resource. The real resource still exists
    in AWS untouched. Useful when you want to stop managing something
    without deleting it.

terraform destroy -target=<address>
  → Terraform actually deletes the real resource.
```

## Interview One-Liner

"Terraform state is not a mirror of infrastructure — it's Terraform's
bookkeeping for which config maps to which real resource, plus the
metadata needed to plan changes efficiently."
