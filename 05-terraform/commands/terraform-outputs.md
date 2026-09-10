# Terraform Outputs — Command Reference

```bash
terraform output                     # show all outputs
terraform output instance_ip         # show a single output value
terraform output -json               # all outputs as JSON (for scripting/CI)
terraform output -json instance_ip   # single output as JSON
terraform output -raw instance_ip    # raw string, no quotes (great for scripts)
```

## Consuming Outputs in a Script

```bash
IP=$(terraform output -raw instance_ip)
ssh ubuntu@"$IP"
```

## Consuming Outputs in CI/CD

```bash
terraform output -json > outputs.json
# pass outputs.json to the next pipeline stage
```

## Consuming a Module's Outputs from a Root Module

```hcl
module "vpc" {
  source = "../modules/vpc"
}

resource "aws_instance" "backend" {
  subnet_id = module.vpc.public_subnet_id   # module output used as an input
}
```
