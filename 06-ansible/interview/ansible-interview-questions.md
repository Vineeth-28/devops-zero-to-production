# Ansible Interview Questions (40–60)

Organized: Beginner → Intermediate → Production → Scenario-based.

## Beginner

1. **What is Ansible?**
   Agentless automation tool that configures machines and deploys apps over SSH/WinRM using declarative YAML playbooks.
2. **What does "agentless" mean and why does it matter?**
   No persistent daemon on managed nodes — connects on-demand over SSH/WinRM, reducing attack surface and maintenance overhead.
3. **What is a Control Node?**
   The machine where Ansible/playbooks run and inventory/vault live.
4. **What is a Managed Node?**
   A target machine configured by Ansible; needs SSH/WinRM access and a Python (or PowerShell) interpreter.
5. **What is an inventory?**
   The list of managed hosts, organized into groups, that Ansible targets.
6. **Static vs dynamic inventory?**
   Static: hand-maintained INI/YAML file. Dynamic: generated at runtime from a source of truth (cloud API, CMDB) via an inventory plugin/script.
7. **What is a module?**
   A unit of work Ansible executes on a target — e.g., `ansible.builtin.package`, `ansible.builtin.service`.
8. **What is an ad-hoc command?**
   A single CLI invocation of a module against a target, without a playbook — e.g., `ansible all -m ping`.
9. **What is a playbook?**
   A YAML file of one or more plays describing desired state and the tasks to reach it.
10. **What is a play?**
    A mapping of a host pattern to an ordered list of tasks.
11. **What is a task?**
    A single module invocation with arguments, inside a play.
12. **What does idempotency mean?**
    Running the same automation repeatedly converges to, and stays at, the same end state without unnecessary changes.
13. **command vs shell module?**
    `command` runs a binary directly (no shell features); `shell` runs through `/bin/sh` (pipes/redirects work, more injection risk).
14. **What is `become`?**
    Privilege escalation (e.g., sudo) for a task/play.
15. **What flag runs a playbook without making changes?**
    `--check` (dry-run); pair with `--diff` to see what would change.

## Intermediate

16. **What are `group_vars` and `host_vars`?**
    Directories that auto-load variables scoped to an inventory group or a single host.
17. **Explain variable precedence at a high level.**
    Role defaults < inventory group_vars < inventory host_vars < play vars < task vars < `-e`/extra-vars (highest).
18. **What is `register`?**
    Captures a task's result (stdout, rc, changed, etc.) into a variable for later use.
19. **What does `when` do?**
    Conditionally runs a task based on facts/variables/registered results.
20. **What does `loop` do, and what replaced it?**
    Repeats a task per list item, exposed as `item`; replaced the legacy `with_items`/`with_*` loop syntax.
21. **What are facts?**
    Auto-gathered system information (`ansible_facts`) about a managed node, e.g. OS family, IP addresses.
22. **What module gathers facts explicitly?**
    `ansible.builtin.setup`.
23. **What is a handler?**
    A task that runs only when `notify`-ed by a `changed` task, executed once at the end of the play.
24. **When do handlers run if notified five times in one play?**
    Once, at the end of the play — not five times.
25. **What is Jinja2 used for in Ansible?**
    Templating dynamic config files (`.j2`) with variable substitution, conditionals, loops, and filters.
26. **What module renders a `.j2` file?**
    `ansible.builtin.template`.
27. **What's the `default` filter for?**
    Provides a fallback value when a variable is undefined, avoiding template errors.
28. **What is a role?**
    A standard directory convention (tasks/handlers/templates/files/defaults/vars/meta) packaging reusable automation.
29. **Difference between `defaults/main.yml` and `vars/main.yml` in a role?**
    `defaults` is low-precedence, meant to be overridden by callers; `vars` is higher-precedence, role-internal.
30. **What is Ansible Galaxy?**
    A registry for sharing/installing community or private roles and collections.
31. **What is Ansible Vault?**
    A tool to encrypt sensitive data (AES256) at rest so secrets can be committed to version control safely.
32. **Name three `ansible-vault` subcommands.**
    `create`, `edit`, `view`, `encrypt`, `decrypt` (any three).
33. **How do you supply the vault password non-interactively?**
    `--vault-password-file <path>` pointing to a securely-stored password file (never committed).
34. **What does `--limit` do?**
    Restricts a playbook run to a subset of the resolved inventory (e.g., `--limit webservers`).
35. **What does `--tags` do?**
    Runs only tasks tagged with the given tag(s), skipping the rest.

