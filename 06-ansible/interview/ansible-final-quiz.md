# Ansible Final Quiz (18 Questions)

Answer everything first. Answers are in a separate section at the bottom — don't scroll ahead.

1. What does "agentless" mean in Ansible's architecture?
2. What's the difference between a play and a task?
3. Fix the bug in this YAML (what's wrong, and why does it matter)?
   ```yaml
   - name: Install nginx
     ansible.builtin.package:
       name: nginx
      state: present
   ```
4. What will happen the *second* time this task runs, and why?
   ```yaml
   - name: Ensure nginx installed
     ansible.builtin.package:
       name: nginx
       state: present
   ```
5. Why does this task always report `changed`, even when nothing actually changed?
   ```yaml
   - name: Check disk space
     ansible.builtin.command: df -h
   ```
6. What flag would you add to task 5 to fix that reporting problem?
7. Given `ansible_facts['os_family'] == "Debian"`, what does the `when` clause do to a task on a RedHat host?
8. What does `loop: [a, b, c]` do to a single task definition?
9. Debugging scenario: You add `notify: Restart nginx` to a task, but the "Restart nginx" handler never runs. Name two possible causes.
10. When, exactly, does a notified handler execute relative to the rest of the play's tasks?
11. What is the purpose of `ansible.builtin.template` versus `ansible.builtin.copy`?
12. In a `.j2` template, what does `{{ app_port | default(8080) }}` do?
13. What are the three most important reasons to use roles instead of one large playbook?
14. In a role, why would you put a variable in `defaults/main.yml` instead of `vars/main.yml`?
15. What command lets you view an Ansible Vault-encrypted file's contents without permanently decrypting it on disk?
16. In the Terraform + Ansible architecture, which tool is responsible for creating an EC2 instance, and which configures software on it?
17. In a CI/CD pipeline, where should the Ansible Vault password and SSH private key come from?
18. Production scenario: `ansible-playbook site.yml` reports `UNREACHABLE` for exactly one host in a group of ten. What's your troubleshooting order — name at least four checks, in sequence?

---

## Answers

1. No persistent agent/daemon on managed nodes — Ansible connects on-demand over SSH/WinRM from the control node, runs modules, and disconnects.
2. A play maps a host pattern to an ordered list of tasks; a task is a single module invocation with arguments inside a play.
3. Indentation — `state: present` is indented one space less than `name:`, breaking the module's argument dict. YAML structure is whitespace-significant, so this is a parse-time failure.
4. It reports `ok` (no change) — the `package` module checks current state first and only installs if nginx isn't already present, demonstrating idempotency.
5. `command` (and `shell`) have no built-in concept of "did state actually change" — they report `changed` on every successful execution unless told otherwise.
6. `changed_when: false` (since `df -h` is read-only and never actually changes system state).
7. The task is skipped (`skipped` status) — the condition evaluates to `false` on a RedHat host, so the task doesn't run.
8. Runs the task once per item in the list, exposing the current value inside the task as `item`.
9. (a) The notifying task reported `ok`, not `changed` — handlers only fire on `changed`. (b) The `notify:` string doesn't exactly match the handler's `name:` field (typo).
10. At the end of the play, after all regular tasks have run — once, regardless of how many tasks notified it.
11. `template` renders a `.j2` file through Jinja2 first (variable substitution, conditionals, loops) before copying it; `copy` pushes a static file as-is with no rendering.
12. Uses the value of `app_port` if it's defined; otherwise falls back to `8080` instead of raising an "undefined variable" error.
13. Reusability across playbooks/projects, avoiding one unmaintainable monolithic playbook, and a clear separation of concerns (defaults vs internal vars vs tasks vs templates) that makes automation shareable via Galaxy.
14. `defaults/main.yml` is the lowest-precedence scope, specifically meant to be overridden by whoever calls the role — keeping the role flexible and reusable across different callers/environments.
15. `ansible-vault view <file>` (with `--vault-password-file` or `--ask-vault-pass`) — displays contents without writing a decrypted copy to disk.
16. Terraform creates the EC2 instance (infrastructure); Ansible configures software/services on it afterward (configuration management).
17. From the CI platform's secret store, injected as environment variables/secret files at pipeline runtime — never hardcoded or committed in the repo or pipeline YAML.
18. (in order) Check that host's inventory entry for a typo'd IP/DNS → confirm DNS/IP resolves and is reachable (`ping`) → manually test SSH to that host → check its security group/firewall rule specifically → check SSH key/credentials for that host → re-run `ansible <host> -m ping` to verify the fix.
