# Lifecycle

## What `lifecycle` Controls

A `lifecycle` block inside a resource changes how Terraform manages that
specific resource's create/update/destroy behavior, overriding its
default handling.

```hcl
resource "aws_instance" "backend" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  lifecycle {
    create_before_destroy = true
    prevent_destroy        = false
    ignore_changes          = [ami]
  }
}
```

## `create_before_destroy`

Default behavior when a resource must be replaced is destroy-then-create.
For resources where downtime matters (a load balancer, a launch template
feeding an ASG), you often want the replacement created *first*:

```
Default:              create_before_destroy = true:
destroy old  ─┐        create new  ─┐
              ↓                     ↓
create new                   destroy old
(downtime gap)               (no gap; briefly both exist)
```

## `prevent_destroy`

```hcl
resource "aws_s3_bucket" "critical_data" {
  bucket = "company-critical-backups"

  lifecycle {
    prevent_destroy = true
  }
}
```

If set, Terraform will **refuse** to destroy this resource — even via
`terraform destroy` — until the flag is removed. This is a safety rail
for genuinely critical resources: production databases, state buckets,
anything where an accidental `destroy` would be a serious incident.

It doesn't prevent *replacement* triggered by an in-place-incompatible
change unless combined carefully with the change causing it — it
specifically guards against deliberate or accidental deletion.

## `ignore_changes`

```hcl
resource "aws_instance" "backend" {
  ami = data.aws_ami.ubuntu.id
  # ...

  lifecycle {
    ignore_changes = [ami]
  }
}
```

Tells Terraform to stop proposing changes when *only* the listed
attribute(s) differ from state — useful when something outside Terraform
legitimately manages that attribute (e.g. an autoscaling process that
updates tags, or an AMI that intentionally rolls forward without wanting
every instance replaced on every plan).

Use this deliberately and narrowly — over-using `ignore_changes` on
many attributes quietly reduces how much Terraform is actually managing,
which can mask real drift you *did* want to know about.
