# Useful Commands — Quick Grab Bag

```bash
# Debugging
TF_LOG=DEBUG terraform apply         # verbose provider/core logging
TF_LOG=TRACE terraform plan          # even more verbose
TF_LOG_PATH=./terraform.log terraform apply   # write logs to a file

# Targeted operations (use sparingly — see troubleshooting notes)
terraform plan -target=aws_instance.backend
terraform apply -target=aws_instance.backend
terraform destroy -target=aws_instance.backend

# Graph
terraform graph | dot -Tsvg > graph.svg   # visualize the dependency graph

# Providers
terraform providers                  # show provider requirements/tree
terraform providers lock             # regenerate the dependency lock file
terraform providers lock -platform=linux_amd64 -platform=darwin_arm64

# Module inspection
terraform get                        # download/update module references
terraform get -update                # force re-download of modules

# Formatting/validation combo for CI
terraform fmt -check -recursive && terraform validate

# Console for testing expressions interactively
terraform console
> var.instance_type
> aws_vpc.main.cidr_block
> [for s in aws_subnet.public : s.id]
```

## `-target` and `-var` — Use Deliberately, Not Habitually

`-target` restricts an operation to a specific resource (and its
dependencies). It's a recovery/debugging tool, not a routine workflow —
regularly targeting individual resources means your plan is no longer
representing your *whole* configuration's true state, which can hide
drift elsewhere.
