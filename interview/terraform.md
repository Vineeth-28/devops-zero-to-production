# Terraform Interview Questions

Based on `../05-terraform/` (concepts/, commands/, troubleshooting/, modules/, aws/).

---

## Q1. What is Terraform state, and why does Terraform need it at all?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Foundational understanding of why Terraform can't just diff against the real world directly every time.

### Expected Answer
State is Terraform's record of what it believes exists and how it maps to real infrastructure — resource IDs, attributes, dependencies. Terraform uses it to compute a diff between desired configuration and last-known-real state, then plans the minimal set of changes needed, rather than having to reverse-engineer real-world resource relationships from scratch on every run.

### Strong Interview Answer
"State is how Terraform remembers what it created and how those resources map to the actual cloud objects — their IDs, attributes, and how they depend on each other. Without it, Terraform would have no efficient way to know what already exists versus what needs to be created, updated, or destroyed to match my config — it'd have to somehow rediscover everything from the provider on every run. State is what lets `terraform plan` compute a precise diff instead."

### Follow-up Questions
- What happens if the state file and real infrastructure drift out of sync?
- Why is committing `terraform.tfstate` to git considered bad practice?
- What's stored in state that isn't in your `.tf` files?

### Key Points
- State = Terraform's record mapping config to real resource IDs/attributes.
- Enables efficient diffing (plan) instead of rediscovering everything each run.
- Should never be committed to git — often contains sensitive data and causes conflicts.

---

## Q2. Why use a remote backend for state instead of a local file, and what does state locking prevent?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Team-collaboration awareness — a very common production gotcha for anyone who's only used Terraform solo.

### Expected Answer
A local state file only exists on one machine, isn't shared with teammates, and has no locking — if two people run `apply` at the same time, they can corrupt or overwrite each other's state. A remote backend (S3 + DynamoDB, Terraform Cloud, etc.) centralizes state for the team and provides locking, so a second `apply` is blocked while one is in progress, preventing concurrent, conflicting changes.

### Strong Interview Answer
"A local state file is a single point of failure and invisible to the rest of the team — if I run `apply` from my laptop, nobody else's Terraform knows about it unless they pull my state file manually, which doesn't scale. A remote backend, like S3 with a DynamoDB table for locking, centralizes that state so everyone's working from the same source of truth, and locking specifically prevents two people running `apply` concurrently from both writing to state at the same time, which could corrupt it or silently drop one person's changes."

### Follow-up Questions
- What's the role of DynamoDB specifically in an S3 backend setup?
- What happens if a lock is left stuck after a crashed `apply`?
- How would you migrate from a local backend to a remote one on an existing project?

### Key Points
- Local state = single point of failure, not shared, no locking — unsuitable for teams.
- Remote backend centralizes state as the team's shared source of truth.
- State locking prevents concurrent applies from corrupting/conflicting on the same state.

---

## Q3. What's the difference between `terraform plan` and `terraform apply`?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Basic workflow fluency.

### Expected Answer
`plan` computes and displays the diff between current state and desired configuration without making any changes — a dry run. `apply` executes that plan against real infrastructure, creating/updating/destroying resources to match the configuration.

### Strong Interview Answer
"`plan` is a dry run — it shows exactly what Terraform would create, change, or destroy to bring reality in line with my config, without touching anything. `apply` actually executes those changes. I always run `plan` first and review it carefully, especially for anything that shows a destroy, since that's often the moment you catch an unintended change before it happens rather than after."

### Follow-up Questions
- Can `apply` run without a prior `plan` — what happens then?
- How would you save a plan and apply exactly that saved plan later?
- What in a plan output specifically worries you most, and why?

### Key Points
- `plan` = dry run, shows the diff, no changes made.
- `apply` = executes the plan against real infrastructure.
- Always review `plan` output, especially destroy actions, before applying.

---

## Q4. How do you import an existing, manually-created resource into Terraform management?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Real-world onboarding of pre-existing infrastructure — a very common practical task.

