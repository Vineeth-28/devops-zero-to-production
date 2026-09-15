# Ansible Production Troubleshooting Handbook

General workflow for every issue below:
```
Symptom → Likely causes → Commands/checks → Fix → Verification
```

---

## 1. UNREACHABLE

**Symptom:** `UNREACHABLE! => {"msg": "Failed to connect to the host via ssh..."}`
**Likely causes:** Wrong inventory entry, host down, network/firewall block, wrong SSH port/key.
**Commands/checks:**
```bash
ansible-inventory --list
ping <host>
ssh -i key.pem user@host
```
**Fix:** Correct inventory IP/DNS, open required ports, confirm the SSH key path in `ansible.cfg`/inventory.
**Verification:** `ansible <host> -m ping`

```
UNREACHABLE
    ↓
Check inventory
    ↓
Check IP/DNS
    ↓
Check SSH
    ↓
Check credentials
    ↓
Check security group/firewall
    ↓
Test SSH manually
    ↓
Run Ansible again
```

## 2. SSH Connection Failures

**Symptom:** Connection timeout or refused before auth even happens.
**Likely causes:** Port 22 (or custom) blocked, wrong `ansible_host`, host key changed.
**Commands/checks:** `ssh -vvv user@host`, `telnet host 22`
**Fix:** Fix security group/firewall rule, update `known_hosts` or set `host_key_checking = False` deliberately (understand the trade-off).
**Verification:** Manual SSH succeeds, then `ansible <host> -m ping` succeeds.

## 3. Permission Denied

**Symptom:** `Permission denied (publickey,password)`.
**Likely causes:** Wrong SSH key, wrong `remote_user`, key not authorized on target.
**Commands/checks:** `ssh -i key.pem -v user@host`
**Fix:** Confirm `ansible_user`/`-u`, confirm the public key is in the target's `authorized_keys`.
**Verification:** SSH succeeds without password prompt.

## 4. become/sudo Failures

**Symptom:** `Missing sudo password` or `sudo: a password is required`.
**Likely causes:** `become: true` set but no `--ask-become-pass`/NOPASSWD sudoers entry.
**Commands/checks:** `sudo -l` on the target as that user.
**Fix:** Configure passwordless sudo for the automation user (preferred in prod) or pass `--ask-become-pass` for interactive runs.
**Verification:** A `become`-required task succeeds without prompting.

## 5. Wrong Inventory

**Symptom:** Play runs against the wrong hosts, or "no hosts matched."
**Likely causes:** Typo in group name/pattern, wrong `-i` path, host in wrong group.
**Commands/checks:** `ansible-inventory --graph`
**Fix:** Correct the host pattern or inventory file path.
**Verification:** `ansible-playbook site.yml --list-hosts`

## 6. Wrong IP/DNS

**Symptom:** Connects to the wrong machine or times out.
**Likely causes:** Stale `ansible_host`, DNS not resolving, elastic IP changed (common after infra recreation).
**Commands/checks:** `dig <hostname>`, `ansible-inventory --list`
**Fix:** Update inventory (ideally dynamically sourced from Terraform/cloud inventory plugin instead of hand-maintained).
**Verification:** `ansible <host> -m ping`

## 7. Firewall / Security-Group Problems

**Symptom:** UNREACHABLE despite correct IP/key.
**Likely causes:** Security group doesn't allow the control node's IP on port 22/5986.
**Commands/checks:** Check cloud console / `aws ec2 describe-security-groups`
**Fix:** Add an inbound rule scoped to the control node/CI runner IP range — not `0.0.0.0/0`.
**Verification:** Manual SSH from the control node succeeds.

## 8. Python/Interpreter Problems

**Symptom:** `/usr/bin/python: not found` or module fails with an interpreter traceback.
**Likely causes:** Minimal/slim base image with no Python, or multiple Python versions confusing auto-detection.
**Commands/checks:** `ansible <host> -m ansible.builtin.setup -a "filter=ansible_python*"`
**Fix:** Set `ansible_python_interpreter` explicitly in inventory/`group_vars`, or install Python via a bootstrap raw command.
**Verification:** `ansible <host> -m ping` succeeds.

## 9. Package Installation Failures

