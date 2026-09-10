# Terraform State — Command Reference

```bash
terraform state list                       # list all resource addresses in state
terraform state list module.vpc            # filter to a module's resources
terraform state show aws_instance.backend  # full attributes of one resource
terraform show                             # dump entire state, human-readable
terraform show -json                       # dump entire state as JSON (for tooling)

terraform state mv aws_instance.old aws_instance.new
    # rename a resource address within state (e.g. after refactoring code)

terraform state rm aws_instance.backend
    # remove a resource from state WITHOUT destroying the real resource

terraform refresh
    # (legacy standalone form; modern Terraform refreshes as part of plan/apply)
    # reconciles state with real infrastructure without changing config
```

## Remote State Inspection

```bash
terraform state pull > state.json    # download remote state locally (read-only look)
terraform state push state.json      # push a modified state file back (dangerous — rare)
```

`state push` is a last-resort/recovery operation. Prefer `state mv` /
`state rm` for routine surgery — they operate safely through Terraform's
own APIs instead of requiring you to hand-edit a JSON blob.

## Common State Surgery Scenarios

**Renamed a resource in code, don't want Terraform to destroy+recreate:**

```bash
terraform state mv aws_instance.web aws_instance.backend
```

**Want Terraform to stop managing something, but keep the real resource:**

```bash
terraform state rm aws_s3_bucket.legacy
```

**Moved a resource into a module:**

```bash
terraform state mv aws_instance.backend module.ec2.aws_instance.backend
```

Always run `terraform plan` immediately after any `state mv`/`state rm`
to confirm Terraform's view now matches your intent — an empty diff means
you did it correctly.