## Production

36. **Why prefer `ansible.builtin.package` over `shell: apt-get install`?**
    Idempotent, accurate `changed` reporting, cross-distro portable; `shell` always reports `changed` and is OS-specific.
37. **How do you keep secrets out of Git while still versioning config?**
    Encrypt the vars file with Ansible Vault; store only the vault password in a CI secret manager, not in the repo.
38. **How do you structure inventories across dev/staging/prod?**
    Separate inventory files/directories per environment rather than one inventory with an environment variable — reduces blast radius of mistakes.
39. **How would you safely test a playbook change before applying to prod?**
    `--syntax-check`, `ansible-lint`, `--check --diff` against staging first, then a gated prod run.
40. **What's the risk of using `shell` with unsanitized variables?**
    Command injection — a malicious or malformed variable value gets interpreted by the shell.
41. **How do you avoid restarting a service on every single run?**
    Use `notify`/handlers tied to the config task's `changed` state, not an unconditional `service: state=restarted` task.
42. **What's the purpose of `changed_when: false`?**
    Marks a task (typically a read-only `command`) as never reporting `changed`, keeping idempotency reporting accurate.
43. **How do you integrate Ansible into CI/CD securely?**
    Inject SSH key and vault password from the CI platform's secret store at runtime; never hardcode them in pipeline config.
44. **How do you handle rollback in an Ansible-driven deployment?**
    Track the deployed release version (e.g., a marker file) and re-run the deploy playbook with the previous version.
45. **How does Terraform relate to Ansible in a production pipeline?**
    Terraform provisions infrastructure; Ansible configures it afterward, often via a dynamic inventory sourced from Terraform's output.
46. **Why use `--check` and `--diff` before a prod run?**
    See exactly what would change without applying it, catching unexpected drift or mistakes before they hit production.
47. **What's a dynamic inventory and why use one in cloud environments?**
    An inventory generated at runtime from a live source (cloud API) instead of hand-maintained — avoids stale IPs after autoscaling/replacement.
48. **How do you scope `become` for least privilege?**
    Apply `become: true` per-task (or per-play) only where root/sudo is actually required, not globally for every task.

## Scenario-Based

49. **A playbook run reports `UNREACHABLE` for one host only — what do you check first?**
    That host's inventory entry (IP/DNS), then manual SSH, then security group/firewall for that specific host.
50. **A task always shows `changed`, even on repeated runs — why, and how do you fix it?**
    Likely `command`/`shell` without `changed_when`; replace with a dedicated module or add `changed_when` logic.
51. **A handler you expect to fire never runs — what are the two most likely causes?**
    The notifying task reported `ok` not `changed`, or the `notify:` name doesn't exactly match the handler's `name:`.
52. **`ansible-vault` fails with "Decryption failed" in CI but works locally — what's the likely cause?**
    CI is using the wrong vault password/vault-id, or the secret isn't being injected into the pipeline at all.
53. **After a Terraform apply, Ansible can't find the new EC2 instances — what's the likely culprit?**
    The dynamic inventory plugin's tag/filter doesn't match the newly created resources' tags.
54. **A template task fails with "undefined variable" only on one host group — how do you debug it?**
    Check that group's `group_vars` for the missing variable, or add a `| default(...)` fallback in the template.
55. **You need to deploy the same playbook to dev, staging, and prod with different variable values — how?**
    Separate inventories/`group_vars` per environment, same playbook, environment selected via `-i`.
56. **A colleague wants to restart a service manually inside a `shell` task instead of using a handler — what's the downside?**
    It restarts unconditionally on every run (breaking idempotency) instead of only when config actually changed.
57. **How would you audit what a playbook will do before running it in prod, without executing anything?**
    `ansible-playbook site.yml --list-tasks --list-hosts`, then `--check --diff` against a non-prod target.
58. **Production deploy needs to roll back immediately after a bad release — what's your fastest safe path?**
    Re-run the deploy playbook with `-e release_version=<previous_version>` against the affected hosts (idempotent, no manual cleanup needed).
59. **A new team member commits a vars file with a plaintext password — what's the correct immediate response?**
    Rotate the exposed credential immediately (Git history retains it even after removal), then re-add it via Ansible Vault.
60. **You're asked whether Terraform or Ansible should manage a newly added S3 bucket used only for app config storage — which, and why?**
    Terraform — it's infrastructure provisioning/state, not host configuration; Ansible would only consume its output (e.g., the bucket name as a variable), not create it.
