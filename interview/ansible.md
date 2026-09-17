# Ansible Interview Questions

Based on `../06-ansible/` (commands/, playbooks/, troubleshooting/, workflows/).

---

## Q1. Explain the relationship between inventory, playbook, play, task, and module.

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Whether you have the core vocabulary straight — these terms nest inside each other and are often mixed up.

### Expected Answer
Inventory lists the managed hosts (and groups of hosts). A playbook is a YAML file containing one or more plays. A play maps a set of tasks to a group of hosts from the inventory. A task is a single action within a play, invoking a module (the actual unit of work — e.g. `apt`, `copy`, `service`) with specific arguments.

### Strong Interview Answer
"They nest: inventory is the list of hosts and groups I'm managing. A playbook is a file that can contain multiple plays. A play targets a specific group of hosts from inventory and defines a list of tasks to run against them. Each task calls a module — like `apt` to install a package or `service` to manage a systemd unit — with specific parameters. So the flow is: playbook → play (hosts + tasks) → task (calls a module) → module (does the actual work)."

### Follow-up Questions
- Can one playbook target different host groups in different plays?
- What's the difference between a task calling a module and a role?
- How does Ansible decide the order tasks run in?

### Key Points
- Inventory = hosts/groups; Playbook = file of plays; Play = hosts + tasks; Task = one action calling a Module.
- A playbook can have multiple plays targeting different host groups.
- Modules are the actual units of work; tasks just invoke them with arguments.

---

## Q2. What does "idempotency" mean in Ansible, and why does `command`/`shell` break it by default?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
A very common real gotcha — using `command`/`shell` when a proper module exists, breaking safe re-runnability.

### Expected Answer
Idempotent means running the same playbook multiple times produces the same end state without unintended side effects — a task that's already satisfied reports "ok" (no change) rather than re-doing the action. Most built-in modules (`apt`, `copy`, `service`, etc.) are idempotent by design — they check current state before acting. `command` and `shell` just execute a raw command every time regardless of current state, so they're not idempotent unless you add your own guard (`creates`/`changed_when`) — running them repeatedly can cause unwanted side effects (e.g. `command: useradd bob` failing/erroring on the second run instead of no-op'ing).

### Strong Interview Answer
"Idempotency means I can run the same playbook a hundred times and end up in the same state every time, with no-op reported for tasks that are already satisfied. Most built-in modules are written to check current state first — `apt` checks if the package is already installed before doing anything. `command` and `shell` don't do that at all; they just blindly execute the given command every single run, so something like `command: useradd bob` will error out on the second run because the user already exists, instead of correctly reporting 'no change needed.' I use `command`/`shell` only when there's no proper module for what I need, and I guard them with `creates:` or `changed_when:` so they behave idempotently too."

### Follow-up Questions
- How would you make a `command` task idempotent using `creates`?
- Why do most experienced Ansible users try to avoid `command`/`shell` where possible?
- What does `changed_when: false` communicate to Ansible's reporting?

### Key Points
- Idempotent = repeated runs converge to the same state, no-op if already satisfied.
- Built-in modules check state first; `command`/`shell` just blindly execute every time.
- Guard `command`/`shell` with `creates:`/`changed_when:` to restore idempotent behavior.

---

## Q3. What does `UNREACHABLE` mean in Ansible output, and how is it different from a task `FAILED`?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you know these point to entirely different layers — connectivity vs. execution.

### Expected Answer
`UNREACHABLE` means Ansible couldn't even connect to the host (SSH failure, host down, wrong credentials, network unreachable) — it never got to run any task. `FAILED` means Ansible connected successfully and a specific task/module ran, but that task's logic determined it didn't succeed (e.g. a package install failed, a condition wasn't met).

### Strong Interview Answer
"`UNREACHABLE` is a connectivity problem — Ansible couldn't SSH into the host at all, so no tasks ran against it, whatever the reason: host down, wrong key, network blocked, wrong inventory IP. `FAILED` means the connection worked fine, Ansible got in and ran the task, but the module itself reported failure — like `apt` failing because a package doesn't exist, or a task's condition explicitly returning failure. So `UNREACHABLE` sends me to network/SSH/inventory troubleshooting, while `FAILED` sends me to the actual task output to understand what went wrong on that specific action."

### Follow-up Questions
- What Ansible connection settings would you check first for an `UNREACHABLE` host?
- Can a play continue to other hosts if one is `UNREACHABLE`?
- How would you debug a `FAILED` task's exact error output?

### Key Points
- `UNREACHABLE` = connectivity failure, no task even ran (SSH/network/inventory layer).
- `FAILED` = connected fine, but the task/module itself failed (execution layer).
- Different failure layers need different troubleshooting starting points.

---

