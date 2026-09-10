# Interview — Modules and Production

### What is a module?
**Expected answer:** A reusable, parameterized directory of Terraform
configuration with a defined interface (inputs via `variable` blocks,
outputs via `output` blocks).
**Key points:** every configuration has at least a root module; child
modules are called via `module` blocks.
**Common mistake:** describing a module as just "a folder with `.tf`
files" without mentioning the input/output interface that actually makes
it reusable and composable.

### Root module vs child module?
**Expected answer:** The root module is the directory you run
`terraform init/plan/apply` from; child modules are called from it (or
from other modules) via `module` blocks and know nothing about their
caller.
**Key points:** data flows root → module via inputs, module → root via
outputs; no hidden coupling either direction.

### What are variables?
**Expected answer:** Named, typed inputs to a Terraform configuration or
module, supplied via CLI flags, `.tfvars` files, environment variables,
or defaults.
**Key points:** type, description, default, validation, sensitive
attributes; precedence order matters (CLI flags win over defaults).
**Common mistake:** assuming `sensitive = true` encrypts the value in
state — it only hides it from CLI output, not from the state file
itself.

### What are outputs?
**Expected answer:** Named values exposed from a configuration or
module, consumable by humans (`terraform output`), automation (CI/CD),
or parent modules composing this one.
**Key points:** the mechanism modules use to chain together (one
module's output becomes another's input).

### What is `terraform.tfvars`?
**Expected answer:** A file supplying variable values, auto-loaded by
Terraform if present, distinct from files needing an explicit
`-var-file` flag.
**Key points:** should never contain committed secrets; a `.example`
version with placeholders is the safe thing to commit instead.

### How would you structure Terraform for production?
**Expected answer:** Modules for reusable infrastructure pieces, remote
state with locking, separate state (ideally separate accounts) per
environment, version-pinned providers/Terraform, and changes gated
through CI/CD with reviewed `plan` output before `apply`.
**Key points:** least privilege credentials, secret management outside
`.tf`/`.tfvars`, drift detection, `prevent_destroy` on critical
resources.
**Common mistake:** relying on Terraform workspaces alone for
environment isolation in a way that shares backend/credentials — see
`../concepts/workspaces.md` for why many teams avoid this for strong
isolation.

### How do you secure Terraform credentials?
**Expected answer:** Never hardcode them in `.tf`/`.tfvars`; use
environment variables, IAM roles/instance profiles, or OIDC federation
from CI/CD, with least-privilege policies.
**Key points:** treat state files as sensitive too, since they can
contain plaintext secrets even from "sensitive" variables/outputs.

### How would you use Terraform in CI/CD?
**Expected answer:** Run `fmt`/`validate`/`plan` automatically on pull
requests, post plan output for review, require approval before
production `apply`, and run `apply` from the CI system itself using a
previously reviewed, saved plan file.
**Key points:** see `../workflows/terraform-cicd-workflow.md`.

### How do you troubleshoot a failed `terraform apply`?
**Expected answer:** Read the exact provider error, check
`terraform state list` to see what succeeded before the failure (applies
are incremental, not all-or-nothing), fix the root cause, and re-run
apply — Terraform picks up from where it left off using existing state.
**Key points:** see `../troubleshooting/terraform-apply-failures.md`.
