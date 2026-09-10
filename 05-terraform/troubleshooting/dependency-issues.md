# Troubleshooting — Dependency Issues

## Scenario 9: Module input/output mismatch

**Symptoms:**
```
Error: Unsupported attribute
  on main.tf line 12, in resource "aws_instance" "backend":
  This object does not have an attribute named "subnet_id"

Error: Missing required argument
  The argument "vpc_id" is required, but no definition was found.
```

**Commands:**
```bash
terraform validate
terraform plan
```

**Investigation:**
- Check the child module's `outputs.tf` — does it actually expose the
  attribute you're trying to reference from the root module?
- Check the child module's `variables.tf` — is the input you're passing
  in actually a declared variable, spelled exactly the same way?
- A common cause: the module was updated (an output renamed or removed)
  but callers weren't updated to match.

**Root Cause (typical):** the module's interface (inputs/outputs)
changed without every caller being updated, or a simple typo in the
attribute/variable name.

**Fix:** Align the calling code with the module's actual current
interface — either update the caller to use the new output/variable
name, or add the missing output/variable to the module if it was
supposed to exist.

**Verification:** `terraform validate` and `terraform plan` succeed with
no attribute/argument errors.

---

## Scenario 10: AWS resource dependency issue

**Symptoms:**
```
Error: creating EC2 Instance: InvalidSubnetID.NotFound
Error: creating Route: NatGatewayNotFound
Error: DependencyViolation: resource has a dependent object
```

**Commands:**
```bash
terraform plan
terraform graph | dot -Tsvg > graph.svg
terraform state show <resource_address>
```

**Investigation:**
- Check whether Terraform's dependency graph actually reflects the real
  relationship — is there a missing reference (should be an implicit
  dependency but isn't, because a hardcoded ID was used instead of a
  resource reference)?
- For `DependencyViolation` on destroy — something outside this
  Terraform state (e.g. a manually attached ENI, or a resource in
  another state) still depends on the resource being destroyed.
- Check destroy ordering — Terraform destroys in reverse dependency
  order automatically, but only for dependencies it actually knows
  about.

**Root Cause (typical):** a hardcoded ID instead of a resource reference
hid a real dependency from Terraform's graph, or an external, untracked
resource is still attached to what you're trying to destroy.

**Fix:**
- Replace hardcoded IDs with proper resource references
  (`aws_subnet.public.id` instead of a literal `subnet-0123...`) so
  Terraform's graph reflects reality.
- For destroy-time dependency violations, find and detach/remove the
  external dependent object first (outside or inside Terraform,
  depending on where it lives), then retry destroy.

**Verification:** `terraform plan`/`apply`/`destroy` complete without
dependency errors; `terraform graph` shows the expected edges between
resources.
