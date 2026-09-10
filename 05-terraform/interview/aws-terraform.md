# Interview — AWS + Terraform

### What is `terraform plan`?
**Expected answer:** A dry-run that computes the diff between desired
configuration, current state, and real infrastructure — showing exactly
what would change without changing anything.
**Key points:** safe to run anytime; the primary review artifact before
any apply.

### `terraform plan` vs `terraform apply`?
**Expected answer:** `plan` previews changes with no side effects;
`apply` executes them, updating both real infrastructure and the state
file.
**Common mistake:** treating `apply`'s own confirmation prompt as an
adequate substitute for actually reading the `plan` output beforehand.

### What is `terraform init`?
**Expected answer:** Initializes a working directory — downloads
required providers, configures the backend, sets up module references.
**Key points:** must be re-run after adding/changing providers, modules,
or backend configuration.

### What is `terraform validate`?
**Expected answer:** Checks configuration for syntax/type correctness
without contacting any provider API.
**Key points:** fast, local-only; does not catch issues that only
surface against real infrastructure (that's `plan`'s job).

### What is `terraform fmt`?
**Expected answer:** Rewrites `.tf` files into Terraform's canonical
formatting style.
**Key points:** purely cosmetic — never changes logic; commonly enforced
in CI with `-check`.

### What is `terraform destroy`?
**Expected answer:** Destroys every resource the current state manages
(or a specific one with `-target`).
**Key points:** `prevent_destroy` in a resource's `lifecycle` block can
block this deliberately for critical resources.

### What is `depends_on`?
**Expected answer:** An explicit dependency declaration used when
Terraform can't infer a dependency through attribute references alone.
**Key points:** prefer implicit dependencies (references) wherever
possible; reserve `depends_on` for genuinely hidden relationships.

### What are lifecycle rules?
**Expected answer:** Per-resource settings (`create_before_destroy`,
`prevent_destroy`, `ignore_changes`) that override Terraform's default
create/update/destroy behavior for that resource.
**Key points:** know at least one realistic use case for each — see
`../concepts/lifecycle.md`.

### What is `prevent_destroy`?
**Expected answer:** A lifecycle setting that makes Terraform refuse to
destroy a resource (via `destroy` or a replacement) until the setting is
removed.
**Key points:** used as a safety rail for genuinely critical resources
(production databases, state storage).

### What are workspaces?
**Expected answer:** A way for one configuration directory to maintain
multiple separate state files, switchable via `terraform workspace`
commands.
**Key points:** useful for lightweight variants; many teams prefer
separate configurations/accounts over workspaces for strong
environment isolation in production. See `../concepts/workspaces.md`.

### How do you import existing infrastructure?
**Expected answer:** Write a matching resource block, then run
`terraform import <address> <id>` (or use an `import` block in newer
Terraform versions), then iteratively adjust the config until `plan`
shows no diff.
**Key points:** import populates state, not a perfect matching
configuration — you still have to write/verify the `.tf` code yourself.