### Expected Answer
Write a resource block in configuration matching the real resource's type, then run `terraform import <resource_address> <real_resource_id>` to associate that config block with the existing real resource in state. Afterward, run `terraform plan` to check for drift between the config and the actual resource's attributes, and adjust the config until plan shows no changes.

### Strong Interview Answer
"First I write a resource block in my `.tf` files that matches the type of the existing resource, even with placeholder or best-guess attribute values. Then I run `terraform import <address> <real-id>` — that just links my config block to the existing resource in state, it doesn't change the resource itself or generate the config attributes automatically. After importing, I run `terraform plan` to see the diff between my written config and the resource's actual real-world attributes, and I keep refining the config until plan shows no changes — meaning my config now accurately represents that resource."

### Follow-up Questions
- Does `terraform import` write the resource's attributes into your `.tf` file for you?
- What would happen if you ran `apply` right after import without checking plan first?
- How do newer Terraform versions with `import` blocks change this workflow?

### Key Points
- Import links an existing resource's real ID to a config block in state — doesn't generate config.
- Always follow with `plan` to check for drift, refine config until plan is clean.
- Skipping the plan check risks `apply` unintentionally modifying the real resource to match a wrong config.

---

## Q5. What is "drift" in Terraform, and how do you detect and handle it?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Understanding of a very real production problem — infrastructure changed outside of Terraform.

### Expected Answer
Drift is when real infrastructure no longer matches what's recorded in state, usually because someone made a manual change outside Terraform (console click, another tool). Detect with `terraform plan`, which shows the unexpected diff. Handle by either updating the config to match the manual change (if it should be permanent) and reconciling state, or reverting the manual change (running `apply` to force it back to the Terraform-defined state) — decision depends on which is actually the intended source of truth.

### Strong Interview Answer
"Drift happens when someone changes a resource outside of Terraform — a console click, an emergency manual fix — so the real world no longer matches what state and config say it should be. `terraform plan` surfaces this: it'll show a diff you didn't expect, because Terraform is comparing config against real infrastructure via the provider, not just against stale state. When I hit drift, I decide deliberately: if the manual change should actually be permanent, I update my `.tf` config to reflect it so Terraform doesn't fight it going forward; if it was an unauthorized or temporary change, I let `apply` revert it back to the Terraform-defined state. What I don't do is ignore the plan output and apply blindly without understanding why there's a diff."

### Follow-up Questions
- How would you set up automated drift detection running on a schedule?
- What's the risk of drift going unnoticed for a long time?
- How would `terraform refresh` (or `plan -refresh-only`) factor into handling this?

### Key Points
- Drift = real infrastructure diverged from state, usually via manual out-of-band changes.
- `terraform plan` surfaces it as an unexpected diff.
- Deliberately choose: codify the manual change, or let Terraform revert it — never apply blindly.

---

## Q6. Explain Terraform modules and when you'd break configuration into one.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you understand modules as reusable, parameterized units, not just "a folder."

### Expected Answer
A module is a reusable, self-contained group of resources with input variables and outputs, callable from other configurations. Use modules to avoid duplicating the same resource pattern across environments/projects (e.g. a standard VPC setup), enforce consistency, and encapsulate complexity behind a clean interface.

### Strong Interview Answer
"A module packages a set of resources together with defined inputs and outputs, so it becomes a reusable unit — like a `vpc` module that takes a CIDR block and AZ count as input and outputs subnet IDs. I reach for a module when I notice I'm about to copy-paste the same resource block pattern across multiple environments or projects; wrapping it as a module means every environment gets the same consistent, tested setup, and the calling code just passes different variable values rather than duplicating the underlying resources."

### Follow-up Questions
- What's the difference between a root module and a child module?
- How do you version and pin a module sourced from a git repo or registry?
- What's the tradeoff of over-modularizing very small or simple configurations?

### Key Points
- Module = reusable resource group with defined inputs/outputs.
- Use to avoid duplication and enforce consistency across environments.
- Overuse on trivial configs adds unnecessary indirection — judgment call.

---

## Q7. What does `prevent_destroy` do, and why would you use it in production?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Safety-mindedness around irreversible operations, a key production trait.

