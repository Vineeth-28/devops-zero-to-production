# Terraform Workspaces — Command Reference

```bash
terraform workspace list         # list all workspaces, * marks current
terraform workspace show         # print current workspace name
terraform workspace new staging  # create a new workspace and switch to it
terraform workspace select prod  # switch to an existing workspace
terraform workspace delete old   # delete a workspace (must not be current)
```

## Referencing the Current Workspace in Code

```hcl
resource "aws_instance" "backend" {
  instance_type = terraform.workspace == "prod" ? "m5.large" : "t3.micro"

  tags = {
    Environment = terraform.workspace
  }
}
```

See `concepts/workspaces.md` for when this pattern is (and isn't) the
right tool for environment separation.