**Symptom:** `package` / `apt` / `yum` task fails.
**Likely causes:** Stale package cache, wrong repo/mirror, network blocked from the target, package name differs across distros.
**Commands/checks:** Run the equivalent manual install on the box; check `/var/log/apt` or `yum.log`.
**Fix:** `update_cache: true` on `apt`, confirm repo access, use `ansible.builtin.package` for cross-distro portability.
**Verification:** Re-run with `--check` then for real; confirm `changed` then `ok` on the next run.

## 10. Service Failures

**Symptom:** Service task succeeds but the service isn't actually up.
**Likely causes:** Config file error preventing startup, dependency not running, wrong service name per distro.
**Commands/checks:** `systemctl status <service>`, `journalctl -u <service> -n 50`
**Fix:** Fix the underlying config (often a template rendering issue), correct the service name.
**Verification:** `systemctl is-active <service>` returns `active`.

## 11. Template / Jinja Errors

**Symptom:** `AnsibleError: template error while templating string`.
**Likely causes:** Unclosed `{% if %}`/`{% for %}`, bad filter, syntax typo in `.j2`.
**Commands/checks:** `-vvv` to see the exact template line; `ansible.builtin.template` in `--check --diff` to preview.
**Fix:** Correct the Jinja syntax; add `| default(...)` where a variable may be absent.
**Verification:** Template renders and `--diff` shows the expected output.

## 12. Undefined Variables

**Symptom:** `'some_var' is undefined`.
**Likely causes:** Variable expected from `group_vars`/role defaults/`-e` was never actually set for this host.
**Commands/checks:** `ansible.builtin.debug: var=some_var`, check variable precedence chain.
**Fix:** Add a `defaults/main.yml` entry, or `| default(...)` in the template/task.
**Verification:** Task/template renders without error.

## 13. Handler Not Triggered

**Symptom:** Expected restart doesn't happen.
**Likely causes:** Notifying task reported `ok`, not `changed`; handler name typo; a failed task earlier in the play skipped handler execution.
**Commands/checks:** Check the task's reported status in play output; confirm `notify:` string matches the handler `name:` exactly.
**Fix:** Fix the typo, or use `ansible-playbook site.yml --force-handlers` if handlers must run despite an unrelated failure.
**Verification:** Re-run and confirm the handler appears in the "RUNNING HANDLER" output.

## 14. Unexpected `changed` State

**Symptom:** A task reports `changed` on every run, even when nothing meaningfully changed.
**Likely causes:** `command`/`shell` without `changed_when`; a template whose rendered output has trivial diffs (timestamps, ordering) every run.
**Fix:** Add `changed_when` (often `changed_when: false` for read-only commands), stabilize template output.
**Verification:** Second consecutive run reports `ok`, not `changed`.

## 15. Idempotency Issues

**Symptom:** Re-running the playbook keeps "fixing" the same thing.
**Likely causes:** Using `shell`/`command` for something a dedicated module should do; a task that appends rather than sets state (e.g., `lineinfile` misuse, or `shell: echo ... >> file` in a loop).
**Fix:** Replace with the correct idempotent module (`lineinfile`, `blockinfile`, `copy`, `template`).
**Verification:** `ansible-playbook site.yml` twice in a row — second run should be all `ok`.

## 16. Vault Failures

**Symptom:** `Decryption failed` or `ERROR! Attempting to decrypt but no vault secrets found`.
**Likely causes:** Wrong vault password, wrong `--vault-id`, missing `--ask-vault-pass`/`--vault-password-file` flag entirely.
**Commands/checks:** `ansible-vault view <file> --vault-password-file ~/.vault_pass`
**Fix:** Supply the correct password/vault-id for that file's encryption; confirm the vault password file itself is present and correct in CI.
**Verification:** File decrypts/views successfully; playbook run proceeds past the vars load step.

## 17. CI/CD Execution Failures

**Symptom:** Pipeline job running the playbook fails, though it works locally.
**Likely causes:** CI runner lacks SSH key/vault password (secret not injected), wrong inventory selected for the target environment, missing Ansible/collection versions pinned differently than local.
**Commands/checks:** Check the CI job logs for the actual `ansible-playbook` invocation and flags used; confirm secrets are mounted/env-injected, not hardcoded.
**Fix:** Ensure CI secret store supplies the SSH key and vault password; pin `requirements.yml`/Ansible version to match local; select inventory explicitly per environment (`-i inventory/prod`).
**Verification:** Pipeline run succeeds end-to-end against a staging target before promoting to prod.
