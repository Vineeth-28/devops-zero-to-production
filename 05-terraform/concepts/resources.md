# Resources

## What Is a Resource?

A resource is the fundamental unit of infrastructure Terraform manages —
a VPC, an EC2 instance, a security group, an S3 bucket. If Terraform
creates it, tracks it, updates it, or destroys it, it's a resource.

## Anatomy of a Resource Block

```hcl
resource "aws_instance" "backend" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.micro"

  tags = {
    Name = "backend-server"
  }
}
```

Breaking this down:

```
resource "aws_instance" "backend" { ... }
   |          |             |
   |          |             └─ Local resource name (only used inside Terraform)
   |          └─ Resource type (defined by the provider)
   └─ Keyword that always starts a resource block
```

- **Resource type** (`aws_instance`) — defined by the provider; tells
  Terraform which API this maps to.
- **Local name** (`backend`) — how *you* refer to this resource elsewhere
  in your own code, e.g. `aws_instance.backend.public_ip`. It is not the
  AWS resource's actual name/ID.
- **Actual infrastructure** — the real EC2 instance that gets created in
  AWS, identified by its own AWS resource ID (e.g. `i-0123456789abcdef0`),
  which Terraform tracks in state.

## Common AWS Resource Examples

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "web" {
  name   = "web-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_instance" "backend" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "my-team-build-artifacts"
}
```

Notice `aws_subnet.public` references `aws_vpc.main.id` — this is an
**implicit dependency**. Terraform reads that reference and knows the VPC
must exist before the subnet. See `dependencies.md`.
