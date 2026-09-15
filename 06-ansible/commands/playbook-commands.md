# Playbooks — Structure, Variables, Conditions, Loops, Handlers

## Playbook / Play / Task — the anatomy

**What it is:** A **playbook** is a YAML file containing one or more **plays**. A play maps a set of **hosts** to an ordered list of **tasks**. Each task calls one **module** with arguments.

**Why:** This layering is what makes automation declarative and reviewable — the playbook reads like a runbook, not a script.

**Mental model:**
```
Playbook
 └── Play (hosts: webservers)
      ├── Task 1 → Module (package)
      ├── Task 2 → Module (service)
      └── Task N → Module (...)
```

**Syntax/example:**
```yaml
---
- name: Configure web server
  hosts: webservers

  tasks:
    - name: Install nginx
      ansible.builtin.package:
        name: nginx
        state: present

    - name: Start nginx
      ansible.builtin.service:
        name: nginx
        state: started
```

**YAML rules that bite:** 2-space indentation (never tabs), list items start with `- `, a play/task is a dict — misaligned keys silently break parsing or, worse, parse into the wrong structure.

**Production use:** One playbook can define multiple plays targeting different host groups (e.g., configure `dbservers` first, then `webservers`) so ordering across tiers is explicit in one file.

**Common mistakes:** Mixing tabs and spaces; giving tasks no `name` (makes output unreadable and debugging painful); one giant play instead of splitting into roles once it grows.

**Troubleshooting:** `ansible-playbook site.yml --syntax-check` catches YAML/structure errors before any connection is made.

**Interview-ready answer:** "A playbook is an ordered list of plays; each play binds a host pattern to a list of tasks; each task runs one module. That structure is what keeps automation both human-readable and machine-executable."

---

## Variables

**What it is:** Named values substituted into tasks/templates with `{{ variable }}`. Sources include `vars:` blocks, `group_vars/`, `host_vars/`, role `defaults/vars`, facts (`ansible_facts`), and `register`ed task output.

**Why:** Hardcoded values mean one playbook per environment/host. Variables make one playbook reusable everywhere.

**Mental model:** Variables are resolved at runtime by precedence — the "closest scope wins" (roughly: extra-vars > task vars > play vars > host_vars > group_vars > role defaults).

**Syntax/example:**
```yaml
vars:
  web_package: nginx

tasks:
  - name: Install web package
    ansible.builtin.package:
      name: "{{ web_package }}"
      state: present
```
Facts:
```yaml
- name: Show OS family
  ansible.builtin.debug:
    msg: "{{ ansible_facts['os_family'] }}"
```
Register:
```yaml
- name: Check nginx status
  ansible.builtin.command: systemctl is-active nginx
  register: nginx_status
  changed_when: false
```

**Practical variable precedence (high level, lowest → highest):** role `defaults` → inventory `group_vars` → inventory `host_vars` → play `vars` → task `vars` → `-e`/`--extra-vars` (always wins, used for CI/CD overrides).

**Production use:** Keep environment-specific values in `group_vars/<env>.yml`, secrets in Vault-encrypted files, and use `-e` only for one-off overrides (e.g., a specific `--tags deploy` release version) — not as the primary config mechanism.

**Common mistakes:** Defining the same variable in three places and being surprised which one "won"; forgetting `register` output is a rich dict (`.stdout`, `.rc`, `.stdout_lines`), not just a string.

**Troubleshooting:** `ansible-playbook site.yml -e "web_package=nginx" -vvv` to see resolved values; `ansible.builtin.debug: var=some_var` inside the playbook to inspect at runtime.

**Interview-ready answer:** "Variables come from several scopes — role defaults, inventory group/host vars, play vars, and extra-vars — resolved by a defined precedence where extra-vars always wins. That's what lets one playbook run correctly across dev, staging, and prod."

---

## Conditions (`when`) & Loops

**What it is:** `when` gates whether a task runs, evaluated against facts, variables, or registered results. `loop` runs a task once per item in a list, exposing the current value as `item`.

**Why:** Avoids writing near-duplicate tasks for OS variants or lists of similar resources (users, packages, files).

**Mental model:**
```
task → evaluate `when` → True: run / False: skip (state: "skipped")
loop: [a, b, c] → task(a), task(b), task(c)
```

**Syntax/example:**
```yaml
- name: Install package on Debian family
  ansible.builtin.apt:
    name: nginx
    state: present
  when: ansible_facts['os_family'] == "Debian"

- name: Create application users
  ansible.builtin.user:
    name: "{{ item }}"
    state: present
  loop:
    - appuser
    - deploy
    - monitoring
```
Conditioning on a registered result:
```yaml
- name: Restart app only if config changed
  ansible.builtin.service:
    name: myapp
    state: restarted
  when: config_result.changed
```

**Task result states:** `ok` (no change needed), `changed` (state was modified), `failed` (task errored), `skipped` (`when` was false) — these drive both handler notification and play recaps.

**Production use:** `when` for OS/environment branching in shared roles; `loop` for anything list-shaped (users, packages, firewall rules) instead of copy-pasted tasks.

**Common mistakes:** Comparing facts as strings vs the wrong type (`ansible_facts['ansible_distribution_major_version']` is a string, not an int, without casting); using `with_items` (legacy) instead of `loop` in new code; forgetting `when` applies per loop iteration, not to the whole loop at once.

**Troubleshooting:** Run with `-vvv` and check the `skip_reason`/evaluated condition in the output; `ansible.builtin.debug: msg="{{ item }}"` inside a loop to confirm what's actually being iterated.

**Interview-ready answer:** "`when` conditionally runs a task based on facts, variables, or registered output; `loop` runs a task once per list item. Both keep roles OS-agnostic and DRY instead of duplicating near-identical tasks."

---

## Handlers

**What it is:** A handler is a task that only runs when explicitly `notify`-ed by another task, and only if that task reported `changed`. Handlers run once, after all regular tasks in the play, regardless of how many times they were notified.

**Why:** Avoids unnecessary restarts — e.g., restart nginx only if its config actually changed, not on every single run.

**Mental model:**
```
Configuration changed
        ↓
      notify
        ↓
     handler
        ↓
Restart nginx

If configuration didn't change → handler is not triggered.
```

**Syntax/example:**
```yaml
tasks:
  - name: Deploy nginx config
    ansible.builtin.template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
    notify: Restart nginx

handlers:
  - name: Restart nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
```

**Multiple notifications:** If five tasks all `notify: Restart nginx` in the same play, the handler still runs only once, at the end — not five times.

**Production use:** Chain related handlers (e.g., "Restart nginx" notifying "Reload firewall") for multi-step reactions to a single config change; use `meta: flush_handlers` mid-play if a later task depends on the handler having already run.

**Common mistakes:** Typo'ing the handler name in `notify` (fails silently — no error, it just never runs, since Ansible treats it as "no handler by that name found" only at parse time in newer versions, but is still a classic bug); expecting a handler to run immediately rather than at end-of-play; putting real logic in a handler instead of a proper task.

**Troubleshooting:** "Handler not triggered" → confirm the notifying task actually reported `changed` (not `ok`), confirm the handler name matches exactly, and confirm nothing failed earlier in the play (a failure skips handler execution unless `--force-handlers` is used).

**Interview-ready answer:** "Handlers are tasks that only run when notified by a `changed` task, and they run once at the end of the play even with multiple notifications. That's how we avoid restarting a service on every run and only do it when the underlying config actually changed."
