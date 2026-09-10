# Terraform + AWS — Example Project

This folder is a small, realistic (not "toy," not "enterprise-scale")
Terraform project that provisions a basic but production-shaped AWS
network + compute + storage setup.

## What Gets Built

```
VPC
 ↓
Subnet (public)
 ↓
Route Table (+ Internet Gateway)
 ↓
Security Group
 ↓
EC2 instance
```

Plus an S3 bucket, independent of the networking chain, for artifact
storage.

## File Layout

```
aws/
├── README.md                  ← this file
├── provider.tf                 ← terraform{} + provider "aws" {}
├── variables.tf                ← root-level input variables
├── outputs.tf                  ← root-level outputs
├── main.tf                     ← wires everything together
├── terraform.tfvars.example    ← safe placeholder values, copy to terraform.tfvars
│
├── networking/
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── route-tables.tf
│   └── security-groups.tf
│
├── compute/
│   └── ec2.tf
│
└── storage/
    └── s3.tf
```

Note: the resources under `networking/`, `compute/`, and `storage/` are
organized by concern for readability in this handbook. In a real
Terraform run, Terraform loads every `.tf` file in the *same directory*
together — splitting resources into subdirectories like this only works
if each subdirectory is its own module or you're browsing them for
reference rather than running `terraform apply` directly against nested
folders. Treat these subfolders as **reference material** for how each
concern's resources look; `main.tf` at the `aws/` root shows how they'd
actually be wired together in one flat configuration or via `modules/`.

## Usage

```bash
cd 05-terraform/aws
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your own values

terraform fmt -recursive
terraform validate
terraform init
terraform plan
terraform apply
```

No real AWS credentials are ever stored in these files — see
`../concepts/providers.md` for how authentication should be supplied.

## Resource Relationship

```
VPC
 ↓
Subnet
 ↓
Route Table  ──→  Internet Gateway (for public internet access)
 ↓
Security Group  (attached to the EC2 instance, controls its traffic)
 ↓
EC2
```

Deliberately kept simple — no NAT gateways, no multi-AZ HA setup, no
private subnets. This is a revision reference, not a production
blueprint; production setups add multi-AZ, private subnets + NAT, WAF,
etc. on top of these same fundamentals.
