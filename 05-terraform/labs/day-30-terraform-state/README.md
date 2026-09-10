# Day 30 — Terraform State

## Objective

Build real intuition for what `terraform.tfstate` is, how to inspect it
safely, how drift shows up in `plan`, and why remote state + locking
matter.

## Prerequisites

- Day 29 completed
- Read `../../concepts/terraform-state.md` in full (this is the highest
  priority concept file in the whole handbook) and `../../concepts/backends.md`

## Concepts Covered

- `terraform.tfstate` structure and purpose
- `terraform state list` / `state show` / `state mv` / `state rm`
- `terraform show`
- Drift detection
- Remote state and locking

## Hands-On Tasks

1. Reuse (or recreate) the single-instance config from Day 29.
2. After `terraform apply`, run `terraform state list` and
   `terraform state show <address>` — read through every attribute
   Terraform tracked, not just the ones you set.
3. Run `terraform show` and compare its output to the raw
   `terraform.tfstate` file (open the JSON directly, read-only — don't
   edit it).
4. Simulate drift: change the instance's tag manually via the AWS
   console (not through Terraform), then run `terraform plan` again.
   Observe exactly what Terraform reports.
5. Practice `terraform state mv` — rename the resource's local name in
   your `.tf` file, then use `state mv` to keep state in sync without
   Terraform wanting to destroy and recreate the instance. Confirm with
   `terraform plan` (should show no changes).
6. Practice `terraform state rm` — remove the instance from state
   (without destroying it), confirm the instance still exists in AWS,
   then re-import it (see `../../commands/terraform-import.md`).
7. Configure a remote backend (S3) instead of local state — see
   `../../concepts/backends.md` — and run `terraform init` to migrate.

## Expected Output

- You can explain, in your own words, what's actually inside
  `terraform.tfstate` beyond "a copy of the infra."
- `terraform plan` after a manual console change shows a diff proposing
  to revert the manual change back to what your code says.
- `state mv` avoids an unwanted destroy/recreate after a rename.
- `state rm` + `import` round-trip leaves you back where you started,
  with the real resource untouched throughout.
- State now lives in S3, not on your local disk.

## Interview Questions

- Why does Terraform need a state file at all?
- What's the difference between `terraform state rm` and
  `terraform destroy -target=...`?
- What is state drift, and how would you detect it in a real pipeline?
- Why do teams prefer remote state over local state?

## Common Mistakes

- Manually editing `terraform.tfstate` in a text editor instead of using
  `terraform state` subcommands.
- Assuming `sensitive = true` on a variable/output means the value isn't
  in the state file (it still is).
- Confusing `state rm` (stop tracking) with `destroy` (actually delete).
- Forgetting to run `terraform plan` immediately after any state surgery
  to confirm the intended result.

## Key Takeaways

- State is the mapping layer between code and reality — treat it with
  the same care as production credentials, because it can contain
  sensitive values.
- Remote state + locking isn't bureaucracy — it's what makes Terraform
  safe to run from more than one place.
