# Troubleshooting — AWS-Specific Issues

## Problem: AMI Not Found / Data Source Returns Nothing

**Symptoms:**
```
Error: no matching AMI found
Error: Your query returned no results. Please change your search criteria and try again.
```

**Commands:**
```bash
terraform plan
aws ec2 describe-images --owners 099720109477 --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
```

**Investigation:**
- Check the `owners` field — a wrong owner ID (or omitting it) can
  silently return zero results depending on the filter.
- Check the `name` filter pattern for typos or an outdated image name
  string (image naming conventions change over time).
- Confirm the AWS region actually has that AMI available — AMIs are
  region-specific.

**Root Cause (typical):** wrong owner ID, stale filter pattern, or
region mismatch.

**Fix:** Correct the filter/owner using a verified `aws ec2
describe-images` query run outside Terraform first, then update the
`data "aws_ami"` block to match.

**Verification:** `terraform plan` resolves the data source and shows
the expected AMI ID via `terraform console` (`data.aws_ami.ubuntu.id`).

---

## Problem: S3 Bucket Naming Conflicts

**Symptoms:**
```
Error: creating S3 Bucket: BucketAlreadyExists
```

**Investigation:** S3 bucket names are globally unique across **all**
AWS accounts, not just yours — a common name is very likely already
taken by someone else.

**Fix:** Use a genuinely unique name — commonly a naming convention like
`<company>-<project>-<environment>-<purpose>` — rather than a generic
name.

**Verification:** `terraform apply` creates the bucket successfully.

---

## Problem: Security Group / Networking Misconfiguration

**Symptoms:**
- EC2 instance is running but unreachable (SSH times out, HTTP times
  out).

**Commands:**
```bash
terraform state show aws_security_group.web
aws ec2 describe-instances --instance-ids <id>
```

**Investigation:**
- Confirm the security group actually has an ingress rule for the port
  and source CIDR you're testing from.
- Confirm the subnet has `map_public_ip_on_launch = true` (or the
  instance was explicitly given a public IP/EIP) if you expect a public
  IP at all.
- Confirm the route table associated with the subnet actually routes
  `0.0.0.0/0` to an Internet Gateway.

**Root Cause (typical):** a missing ingress rule, no public IP assigned,
or a route table not associated with the right subnet.

**Fix:** Add the missing ingress rule, enable
`map_public_ip_on_launch`, or fix the route table association — then
`terraform apply` again.

**Verification:** The instance is reachable on the intended port from
the intended source.
