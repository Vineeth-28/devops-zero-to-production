# 06 — Ansible Revision Handbook

Production-focused Ansible revision: retention, practical usage, troubleshooting, interview readiness. Not a beginner course.

```
                ANSIBLE
                   ↓
             Control Node
                   ↓
               Inventory
                   ↓
              SSH / WinRM
                   ↓
        ┌──────────┼──────────┐
        ↓          ↓          ↓
     Server 1   Server 2   Server 3
```

## Folder Map

| Folder/File | Covers |
|---|---|
| `commands/ansible-basics.md` | Architecture, control/managed nodes, `ansible.cfg`, core modules, idempotency, Vault basics |
| `commands/inventory.md` | Static inventory, groups, host patterns, `host_vars`/`group_vars` |
| `commands/ad-hoc-commands.md` | `ansible <target> -m <module> -a "..."`, common flags |
| `commands/playbook-commands.md` | Playbooks/plays/tasks, variables, `when`, loops, handlers |
| `playbooks/site.yml` `webserver.yml` `deploy.yml` | Working example playbooks |
| `roles/README.md` | Role structure, reuse, Galaxy |
| `templates/README.md` | Jinja2, `.j2` templates |
| `troubleshooting/ansible-troubleshooting.md` | 17-scenario production troubleshooting handbook |
| `workflows/terraform-ansible.md` | Terraform vs Ansible, where each fits |
| `workflows/ansible-cicd.md` | CI/CD integration, Vault in pipelines |
| `interview/ansible-interview-questions.md` | 40–60 interview Q&A |
| `interview/ansible-final-quiz.md` | 15–20 question self-test (answers separate) |

## 1. What is Ansible? Why?

Agentless automation tool that configures machines and deploys applications over SSH/WinRM, using declarative YAML playbooks. No agent to install/maintain on managed nodes — the control node pushes modules over the transport, they run once, and are removed. Chosen over scripts because it's idempotent, human-readable, and has a huge module ecosystem instead of bespoke shell logic.

## 2. Architecture — Control Node vs Managed Node

- **Control Node**: where `ansible`/`ansible-playbook` runs, holds inventory, playbooks, roles, vault. Requires Python + Ansible installed. Only one is needed (can't be Windows).
- **Managed Node**: target machine. Needs SSH (Linux) or WinRM (Windows) reachable, and a Python interpreter (WinRM path uses PowerShell instead). No agent daemon runs persistently.

```
Control Node → Inventory → SSH/WinRM → Managed Nodes
```

## 3. Inventory (see `commands/inventory.md`)

Static INI/YAML file listing hosts and groups; targets are selected with host patterns (`all`, `webservers`, `web*`, `!excluded`).

## 4. Modules (see `commands/ansible-basics.md`)

Prefer fully-qualified names (`ansible.builtin.package`, `ansible.builtin.service`) over `command`/`shell` whenever a dedicated module exists — modules are idempotent, `command`/`shell` are not by default.

## 5. Playbooks, Variables, Conditions, Loops, Handlers (see `commands/playbook-commands.md`)

Playbook → Play(s) → Task(s) → Module. Variables (`vars`, `group_vars`, `host_vars`, facts, `register`) make plays reusable. `when` gates tasks on facts/registered results. `loop` repeats a task per item. Handlers run once, at the end of the play, only `notify`-triggered by a `changed` task.

## 6. Jinja2 / Templates (see `templates/README.md`)

`.j2` files rendered by `ansible.builtin.template`, injecting variables/facts into config files with `{{ }}`, `{% if %}`, `{% for %}`, filters, and `| default(...)`.

## 7. Roles (see `roles/README.md`)

Standard directory convention (`tasks/`, `handlers/`, `templates/`, `files/`, `defaults/`, `vars/`, `meta/`) that breaks a monolithic playbook into reusable, shareable units.

## 8. Ansible Vault (see `commands/ansible-basics.md`, `workflows/ansible-cicd.md`)

```
Plain secret → ansible-vault encrypt → Encrypted file → Git
```
Never commit plaintext secrets. Use `ansible-vault create/edit/view/encrypt/decrypt`, `--ask-vault-pass`, or a vault password file (itself never committed).

## 9. Terraform vs Ansible (see `workflows/terraform-ansible.md`)

```
Terraform → AWS → VPC → EC2 → EC2 available → Ansible → Docker → Nginx → App → Services running
```
Terraform provisions infrastructure (state-based, declarative resources). Ansible configures what's already provisioned (procedural-ish, idempotent tasks). They complement, not compete.

## 10. CI/CD Workflow (see `workflows/ansible-cicd.md`)

```
Developer → GitHub → CI (Jenkins/GH Actions) → Validate → Build → Ansible → Target Servers → App Deployed
```

## 11. Troubleshooting Workflow (see `troubleshooting/ansible-troubleshooting.md`)

```
Symptom → Likely causes → Commands/checks → Fix → Verification
```

## 12. Important Commands

```bash
ansible --version
ansible-inventory --list
ansible all -m ping
ansible webservers -m ping
ansible webservers -m command -a "uptime"
ansible webservers -m shell -a "ps aux | grep nginx"

ansible-playbook site.yml
ansible-playbook site.yml --check
ansible-playbook site.yml --diff
ansible-playbook site.yml -v
ansible-playbook site.yml -vvv
ansible-playbook site.yml --limit webservers
ansible-playbook site.yml --tags deploy
```

## 13. Production Best Practices

- Idempotency first — re-running a playbook should converge, not churn.
- Prefer dedicated modules over `shell`/`command`.
- Meaningful, human-readable task names (they show in output/logs).
- Small, single-purpose, reusable roles.
- Variables over hardcoded values; secrets only via Vault.
- `become` with least privilege — don't default every task to root.
- Version control everything; code review playbook changes like application code.
- `--check` (dry-run) and `--diff` before real runs, especially in prod.
- Separate inventories/environments (dev/staging/prod) — never share vars across them carelessly.
- Log and audit playbook runs; test in staging before prod.

## 14. Interview Checklist

- [ ] Explain agentless architecture and why it matters
- [ ] Inventory: static, groups, patterns, `host_vars`/`group_vars`
- [ ] Ad-hoc vs playbook — when to use which
- [ ] Idempotency — define it, give a module example
- [ ] `command`/`shell` vs dedicated modules
- [ ] Playbook anatomy: play → task → module
- [ ] Variable precedence (high level)
- [ ] `when`, `loop`, `register`, facts
- [ ] Handlers: `notify`, execution timing, why they exist
- [ ] Jinja2 templating basics
- [ ] Role directory structure and why roles exist
- [ ] Ansible Vault workflow
- [ ] Terraform vs Ansible — clear boundary
- [ ] CI/CD integration pattern
- [ ] Debug a real `UNREACHABLE` / undefined-variable scenario out loud

## 15. Revision Checklist

- [ ] Fundamentals + architecture
- [ ] Inventory
- [ ] Ad-hoc commands
- [ ] Modules + idempotency
- [ ] Playbooks, variables, conditions, loops
- [ ] Handlers
- [ ] Jinja2/templates
- [ ] Roles
- [ ] Vault
- [ ] Terraform + Ansible integration
- [ ] CI/CD integration
- [ ] Troubleshooting (17 scenarios)
- [ ] Best practices
- [ ] 40–60 interview questions
- [ ] Final quiz (self-tested, no peeking at answers)
