# Data Sources

## The Core Distinction

```
Resource
→ Terraform CREATES and MANAGES infrastructure.
  If you delete the block, Terraform will try to destroy the real thing.

Data source
→ Terraform READS existing information.
  If you delete the block, nothing in the real world is touched.
```

## Example

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "backend" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}
```

Here, Terraform doesn't create the AMI — it *looks up* the latest matching
Ubuntu AMI ID at plan time, then uses that ID as an input to a resource
it *does* manage.

## When to Reach for a Data Source

- Looking up the latest AMI instead of hardcoding an ID that goes stale
- Referencing a VPC or subnet created by another team/another Terraform
  state, without importing it into your own state
- Reading account/region metadata (`data "aws_caller_identity"`,
  `data "aws_region"`)
- Reading secrets from a secrets manager at apply time (rather than
  storing them in `.tf`/`.tfvars`)

## One-Line Rule

**resource = manage. data = read.**

If you're not sure which to use: ask "do I want Terraform to be able to
destroy this?" If yes, resource. If no — it belongs to something else —
data source.
