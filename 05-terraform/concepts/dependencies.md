# Dependencies

## Implicit Dependencies

Terraform builds a dependency graph automatically by looking at
references between resources.

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id   # ← reference creates the dependency
  cidr_block = "10.0.1.0/24"
}
```

```
resource A (aws_vpc.main)
    ↓  (subnet references vpc.id)
resource B (aws_subnet.public)
```

Terraform sees `aws_vpc.main.id` used inside `aws_subnet.public` and
automatically knows: create/update the VPC before the subnet, and
destroy the subnet before the VPC.

You get this correct ordering for free — you never write "create the VPC
first" anywhere. That's the whole point of implicit dependencies.

## Explicit Dependencies — `depends_on`

Sometimes two resources are related in a way Terraform can't see through
attribute references — for example, an IAM policy that must exist before
an application starts using it, even though no attribute is actually
passed between them.

```hcl
resource "aws_iam_role_policy" "app_policy" {
  # ...
}

resource "aws_instance" "backend" {
  # ...

  depends_on = [aws_iam_role_policy.app_policy]
}
```

## Use `depends_on` Sparingly

- Prefer implicit dependencies (attribute references) whenever possible —
  they're self-documenting and Terraform maintains them automatically.
- `depends_on` should be reserved for genuine hidden dependencies that
  can't be expressed through a reference — overusing it makes the
  dependency graph harder to read and can hide real design issues (if two
  resources need `depends_on`, ask whether one should actually be
  referencing an attribute of the other instead).
