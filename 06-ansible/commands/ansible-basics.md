# Ansible Basics — Architecture, Modules, Idempotency, Vault

## Architecture

**What it is:** Ansible is an agentless automation engine. The control node connects out to managed nodes over SSH (Linux) or WinRM (Windows), pushes small module scripts, executes them, and removes them — no persistent agent/daemon on the target.

**Why:** No agent to install, patch, or secure on hundreds of servers. Lower attack surface, simpler onboarding of new hosts (just needs SSH access + Python).

**Mental model:**
```
Control Node
      ↓
   Inventory
      ↓
   SSH / WinRM
      ↓
Managed Nodes
```

**Syntax/example:** No install step on targets required beyond an interpreter:
```bash
ansible all -m ansible.builtin.ping -i inventory.ini
```

**Production use:** One (or a small, version-controlled set of) control node(s) — often a CI/CD runner — never a random laptop for prod changes.

**Common mistakes:** Assuming a Windows box can be a control node (it can't, only a managed node via WinRM). Forgetting the managed node needs a Python interpreter (or `ansible_python_interpreter` set explicitly on minimal images).

**Troubleshooting:** `UNREACHABLE` errors are almost always transport-layer (SSH/WinRM/network/interpreter), not Ansible logic — see `troubleshooting/ansible-troubleshooting.md`.

**Interview-ready answer:** "Ansible is agentless — it connects over SSH or WinRM from a control node, pushes Python (or PowerShell) modules to the managed node, executes them, and cleans up. That removes the need for a persistent agent, which simplifies security and onboarding compared to agent-based tools."

---

## `ansible.cfg` & Project Structure

**What it is:** `ansible.cfg` is the per-project configuration file (inventory path, remote user, `become` defaults, SSH args, retry/fork settings). Ansible looks for it in `ANSIBLE_CONFIG`, then `./ansible.cfg`, then `~/.ansible.cfg`, then `/etc/ansible/ansible.cfg`, in that order.

**Why:** Keeps per-project settings out of ad-hoc CLI flags and out of global machine config, so the repo is self-contained and portable.

**Mental model:** It's the project's "defaults file" — anything not overridden on the CLI or in a playbook falls back to it.

**Syntax/example:**
```ini
[defaults]
inventory = ./inventory.ini
remote_user = deploy
host_key_checking = False
retry_files_enabled = False

[privilege_escalation]
become = True
become_method = sudo
```

**Production use:** Commit `ansible.cfg` to the repo so every engineer and CI runner behaves identically; never rely on a personal `~/.ansible.cfg`.

**Common mistakes:** Disabling `host_key_checking` globally in prod without understanding the MITM trade-off; forgetting the config precedence order and wondering why CLI flags "don't work" (they should always win).

**Troubleshooting:** Run `ansible --version` — it prints which `ansible.cfg` was actually loaded.

**Interview-ready answer:** "`ansible.cfg` centralizes project defaults like inventory path and privilege escalation, following a defined lookup order, so behavior is consistent across the team and CI without needing to repeat CLI flags."

**Basic project structure:**
```
project/
├── ansible.cfg
├── inventory.ini
├── group_vars/
├── host_vars/
├── roles/
└── site.yml
```

---

## Core Modules

| Module | Purpose |
|---|---|
| `ansible.builtin.ping` | Connectivity/Python sanity check |
| `ansible.builtin.command` | Run a command, no shell features (no pipes/redirects), not idempotent |
| `ansible.builtin.shell` | Run through `/bin/sh`, supports pipes/redirects, not idempotent |
| `ansible.builtin.package` | OS-agnostic package install/remove (delegates to apt/yum/dnf) |
| `ansible.builtin.apt` | Debian/Ubuntu package management, apt-specific options |
| `ansible.builtin.yum` | RHEL/CentOS package management (or `dnf` on newer) |
| `ansible.builtin.service` | Start/stop/enable/restart a service, idempotent |
| `ansible.builtin.copy` | Push a static file to the remote host |
| `ansible.builtin.file` | Manage file/dir state, permissions, symlinks |
| `ansible.builtin.user` | Manage user accounts |
| `ansible.builtin.group` | Manage groups |
| `ansible.builtin.setup` | Gather facts (`ansible_facts`) about a managed node |

**command vs shell — what/why:** `command` runs the binary directly (no shell interpolation, safer, no pipes). `shell` goes through `/bin/sh`, so pipes, redirects, and env expansion work — but it's a bigger footgun (injection risk, less predictable).

**When to use a dedicated module instead of shell/command:** Whenever one exists for the task. Dedicated modules are idempotent and report accurate `changed` state; `command`/`shell` always report `changed` unless you add `changed_when`/`creates`/`removes` yourself.

**Idempotency — mental model:**
```
First run:  nginx not installed → Ansible installs nginx     (changed)
Second run: nginx already installed → no unnecessary change  (ok)
```

**Syntax/example:**
```yaml
- name: Ensure nginx is installed
  ansible.builtin.package:
    name: nginx
    state: present

- name: Ensure nginx is running and enabled
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true
```

**Production use:** Idempotency is what makes re-running a playbook safe (self-healing config drift) — this is the core value proposition over ad-hoc bash scripts.

**Common mistakes:** Using `shell: apt-get install -y nginx` instead of `ansible.builtin.apt` — loses idempotency and accurate change reporting, and reruns will always show `changed`.

**Troubleshooting:** If a task always reports `changed`, it's usually `command`/`shell` without `changed_when` — add one, or replace it with a real module.

**Interview-ready answer:** "Idempotency means running a playbook twice produces the same end state, with the second run reporting no changes if nothing needs to change. Ansible modules are built to check current state before acting; `command`/`shell` don't do that automatically, so we prefer dedicated modules and reserve `command`/`shell` for cases with no module, adding `changed_when`/`creates` to keep them honest."

---

## Ansible Vault & Security (see also `workflows/ansible-cicd.md` for CI/CD usage)

**What it is:** Vault encrypts sensitive data (passwords, keys, tokens) at rest inside YAML files, using AES256, so secrets can live in version control safely.

**Why:** Secrets in plaintext in Git are a permanent leak the moment the repo is cloned once — Vault keeps the repo shareable without exposing values.

**Mental model:**
```
Plain secret → ansible-vault encrypt → Encrypted file → Git
```

**Syntax/example:**
```bash
ansible-vault create secrets.yml        # new encrypted file
ansible-vault edit secrets.yml          # edit in place
ansible-vault view secrets.yml          # read only
ansible-vault encrypt vars/prod.yml     # encrypt existing file
ansible-vault decrypt vars/prod.yml     # decrypt (use sparingly)

ansible-playbook site.yml --ask-vault-pass
ansible-playbook site.yml --vault-password-file ~/.vault_pass   # never commit this file
```
Example placeholder secret (never real values):
```yaml
db_password: "{{ vault_db_password }}"   # vault_db_password defined in an encrypted vars file
```

**Production use:** Combine with `become` for least-privilege execution — don't run every task as root; scope `become` per-task where possible, and store the vault password itself in a CI secret manager, not in the repo.

**Common mistakes:** Committing the vault password file itself; decrypting a file "temporarily" to debug and forgetting to re-encrypt before pushing; using one shared vault password for every environment (prefer per-environment vault IDs: `--vault-id prod@prompt`).

**Troubleshooting:** "Decryption failed" almost always means wrong password or wrong `--vault-id` — see `troubleshooting/ansible-troubleshooting.md`.

**Interview-ready answer:** "Ansible Vault encrypts variable files with AES256 so secrets can be committed safely. In practice I use per-environment vault IDs, keep the vault password itself in a secret manager or CI secret store — never in the repo — and only decrypt locally when strictly necessary."