## Q4. What's a handler, and why use one instead of just adding the action as another task?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Understanding of the notify/handler pattern for avoiding unnecessary repeated actions.

### Expected Answer
A handler is a task that only runs when explicitly notified by another task, and only if that task reported a change — and even if notified multiple times, it runs once at the end of the play. Common use: restarting a service only if its config file actually changed, rather than restarting it on every playbook run regardless of whether anything changed.

### Strong Interview Answer
"A handler only fires when a task notifies it, and only if that task actually reported a change — plus, even if several tasks notify the same handler, it only runs once, at the end of the play. The classic use is restarting a service: I don't want to restart nginx on every single playbook run, only when its config file actually changed. So the `copy` task for the config file has `notify: restart nginx`, and the handler only fires — and only once — if that copy actually changed something."

### Follow-up Questions
- When exactly do handlers run relative to the rest of the tasks in a play?
- What happens if a task that would notify a handler is skipped due to a condition?
- Can you force a handler to run immediately instead of at the end of the play?

### Key Points
- Handlers run only when notified, and only if the notifying task reported a change.
- Multiple notifications collapse into a single run, typically at end of play.
- Classic use: conditional service restarts tied to actual config changes.

---

## Q5. What are Ansible roles, and why structure a project around them?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Understanding of Ansible's standard project organization for reusability.

### Expected Answer
A role is a standardized directory structure (tasks/, handlers/, templates/, vars/, defaults/, files/) that packages related automation as a reusable, self-contained unit — e.g. a "nginx" role that installs, configures, and manages the nginx service. Playbooks then just reference roles rather than inlining all the tasks, making automation modular and reusable across playbooks/projects.

### Strong Interview Answer
"A role is a conventional folder structure — tasks, handlers, templates, default variables — that packages a coherent piece of automation, like everything needed to set up nginx, as one reusable unit. Instead of one giant playbook with every task inlined, I structure things as roles and my playbooks become mostly just a list of roles to apply to a group of hosts. That makes it reusable across projects — the `nginx` role doesn't change whether I'm using it for staging or production, only the variables passed to it do."

### Follow-up Questions
- What's the difference between `vars/` and `defaults/` inside a role?
- How would you override a role's default variable from a playbook?
- How do role dependencies work?

### Key Points
- Role = standard directory structure packaging reusable automation as a unit.
- Playbooks become mostly a list of roles applied to host groups, cleaner and reusable.
- `defaults/` = easily overridden defaults; `vars/` = higher-precedence, less commonly overridden.

---

## Q6. What is Ansible Vault used for, and how does it fit into a real deployment workflow?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Secrets-handling awareness in configuration management.

### Expected Answer
Vault encrypts sensitive data (passwords, API keys, certificates) within playbooks/variable files so they can be safely committed to version control. At run time, Ansible decrypts vault-encrypted content using a vault password (or password file/prompt), so playbooks can reference secrets by variable name without them ever being stored in plaintext in the repo.

### Strong Interview Answer
"Vault lets me encrypt sensitive variables — database passwords, API keys — so I can safely commit them to git rather than keeping secrets out-of-band and hoping everyone manages them consistently. I'd encrypt a `vars/vault.yml` file with `ansible-vault encrypt`, and at run time Ansible decrypts it using a vault password, often supplied via `--vault-password-file` in CI so it's not typed interactively. The playbook itself just references the variable name normally — it doesn't need to know or care that the value came from an encrypted source."

### Follow-up Questions
- How would you rotate the vault password itself if it were compromised?
- What's the difference between encrypting an entire file vs. a single variable with `ansible-vault encrypt_string`?
- How would you supply the vault password securely in a CI pipeline?

### Key Points
- Vault encrypts sensitive data so it's safe to commit to version control.
- Decryption happens at run time using a vault password (often via a password file in CI).
- Playbooks reference the variable normally — encryption is transparent to the task logic.

---

## Q7. Command vs shell module — what's the actual difference, and which do you default to?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Precise understanding, not just "they both run commands."

### Expected Answer
`command` runs the given command directly without invoking a shell — no shell features like pipes, redirects, or environment variable expansion work. `shell` runs the command through an actual shell (`/bin/sh` by default), so pipes/redirects/variable expansion all work, but it's more prone to unexpected behavior (and slightly less safe, since it interprets shell syntax). Default to `command` unless you specifically need shell features.

### Strong Interview Answer
"`command` runs the program directly, bypassing a shell entirely, so things like pipes, `>` redirects, or `$HOME` expansion don't work — but that also makes it more predictable and slightly safer. `shell` actually invokes a real shell to run the command, so all that shell syntax works, but it also means you're now exposed to shell quoting/escaping issues and it's a bit more of an attack surface if any input is untrusted. My default is `command`, and I only reach for `shell` when I specifically need a pipe or redirect that `command` genuinely can't do."

