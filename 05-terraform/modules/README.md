# Modules

Reusable, parameterized Terraform modules. Each is self-contained:
`main.tf` (resources), `variables.tf` (inputs), `outputs.tf` (values
exposed to whoever calls the module).

```
modules/
├── vpc/               ← VPC + public subnet + IGW + route table
├── ec2/                ← single EC2 instance, parameterized
└── security-group/     ← reusable security group with configurable rules
```

## Example: Calling These Modules Together

```hcl
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  environment = "dev"
}

module "security_group" {
  source      = "./modules/security-group"
  vpc_id      = module.vpc.vpc_id
  environment = "dev"
}

module "ec2" {
  source             = "./modules/ec2"
  subnet_id          = module.vpc.public_subnet_id
  security_group_ids = [module.security_group.security_group_id]
  environment        = "dev"
}
```

Notice the flow: `vpc` outputs feed `security_group` and `ec2` inputs;
`security_group` outputs feed `ec2` inputs. No module knows about any
other module directly — they only know their own inputs and outputs.
That's what makes each one independently reusable and testable.
