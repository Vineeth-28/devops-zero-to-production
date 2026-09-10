# Terraform Module Workflow

## Building and Consuming a Module

```
Design module interface
 (variables.tf = inputs, outputs.tf = outputs)
        ↓
Write module resources (main.tf)
        ↓
terraform fmt / validate INSIDE the module directory
        ↓
Call the module from a root configuration
        ↓
terraform init   (downloads/links the module)
        ↓
terraform plan   (root config, including the module's resources)
        ↓
terraform apply
```

## Calling Convention

```hcl
module "vpc" {
  source = "../modules/vpc"     # local path, registry address, or Git URL

  # inputs — must match variables.tf in the module
  vpc_cidr    = "10.0.0.0/16"
  environment = "dev"
}

# consuming an output
resource "aws_instance" "backend" {
  subnet_id = module.vpc.public_subnet_id
}
```

## Updating a Module Safely

```
1. Change the module's main.tf / variables.tf / outputs.tf
        ↓
2. terraform validate INSIDE the module (catches obvious breakage early)
        ↓
3. terraform plan in EVERY root configuration that calls this module
        ↓
4. Review each plan — a module change can ripple into multiple
   environments/projects at once
        ↓
5. Apply one environment at a time, not all simultaneously,
   for anything beyond a trivial change
```

## Common Pitfall

Renaming a variable or output inside a module without updating every
caller produces exactly the "module input/output mismatch" error covered
in `../troubleshooting/dependency-issues.md` — treat a module's
`variables.tf`/`outputs.tf` as a versioned public interface, not an
internal implementation detail, once more than one place calls it.
