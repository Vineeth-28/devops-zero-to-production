# Interview — State and Backend

### What is Terraform state?
**Expected answer:** Terraform's own record mapping configuration to
real infrastructure, plus metadata needed to plan efficiently — not
simply "a copy of the infrastructure."
**Key points:** the reconciliation layer between code, state, and
reality; can contain sensitive values in plain form.
**Common mistake:** describing state as just a backup/mirror of
infrastructure — it's specifically the *mapping* and metadata, and
without it Terraform can't tell which real objects correspond to which
config blocks.

### Why does Terraform need state?
**Expected answer:** Without it, Terraform would have no reliable way to
know which real-world resources correspond to which resource blocks, and
would either need to rescan everything (slow, ambiguous, risky) or ask
for IDs manually every run.
**Key points:** enables fast, targeted plans; enables detecting drift;
enables safe updates/destroys of only what it manages.

### Local vs remote state?
**Expected answer:** Local state is a file on one machine — fine for
solo experiments, unsuitable for teams. Remote state is stored in a
shared backend (e.g. S3), enabling collaboration, locking, backup, and
better security.
**Key points:** teams and production use remote state; solo learning
can start local.
**Common mistake:** assuming remote state alone provides locking —
locking depends on backend capability/configuration, not just "remote"
status.

### What is a backend?
**Expected answer:** Configuration that determines where and how state
is stored (and how Terraform operations execute against it).
**Key points:** distinct from a provider — backend controls state
storage, provider controls how resources are created; configured in a
separate `backend` block inside `terraform {}`.
**Common mistake:** conflating backend with provider — a classic
interview trap. See `../concepts/backends.md`.

### What is state locking?
**Expected answer:** A mechanism that prevents two concurrent
plan/apply operations from writing to the same state file at the same
time, avoiding corruption.
**Key points:** critical in team/CI settings where multiple runs could
overlap; whether/how it's enforced depends on the backend.
**Common mistake:** assuming locking is automatic regardless of backend
choice — a purely local backend has no meaningful cross-machine locking.

### What is drift?
**Expected answer:** A mismatch between what Terraform's state/config
says should exist and what actually exists, usually from an out-of-band
manual change.
**Key points:** detected by `terraform plan`; generally something to
avoid causing, and to reconcile deliberately (revert the manual change,
or update code to match it) rather than leave unresolved.
**Common mistake:** assuming Terraform "fixes" drift automatically —
`plan` only *proposes* a fix; `apply` has to actually run for it to
happen, and a human decides which direction to reconcile.

### What is the difference between `terraform state rm` and `terraform destroy`?
**Expected answer:** `state rm` makes Terraform forget about a resource
without touching the real infrastructure; `destroy` actually deletes the
real resource.
**Key points:** use `state rm` when you want to stop managing something
without deleting it (e.g. handing it off, or before re-importing under a
different address).
**Common mistake:** using `destroy -target` when the intent was actually
to stop tracking something, accidentally deleting real infrastructure.
