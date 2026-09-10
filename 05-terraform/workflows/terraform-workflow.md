# Terraform Workflow — Local Development

```
Write
 ↓
fmt
 ↓
validate
 ↓
init
 ↓
plan
 ↓
review
 ↓
apply
 ↓
verify
```

## Step by Step

1. **Write** — author or edit `.tf` files.
2. **fmt** — `terraform fmt -recursive` to normalize formatting before
   anyone (including CI) has to look at a diff full of whitespace noise.
3. **validate** — `terraform validate` catches syntax/type errors with
   zero API calls, fast feedback before touching any provider.
4. **init** — `terraform init` (only needed again if providers/modules/
   backend changed since the last run).
5. **plan** — `terraform plan -out=tfplan` computes the actual diff
   against real infrastructure.
6. **review** — read every line of the plan output. This is the step
   most commonly skipped and most commonly the source of "how did that
   happen" incidents.
7. **apply** — `terraform apply tfplan` applies exactly the plan you
   reviewed, not a freshly recomputed one.
8. **verify** — check `terraform output`, confirm the resource behaves
   as expected (e.g. the instance is reachable), and run `terraform
   plan` once more expecting "No changes."

## Why Apply a Saved Plan File Instead of Re-Planning Inline

```bash
terraform plan -out=tfplan
# review tfplan output carefully
terraform apply tfplan
```

vs.

```bash
terraform apply
# recomputes plan fresh, then prompts
```

Applying a saved plan guarantees what gets applied is *exactly* what was
reviewed — nothing in the underlying infrastructure could have changed
in between review and apply. This matters more as team size and
apply frequency grow.
