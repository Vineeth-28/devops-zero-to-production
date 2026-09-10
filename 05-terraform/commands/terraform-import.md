# Terraform Import — Command Reference

## Concept

```
Existing infrastructure (created outside Terraform)
        ↓
terraform import
        ↓
Terraform state (now tracks it)
        ↓
Terraform configuration (you still have to write this yourself)
```

**Important:** importing a resource into state does **not** automatically
generate a matching, ideal `.tf` configuration for it. You still need to
write (or generate, then hand-refine) a resource block whose arguments
match reality closely enough that `terraform plan` shows no unwanted
diff immediately after import.

## Classic CLI Import

```bash
terraform import aws_instance.backend i-0123456789abcdef0
```

This requires you to have already written a *matching* `resource
"aws_instance" "backend" { ... }` block (even a mostly-empty one) before
running the command — import populates state, not code.

## Workflow

```bash
# 1. Write a resource block (can start minimal)
# 2. Run import
terraform import aws_instance.backend i-0123456789abcdef0

# 3. Check what Terraform now believes vs your (minimal) config
terraform plan
# → likely shows a big diff, because your config doesn't yet match
#   every real attribute

# 4. Fill in your config to match `terraform state show aws_instance.backend`
terraform state show aws_instance.backend

# 5. Repeat plan/adjust until plan shows no changes
terraform plan
```

## Modern Import Blocks (Terraform 1.5+)

Newer Terraform versions support declaring imports directly in code,
which plans the import alongside everything else and can also generate
starter configuration:

```hcl
import {
  to = aws_instance.backend
  id = "i-0123456789abcdef0"
}
```

```bash
terraform plan -generate-config-out=generated.tf
```

This generates a starting `.tf` file you review and clean up — still not
a substitute for actually reading through it and matching it to your
module conventions, but it removes a lot of manual transcription.

## Key Takeaway

Import solves "state doesn't know about this resource." It does not
solve "I don't have to write Terraform code for this resource" — you
still own getting the configuration accurate.
