# Terraform Workflow — Command Reference

## Mental Model

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

## `terraform init`

**Purpose:** initialize a working directory — download providers,
configure the backend, set up module references.

```bash
terraform init
terraform init -upgrade      # also upgrade providers to latest allowed version
```

- **Changes:** local `.terraform/` directory, provider plugin cache,
  `.terraform.lock.hcl` (provider version lock file).
- **Does NOT change:** any real infrastructure, or the state file's
  resource content.

## `terraform validate`

**Purpose:** check that configuration is syntactically valid and
internally consistent (types, required arguments), without contacting
any provider API.

```bash
terraform validate
```

- **Changes:** nothing.
- **Does NOT catch:** things that depend on real infrastructure state —
  e.g. a resource that will actually fail because a referenced VPC
  doesn't exist. That's `plan`'s job.

## `terraform fmt`

**Purpose:** rewrite `.tf` files into canonical formatting (indentation,
alignment).

```bash
terraform fmt
terraform fmt -check    # exit non-zero if formatting is needed (for CI)
```

- **Changes:** whitespace/formatting of `.tf` files only. Never touches
  logic or infrastructure.

## `terraform plan`

**Purpose:** compute and display the diff between desired config, current
state, and real infrastructure — without changing anything.

```bash
terraform plan
terraform plan -out=tfplan     # save the plan to a file for later apply
terraform plan -var="instance_type=t3.small"
terraform plan -var-file="prod.tfvars"
```

- **Changes:** nothing in real infrastructure. May write a saved plan
  file if `-out` is used.
- **Does NOT change:** state or infrastructure.

## `terraform apply`

**Purpose:** execute the plan — actually create/update/destroy resources.

```bash
terraform apply
terraform apply tfplan            # apply a previously saved plan exactly
terraform apply -auto-approve     # skip interactive yes/no (use carefully)
```

- **Changes:** real infrastructure, and updates the state file to match.
- **Note:** applying a *saved* plan (`terraform apply tfplan`) guarantees
  exactly what was reviewed gets applied — nothing can have silently
  changed between plan and apply. This is the safer pattern for
  production pipelines versus re-planning implicitly inside `apply`.

## `terraform destroy`

**Purpose:** destroy every resource this state file manages.

```bash
terraform destroy
terraform destroy -target=aws_instance.backend   # destroy just one resource
```

- **Changes:** deletes real infrastructure. Use `-target` carefully — it's
  meant for exceptional/recovery situations, not routine use.

## Full Local Loop, Realistically

```bash
terraform fmt -recursive
terraform validate
terraform init
terraform plan -out=tfplan
# review the plan output carefully
terraform apply tfplan
terraform output
```
