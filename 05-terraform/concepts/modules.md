# Modules

## Mental Model

```
Module = Reusable Terraform configuration
```

A module is just a directory containing `.tf` files. Every Terraform
configuration has at least one module — the **root module** (the
directory you run `terraform apply` from). Any module the root module
calls is a **child module**.

## Why Modules Exist

Without modules, building three environments (dev/staging/prod) means
copy-pasting the same VPC/EC2/security-group code three times — and
copy-pasted infrastructure code drifts apart exactly like copy-pasted
application code does.

With modules, you write the VPC logic **once**, then call it three times
with different variables.

## Example Composition

```
root module
    ↓
VPC module
    ↓
EC2 module
    ↓
Security Group module
```

```hcl
# root module (e.g. aws/main.tf)
module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "security_group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source            = "../modules/ec2"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.sg_id
}
```

Notice how `module.vpc.vpc_id` (a module **output**) flows into the next
module as an **input variable**. This is the entire mechanism modules use
to compose — inputs in, outputs out, nothing hidden.

## Root Module vs Child Module

```
Root module
- The directory you run terraform init/plan/apply from
- Can call any number of child modules
- Is itself never "called" by anything

Child module
- Called via a `module` block from a root module (or another module)
- Receives inputs via its `variable` blocks
- Exposes values via its `output` blocks
- Has zero knowledge of who's calling it
```

## Module Reuse

The same module, called multiple times with different inputs, builds
multiple independent copies of that infrastructure:

```hcl
module "vpc_dev" {
  source   = "../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "vpc_staging" {
  source   = "../modules/vpc"
  vpc_cidr = "10.1.0.0/16"
}
```

## Good Module Design

- **Clear interface** — inputs (`variables.tf`) and outputs
  (`outputs.tf`) should be the *only* way the module is configured or
  read from. No hidden assumptions.
- **Avoid hardcoding** — CIDR blocks, instance types, names, regions
  should be variables with sensible defaults, not baked in.
- **Small and focused** — a module that does "VPC" should not also
  create an EC2 instance and an S3 bucket. Compose small modules instead
  of building one giant one.
- **Reusability over cleverness** — a module used in only one place with
  no variation isn't buying you much; modules earn their keep when reused
  across environments or projects.

## Example Module Structure

```
modules/vpc/
├── main.tf        # resources
├── variables.tf   # inputs
└── outputs.tf     # outputs consumed by whoever calls this module
```

See `05-terraform/modules/` in this repo for working examples of VPC,
EC2, and Security Group modules.
