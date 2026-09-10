# Terraform Variables — Command Reference

```bash
terraform plan -var="instance_type=t3.small"
terraform plan -var="instance_type=t3.small" -var="environment=staging"
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

## Environment Variables

```bash
export TF_VAR_instance_type=t3.small
export TF_VAR_db_password=$SECRET_FROM_CI_STORE
terraform plan   # picks up TF_VAR_* automatically
```

`TF_VAR_<name>` maps to `variable "<name>"` in your configuration. This
is a common pattern in CI/CD for injecting secrets without writing them
to any `.tfvars` file at all.

## tfvars Files

```
terraform.tfvars          # auto-loaded automatically
terraform.tfvars.json     # auto-loaded automatically, JSON format
*.auto.tfvars             # auto-loaded automatically, any matching filename
prod.tfvars                # NOT auto-loaded — must pass -var-file explicitly
```

Example `terraform.tfvars.example` (safe to commit — placeholders only):

```hcl
instance_type = "t3.small"
environment   = "dev"
aws_region    = "us-east-1"
```

Never commit a real `terraform.tfvars` containing secrets — add it to
`.gitignore` and commit only the `.example` version with placeholder
values.

## Precedence (highest wins)

```
-var / -var-file (CLI flags)
        ↓
*.auto.tfvars files
        ↓
terraform.tfvars
        ↓
TF_VAR_* environment variables
        ↓
default in the variable block
```
