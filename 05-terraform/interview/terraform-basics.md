# Interview — Terraform Basics

### What is Terraform?
**Expected answer:** A tool for defining and provisioning infrastructure
using declarative configuration (HCL), which computes and applies the
diff needed to make real infrastructure match that configuration.
**Key points:** declarative, provider-agnostic, state-driven,
idempotent.
**Common mistake:** describing it purely as "a scripting tool for AWS" —
Terraform is provider-agnostic and declarative, not just an AWS
automation script.

### What is Infrastructure as Code?
**Expected answer:** Managing infrastructure through machine-readable
definition files instead of manual console/CLI actions, enabling
version control, review, and reproducibility.
**Key points:** declarative vs imperative, reproducibility, auditability.
**Common mistake:** conflating any automation script with IaC — a
one-off imperative script lacks the diffing/idempotency that makes
Terraform-style IaC distinct.

### Terraform vs Ansible?
**Expected answer:** Terraform provisions infrastructure (what exists);
Ansible configures software on existing infrastructure (what's installed
and how it's set up).
**Key points:** Terraform = declarative infra provisioning; Ansible =
configuration management, often imperative task lists; they're
complementary, not competing.
**Common mistake:** claiming one can fully replace the other — Terraform
can install some things via provisioners, but that's a last resort, not
its core purpose; Ansible has some provisioning modules but doesn't
manage state the way Terraform does.

### Terraform vs CloudFormation?
**Expected answer:** CloudFormation is AWS-native and only manages AWS
resources; Terraform is provider-agnostic and can manage AWS, Azure,
GCP, Kubernetes, GitHub, and more from one tool and one state model.
**Key points:** multi-cloud/multi-provider capability, HCL vs
YAML/JSON, community module ecosystem.
**Common mistake:** claiming one is unconditionally "better" — the
right answer depends on whether the organization is single-cloud
AWS-only or needs to manage multiple providers/tools consistently.

### What is declarative infrastructure?
**Expected answer:** You describe the desired end state, not the steps
to get there; the tool computes what changes are needed.
**Key points:** contrast with imperative ("run these commands in
order"); idempotency follows naturally from being declarative.
**Common mistake:** describing Terraform as running your resource blocks
"top to bottom like a script" — it builds a dependency graph and can
create resources in parallel where there's no dependency.

### What is a provider?
**Expected answer:** A plugin that translates Terraform configuration
into API calls for a specific platform (AWS, Azure, Kubernetes, GitHub,
etc.).
**Key points:** required for every resource type used; installed via
`terraform init`; versioned independently from Terraform core.
**Common mistake:** confusing "provider" with "backend" — see
`../concepts/backends.md` for the distinction.

### What is a resource?
**Expected answer:** A single infrastructure object Terraform creates
and manages, declared via a `resource` block with a type and a local
name.
**Key points:** resource type comes from the provider; local name is
only used within Terraform code, not the same as the real object's
cloud-side name/ID.
**Common mistake:** thinking the local resource name (e.g. `backend` in
`aws_instance.backend`) is the actual AWS resource name — it's purely a
Terraform-internal reference.

### What is a data source?
**Expected answer:** A read-only lookup of existing information —
Terraform doesn't create or manage it, only reads it.
**Key points:** `resource = manage`, `data = read`; commonly used for
AMI lookups, account metadata, or referencing infra managed elsewhere.
**Common mistake:** using a data source when you actually meant to
create the resource, or vice versa — always ask "should Terraform be
able to destroy this?"