### Expected Answer
A lifecycle setting on a resource that makes Terraform refuse to destroy it (erroring out any plan/apply that would), even if a config change would otherwise require replacement. Used to protect critical, hard-to-recreate resources (production database, state bucket itself) from accidental deletion via a config mistake or a careless `destroy`.

### Strong Interview Answer
"`prevent_destroy = true` in a resource's `lifecycle` block makes Terraform hard-stop and error out any plan or apply that would destroy that resource, instead of quietly doing it. I use it on things that would be catastrophic or extremely painful to lose — a production database, the S3 bucket holding Terraform state itself — as a guardrail against a config typo, an accidental `terraform destroy`, or a resource rename that Terraform would otherwise interpret as delete-and-recreate."

### Follow-up Questions
- What error would you see if you tried to destroy a `prevent_destroy` resource?
- How would you actually remove that resource if you genuinely needed to, later?
- What's the difference between `prevent_destroy` and just being careful with `-target`?

### Key Points
- `prevent_destroy` in `lifecycle` blocks any destroy of that resource, erroring instead.
- Use on critical, hard-to-recreate resources (prod DB, state bucket).
- To actually remove it later, you must first remove the `prevent_destroy` setting deliberately.

---

## Q8. What's the practical difference between Terraform and Ansible, and when would you use both together?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Architectural judgment about tool boundaries — a very common cross-technology question.

### Expected Answer
Terraform is for provisioning infrastructure (declarative, state-tracked — creating the VM, network, load balancer). Ansible is for configuration management (imperative-ish task execution on existing hosts — installing packages, configuring services). A common pipeline: Terraform provisions the EC2 instances/infrastructure, then Ansible configures the software running on them, often with Terraform outputting the new hosts' IPs to feed Ansible's dynamic inventory.

### Strong Interview Answer
"Terraform's job is bringing infrastructure into existence and tracking its state declaratively — the VPC, the EC2 instance, the load balancer. Ansible's job is configuring what runs on top of already-existing hosts — installing packages, deploying config files, managing services — and it doesn't track state the same way; it just executes tasks against the current inventory. In a real pipeline I'd use Terraform first to provision the instances, output their IPs, feed that into an Ansible dynamic inventory, and then run Ansible to configure and deploy the application onto those freshly created instances. They complement each other rather than compete."

### Follow-up Questions
- Could Ansible provision cloud infrastructure too — why choose Terraform instead?
- How would you wire Terraform's output directly into Ansible's inventory?
- What would make you choose one tool to do both jobs instead of combining them?

### Key Points
- Terraform = infrastructure provisioning, declarative, stateful.
- Ansible = configuration management on existing hosts, task-based.
- Common pipeline: Terraform provisions → outputs feed Ansible inventory → Ansible configures.

---

## Q9. What are Terraform workspaces, and are they a good way to separate environments (dev/staging/prod)?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Nuanced understanding — workspaces are often mis-recommended for environment separation, and a strong candidate knows the caveat.

### Expected Answer
Workspaces let you maintain multiple distinct state files for the same configuration, useful for lightweight variation (e.g. feature branches, parallel test environments). For dev/staging/production specifically, many teams prefer fully separate configurations/state (and even separate backends) rather than workspaces, because workspaces share the same code path and it's easy to accidentally apply against the wrong one, and don't provide strong isolation for very different environment needs (different account, different sizing, different modules).

### Strong Interview Answer
"Workspaces give you multiple state files under the same configuration, which is handy for something like short-lived parallel environments. But for dev/staging/production specifically, I lean away from relying on workspaces alone, because they share the exact same code and it's easy to run `apply` while forgetting which workspace you're in — a genuinely dangerous mistake against production. I prefer separate state per environment via separate backend configuration or directory structure, sometimes with shared modules, so production is more clearly isolated and harder to touch by accident."

### Follow-up Questions
- How would you structure directories/backends to separate environments instead of workspaces?
- What command shows you which workspace you're currently in, and how would you build a safety check around it?
- Is there a legitimate use case where workspaces are the right choice?

### Key Points
- Workspaces = multiple state files under one config; good for lightweight parallel variants.
- Risky for prod isolation — same code path, easy to apply against the wrong workspace.
- Many teams prefer separate configs/backends per environment for stronger isolation.

