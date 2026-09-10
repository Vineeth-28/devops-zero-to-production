# Variables

## Why Variables Exist

Variables let you parameterize configuration instead of hardcoding values
— the same `.tf` code can build a `t3.micro` dev box or a `m5.large` prod
box depending on what value is supplied.

## Declaring a Variable

```hcl
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "db_password" {
  type        = string
  description = "Database master password"
  sensitive   = true
}
```

Key parts:

- **`type`** — string, number, bool, list, map, object, etc. Terraform
  validates input against this.
- **`description`** — self-documentation; shows up in `terraform plan`
  and generated docs.
- **`default`** — optional; if omitted, Terraform will prompt for a value
  or fail in non-interactive contexts (CI) unless a value is supplied
  another way.
- **`validation`** — custom rules beyond basic type-checking.
- **`sensitive`** — hides the value from CLI output/logs. It does **not**
  encrypt the value in the state file — sensitive values still land in
  state in plain form. Treat state as sensitive too.

## Using a Variable

```hcl
resource "aws_instance" "backend" {
  instance_type = var.instance_type
}
```

Reference syntax is always `var.<name>`.

## Where Values Come From (in priority order, roughly highest first)

1. `-var` / `-var-file` flags on the CLI
2. `*.auto.tfvars` / `*.auto.tfvars.json` files (auto-loaded)
3. `terraform.tfvars` / `terraform.tfvars.json` (auto-loaded)
4. Environment variables (`TF_VAR_instance_type`)
5. The `default` in the variable block
6. Interactive prompt (if nothing else supplies a value and you're
   running Terraform in a terminal)

See `tfvars.md` in this same folder-adjacent set (also covered in
`commands/terraform-variables.md`) for how `.tfvars` files fit in.
