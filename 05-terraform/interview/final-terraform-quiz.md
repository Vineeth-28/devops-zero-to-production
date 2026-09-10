# Final Terraform Quiz — Self-Check

Answer each without looking at the concepts files first. Then check
yourself against the referenced file.

1. In one sentence, what is Terraform state actually for? _(see
   `../concepts/terraform-state.md`)_
2. What's the difference between a backend and a provider? _(see
   `../concepts/backends.md`)_
3. What's the difference between a resource and a data source? _(see
   `../concepts/data-sources.md`)_
4. Why does `aws_subnet.public` referencing `aws_vpc.main.id` create an
   implicit dependency, and when would you need `depends_on` instead?
   _(see `../concepts/dependencies.md`)_
5. What does `terraform state rm` do, and how is it different from
   `terraform destroy -target=...`? _(see
   `../commands/terraform-state.md`)_
6. Why doesn't `sensitive = true` fully protect a secret value? _(see
   `../concepts/variables.md`)_
7. What does `prevent_destroy` protect against, and what does it NOT
   protect against? _(see `../concepts/lifecycle.md`)_
8. Why might a production team avoid using workspaces for
   dev/staging/prod separation? _(see `../concepts/workspaces.md`)_
9. What does `terraform import` actually populate, and what do you still
   have to do yourself afterward? _(see
   `../commands/terraform-import.md`)_
10. Walk through the full CI/CD pipeline stages for a Terraform change,
    from pull request to production apply. _(see
    `../workflows/terraform-cicd-workflow.md`)_
11. What's the troubleshooting workflow when `terraform plan` shows an
    unexpected change you didn't code? _(see
    `../troubleshooting/terraform-plan-failures.md`)_
12. Explain the difference between Terraform and Ansible in terms
    someone with a Docker/Kubernetes background would immediately
    understand. _(see `../README.md`)_

## Final Cheat Sheet

| Term | Meaning |
|---|---|
| Terraform | Infrastructure as Code |
| Provider | Connects Terraform to an external API/platform |
| Resource | Infrastructure Terraform manages |
| Data source | Reads existing information |
| Variable | Input to configuration |
| Output | Exposes useful values |
| Module | Reusable Terraform configuration |
| State | Terraform's record of managed infrastructure |
| Backend | Where/how Terraform state is stored |
| `terraform init` | Initialize working directory |
| `terraform fmt` | Format configuration |
| `terraform validate` | Validate configuration |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply changes |
| `terraform destroy` | Destroy managed infrastructure |
| `terraform state list` | List resources in state |
| `terraform state show` | Inspect a resource in state |
| `terraform import` | Import existing resource into state |

## Final Production Workflow

```
Developer
    ↓
GitHub
    ↓
Pull Request
    ↓
terraform fmt
    ↓
terraform validate
    ↓
terraform plan
    ↓
Code Review
    ↓
Approval
    ↓
terraform apply
    ↓
Infrastructure
    ↓
Monitoring
```

```
Learn → Understand → Practice → Explain → Apply
```

🚀 DevOps Zero to Production