---

## Q10. `terraform apply` fails partway through, having created some resources but not others. What now?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Composure and correct process for a partial-failure state, which is common in real cloud provisioning.

### Expected Answer
Terraform state reflects exactly what was successfully created before the failure — it doesn't roll back partial changes automatically. Read the error to understand the specific failure (often a provider-side issue: quota limit, naming conflict, permissions). Fix the underlying cause, then simply re-run `terraform apply` — Terraform will see the already-created resources in state and only attempt to create/fix what's still needed, since it's declarative and idempotent.

### Strong Interview Answer
"Terraform doesn't automatically roll back what it already created — state accurately reflects whatever succeeded before the failure. First I read the actual error, since it's almost always something provider-side — hit a quota limit, a naming conflict, a permissions issue. Once I fix that root cause, I just re-run `terraform apply` — because Terraform is declarative, it compares current state (which already includes the successfully created resources) against the desired config, and only creates or fixes what's still missing or wrong. I don't need to manually clean up or figure out what succeeded; the state file already knows."

### Follow-up Questions
- Why doesn't Terraform automatically roll back a partial failure?
- What kind of provider-side errors have you seen cause this?
- How would you verify state accurately reflects reality before re-applying, if you're unsure?

### Key Points
- Terraform doesn't auto-rollback partial applies — state reflects what actually succeeded.
- Fix the root cause (usually a provider-side error), then simply re-apply.
- Declarative + idempotent design means re-apply only touches what's still needed.

---

## Q11. What's the difference between a provider and a module in Terraform?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Basic vocabulary — commonly confused by beginners.

### Expected Answer
A provider is a plugin that lets Terraform talk to a specific API (AWS, GCP, Kubernetes, etc.) — it defines the resource types available and how to create/read/update/delete them via that platform's API. A module is a reusable grouping of resources (which themselves come from providers) with its own inputs/outputs — an organizational/reuse construct, not an API integration.

### Strong Interview Answer
"A provider is what actually talks to an external API — AWS, GCP, whatever — and defines the resource and data source types available, like `aws_instance`. A module is just a way of organizing and reusing a group of resources with defined inputs and outputs; it doesn't talk to any API itself, it's composed of resources that ultimately come from providers. So a module might use the AWS provider internally, but the module itself is an organizational abstraction, not an integration point."

### Follow-up Questions
- How do you pin a provider to a specific version?
- Can a single module use multiple different providers?
- What's a data source, and how is it different from a resource?

### Key Points
- Provider = plugin/integration with an external platform's API.
- Module = reusable, organizational grouping of resources with inputs/outputs.
- A module is composed of resources from providers, not an API integration itself.

---

## Q12. What's the `lifecycle` block used for, beyond `prevent_destroy`?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Broader awareness of lifecycle customization options relevant to zero-downtime changes.

### Expected Answer
`lifecycle` also supports `create_before_destroy` (create the replacement resource before destroying the old one, useful for avoiding downtime when a change forces replacement) and `ignore_changes` (tell Terraform to ignore drift on specific attributes, useful when something outside Terraform legitimately manages a particular field).

### Strong Interview Answer
"Besides `prevent_destroy`, `create_before_destroy` is the one I use most — when a change forces resource replacement, by default Terraform destroys the old one first, which can cause downtime; `create_before_destroy` flips that order so the new resource exists before the old one goes away. `ignore_changes` is useful when something outside Terraform is allowed to modify a specific attribute — like an autoscaler adjusting instance count — so Terraform doesn't fight it by trying to reset that value back on every apply."

### Follow-up Questions
- Give an example of a change that forces resource replacement vs. an in-place update.
- What's the risk of overusing `ignore_changes`?
- How would `create_before_destroy` interact with a resource that has a unique name constraint?

### Key Points
- `create_before_destroy`: avoids downtime on forced-replacement changes.
- `ignore_changes`: lets Terraform coexist with attributes managed outside it (e.g. autoscalers).
- Both are safety/coexistence tools beyond the destroy-prevention of `prevent_destroy`.

---
