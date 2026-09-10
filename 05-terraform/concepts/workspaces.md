# Workspaces

## What Workspaces Do

A Terraform workspace lets a single configuration directory maintain
multiple, separate state files — switching workspaces switches which
state file you're operating against, without changing your `.tf` code.

```bash
terraform workspace list        # show all workspaces
terraform workspace show        # show the current workspace
terraform workspace new staging # create + switch to a new workspace
terraform workspace select prod # switch to an existing workspace
```

## When Workspaces Can Be Useful

- Quick, low-stakes parallel variants of the same config (e.g. a personal
  scratch environment vs. a shared one) within the same backend
- Short-lived feature/test environments that get created and torn down
  often, where full isolation isn't a priority

## Why Many Production Teams Avoid Workspaces for Environment Separation

Workspaces share the same backend configuration, the same provider
credentials, and the same code path — only the state file differs. That
means a mistake (like running `apply` in the wrong workspace) can affect
the wrong environment more easily than if dev and prod were fully
separate configurations or even separate AWS accounts.

Many teams instead prefer:

- Separate directories/configurations per environment (`environments/dev`,
  `environments/staging`, `environments/prod`), each with its own backend
  key and often its own provider credentials
- Separate AWS accounts per environment entirely, with Terraform assuming
  a different role per environment

This gives stronger blast-radius isolation: a broken `apply` against dev
literally cannot touch prod, because there's no shared state, and often
no shared credentials either.

**Takeaway for interviews:** workspaces are a real feature worth knowing,
but "we use workspaces for dev/staging/prod" is not automatically the
"correct" production answer — many teams have deliberately moved away
from that pattern toward directory- or account-level isolation.
