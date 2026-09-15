# Ad-hoc Commands

**What it is:** A one-off `ansible` CLI invocation that runs a single module against a target, without writing a playbook.

**Why:** Fast for quick checks/fixes (restart a service everywhere, check disk space) where writing a whole playbook is overkill. Not meant for repeatable, multi-step production changes — that's what playbooks are for.

**Mental model:**
```
ansible <target-pattern> -m <module> -a "<module args>"
```

**Syntax/examples:**
```bash
ansible all -m ping
ansible webservers -m ping
ansible webservers -m command -a "uptime"
ansible webservers -m shell -a "ps aux | grep nginx"
```

## Key Flags

| Flag | Meaning |
|---|---|
| `-m` | Module to run (default: `command`) |
| `-a` | Module arguments |
| `-i` | Inventory file path |
| `-u` | Remote user to connect as |
| `--become` | Escalate privilege (sudo) for the task |
| `--check` | Dry-run — report what would change, change nothing |
| `-v` / `-vvv` | Verbose / very verbose output for debugging |

**More examples:**
```bash
ansible webservers -m ansible.builtin.service -a "name=nginx state=restarted" --become
ansible all -i inventory.ini -u deploy -m ansible.builtin.setup     # dump facts
ansible webservers -m ansible.builtin.package -a "name=nginx state=present" --check
```

**Production use:** Great for firefighting and one-off diagnostics (`ansible all -m shell -a "df -h"` across the fleet). Anything that needs to be repeated or audited belongs in a playbook, committed to version control.

**Common mistakes:** Using ad-hoc `shell`/`command` for something a module already does idempotently; running a mutating ad-hoc command against `all` without `--limit` or `--check` first; forgetting `--become` and getting permission-denied instead of the expected result.

**Troubleshooting:** Add `-vvv` to see the actual module invocation and connection details when a command fails unexpectedly.

**Interview-ready answer:** "Ad-hoc commands run a single module against a target pattern from the CLI — useful for quick checks or emergency fixes. I don't use them for anything that needs to be repeatable or reviewed; that goes into a playbook so it's version-controlled and idempotent."
