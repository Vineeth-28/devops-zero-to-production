# Outputs

## What Outputs Do

Outputs expose values from your Terraform configuration — either to a
human running `terraform apply`, or to another piece of code (a CI/CD
pipeline step, or a parent module).

## Example

```hcl
output "instance_ip" {
  value       = aws_instance.backend.public_ip
  description = "Public IP address of the backend server"
}

output "db_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}
```

## Why Outputs Are Useful

- **Humans** — after `terraform apply`, outputs print to the terminal so
  you immediately see the new instance's IP, load balancer DNS name, etc.
- **Automation** — CI/CD can capture outputs with `terraform output -json`
  and feed them into the next pipeline stage (e.g. pass the ECR repo URL
  to a Docker build-and-push step).
- **Module composition** — a child module's outputs become the values a
  root module (or another module) consumes as inputs. This is how modules
  chain together: VPC module outputs a `vpc_id`, EC2 module takes
  `vpc_id` as an input variable.

```
root module
    ↓ (passes variables in)
VPC module ──── outputs vpc_id, subnet_ids ────┐
                                                 ↓
                                          EC2 module (consumes them)
```

## Sensitive Outputs

Marking an output `sensitive = true` hides it from normal CLI output
(`terraform apply` shows `(sensitive value)` instead), but — same caveat
as sensitive variables — the real value is still stored in the state
file. Protect your state file's storage and access, don't rely on
`sensitive = true` alone.