### Follow-up Questions
- Why is `shell` considered riskier if a variable in the command comes from untrusted input?
- Give an example of something you can only do with `shell`, not `command`.
- Is there a proper module you should prefer over either, for a common task like copying a file?

### Key Points
- `command` = no shell involved, no pipes/redirects/variable expansion, more predictable.
- `shell` = runs through an actual shell, supports pipes/redirects, more flexible but riskier.
- Default to `command`; use `shell` only when shell features are genuinely required.

---

## Q8. How does Ansible's control node / managed node model work, and what does it need to reach a managed node?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Basic architecture understanding — agentless design is a common talking point.

### Expected Answer
Ansible is agentless: the control node (where you run `ansible-playbook`) connects to managed nodes over SSH (by default, for Linux) and pushes tasks to execute, typically via Python modules copied over temporarily. No persistent agent needs to be installed on managed nodes — just SSH access and (usually) Python present.

### Strong Interview Answer
"Ansible is agentless — there's no daemon running permanently on managed nodes. The control node, wherever I run `ansible-playbook` from, connects out over SSH to each managed host, copies over the Python module code needed for that task, executes it, and cleans up. That means the only real requirements on a managed node are SSH access and Python being present — nothing to pre-install or maintain as a long-running service, which is a meaningful operational difference from agent-based tools."

### Follow-up Questions
- What would break Ansible's ability to manage a host if Python weren't installed there?
- How does Ansible handle Windows hosts, which don't typically use SSH the same way?
- What's the performance implication of Ansible's push model vs. an agent-based pull model?

### Key Points
- Agentless: control node connects via SSH, no persistent daemon on managed nodes.
- Requires SSH access and Python present on the managed node.
- Push model — control node initiates, unlike agent-based pull tools.

---

## Q9. A playbook run reports several hosts as `changed` and a few as `ok`. What does that distinction mean, and why does it matter?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you actually read Ansible's output meaningfully rather than just checking for failures.

### Expected Answer
`ok` means the task ran and determined no change was needed (state was already as desired) — this is the expected, healthy outcome for idempotent re-runs. `changed` means the task actually modified something on that host. Seeing unexpected `changed` on a host during a routine re-run (where you expected everything to already be `ok`) is a signal worth investigating — either legitimate drift being corrected, or a non-idempotent task doing something every time.

### Strong Interview Answer
"`ok` means the task checked current state and it already matched what's desired, so nothing was done — that's actually the outcome I want to see on most tasks during a routine re-run. `changed` means something was actually modified. If I run the same playbook twice in a row and see unexpected `changed` results the second time on tasks I'd expect to be stable, that's a signal — either there's genuine drift being corrected each time, or more likely, a task isn't actually idempotent and is re-doing work it shouldn't need to. I pay attention to the changed/ok ratio, not just whether the run was green."

### Follow-up Questions
- What would repeatedly seeing 'changed' on the same task across runs suggest to you?
- How does `--check` mode (dry run) interact with this ok/changed reporting?
- How would you audit a whole playbook for idempotency issues?

### Key Points
- `ok` = task ran, no change needed (expected healthy state on re-runs).
- `changed` = task actually modified something.
- Unexpected repeated `changed` on stable tasks signals a non-idempotent task or real drift.

---

## Q10. How does Ansible fit into a CI/CD pipeline alongside Terraform?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
End-to-end pipeline thinking, connecting provisioning and configuration management stages.

### Expected Answer
Terraform runs first to provision infrastructure and output relevant details (like new instance IPs). Those outputs feed Ansible's inventory (often a dynamic inventory script or a generated inventory file), and Ansible then runs to configure/deploy onto those hosts. In CI, this is typically two sequential pipeline stages: `terraform apply` → generate/update inventory → `ansible-playbook`.

### Strong Interview Answer
"In a pipeline, Terraform runs first and provisions the actual infrastructure, and I'd have it output things like the new instances' IPs. That output feeds into Ansible's inventory — sometimes via a Terraform output parsed into a generated inventory file, sometimes via a dynamic inventory plugin that queries the cloud provider directly. Then a second pipeline stage runs `ansible-playbook` against that inventory to install and configure the actual application on the freshly provisioned hosts. So the pipeline is clearly staged: provision, then configure, each tool doing its own job."

### Follow-up Questions
- What's a dynamic inventory, and how does it avoid manually maintaining a static inventory file?
- What would you do if Terraform's apply succeeded but Ansible's stage failed?
- How would you avoid Ansible running against stale/incorrect inventory if Terraform's output changed?

### Key Points
- Pipeline stages: Terraform provisions → outputs feed inventory → Ansible configures.
- Dynamic inventory avoids manually maintaining host lists as infrastructure changes.
- Clear separation of concerns: provisioning vs. configuration, each tool doing its job.

---
