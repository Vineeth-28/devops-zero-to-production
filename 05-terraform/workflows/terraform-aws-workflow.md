# Terraform + AWS Workflow

## End-to-End Flow for This Handbook's AWS Example

```
Write .tf config (aws/)
 ↓
terraform fmt -recursive
 ↓
terraform validate
 ↓
terraform init          (downloads AWS provider, configures backend)
 ↓
terraform plan          (diffs against real AWS account state)
 ↓
Review plan
 ↓
terraform apply
 ↓
VPC → Subnet → Route Table → Security Group → EC2 → S3 created in order
 ↓
terraform output        (grab public IP, bucket name, etc.)
 ↓
Verify (SSH/curl the instance, check the bucket exists)
```

## Resource Creation Order (Handled Automatically)

Terraform determines this order itself from implicit dependencies — you
never write it explicitly:

```
aws_vpc.main
    ↓
aws_subnet.public  +  aws_internet_gateway.main
    ↓
aws_route_table.public
    ↓
aws_route_table_association.public
    ↓
aws_security_group.web
    ↓
aws_instance.backend
```

`aws_s3_bucket.artifacts` has no dependency on the networking chain and
can be created in parallel by Terraform's internal graph execution.

## Environment Promotion

```
dev.tfvars   → terraform plan -var-file=dev.tfvars
staging.tfvars → terraform plan -var-file=staging.tfvars
prod.tfvars  → terraform plan -var-file=prod.tfvars
```

Same code, different variable values — this is the whole point of
parameterizing with variables instead of hardcoding per-environment
values into resource blocks directly.
