# Terraform Basics — Command Reference

```bash
terraform version              # show installed Terraform + provider versions
terraform init                 # initialize working directory, download providers
terraform fmt                  # auto-format .tf files to canonical style
terraform fmt -recursive       # format all subdirectories too
terraform validate             # check config for syntax/type errors (no API calls)
terraform plan                 # preview changes (creates an execution plan)
terraform apply                # apply changes (prompts for confirmation)
terraform apply -auto-approve  # apply without interactive confirmation (CI use)
terraform destroy              # destroy all resources managed by this state
terraform show                 # human-readable dump of current state
terraform output               # show all output values
terraform output <name>        # show a single output value
terraform console              # interactive REPL for testing expressions
```

## File Structure Terraform Expects

Terraform loads **every** `.tf` file in a directory as one merged
configuration — it does not require specific filenames. That said, the
following names are strong conventions:

```
main.tf              — primary resources
variables.tf          — variable declarations
outputs.tf            — output declarations
provider.tf           — provider + terraform{} block
terraform.tfvars       — variable values (not committed if it holds secrets)
terraform.tfstate      — Terraform-managed state (never hand-edit)
```

Terraform doesn't care what you call these files or how many there are —
`main.tf` and 10 other `.tf` files in the same directory are read
together as one configuration.
