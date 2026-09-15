# Roles

**What it is:** A role is a standardized directory layout that packages tasks, handlers, templates, files, defaults, and variables into a reusable, shareable unit that a playbook can just `roles:` include by name.

**Why roles:** A single monolithic playbook with hundreds of tasks becomes unreadable and unreusable — you end up copy-pasting the "install nginx" block into every project. Roles fix that: write once, reuse across playbooks/projects.

**Problems roles solve:**
- Huge, unmaintainable playbooks
- Copy-pasted logic across projects
- No clear place for defaults vs environment overrides
- Hard to share/reuse work across teams

**Mental model:**
```
Playbook
  └── roles:
        - nginx   ──▶  roles/nginx/{tasks,handlers,templates,files,defaults,vars,meta}
```

**Role directory structure:**
```
roles/
└── nginx/
    ├── tasks/
    │   └── main.yml        # the actual task list
    ├── handlers/
    │   └── main.yml        # handlers scoped to this role
    ├── templates/
    │   └── nginx.conf.j2   # Jinja2 templates used by this role
    ├── files/
    │   └── favicon.ico     # static files copied as-is
    ├── defaults/
    │   └── main.yml        # lowest-precedence variables (safe to override)
    ├── vars/
    │   └── main.yml        # higher-precedence variables (rarely overridden)
    └── meta/
        └── main.yml        # role metadata, dependencies on other roles
```

**Syntax/example — calling a role from a playbook:**
```yaml
- name: Configure web servers
  hosts: webservers
  become: true
  roles:
    - nginx
```
Passing role variables inline:
```yaml
roles:
  - role: nginx
    vars:
      app_port: 8443
```
`tasks/main.yml` inside the role looks just like a normal task list:
```yaml
---
- name: Install nginx
  ansible.builtin.package:
    name: nginx
    state: present

- name: Deploy config
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Restart nginx
```

**defaults/ vs vars/:** `defaults/main.yml` holds the lowest-precedence variables — meant to be overridden by the caller (sane fallback values). `vars/main.yml` holds role-internal constants that callers generally shouldn't touch.

**Ansible Galaxy (concept):** A public/private registry of pre-built, shareable roles and collections (`ansible-galaxy install <role>`, or a `requirements.yml` pinning versions for reproducible builds). Useful for common needs (Docker install, common hardening baselines) instead of reinventing them.

**Production use:** One role per responsibility (`nginx`, `postgres`, `common-hardening`), composed together in the top-level playbook (`site.yml`) rather than one role trying to do everything.

**Common mistakes:** Putting environment-specific values in `vars/` instead of `defaults/` (makes the role hard to reuse); a role that silently depends on another role's side effects instead of declaring it in `meta/main.yml`; skipping `handlers/main.yml` and notifying a handler that doesn't exist in the role's own scope.

**Troubleshooting:** `ansible-playbook site.yml --list-tasks` to see exactly what a role will run without executing it; `ansible-galaxy list` to check installed role versions match `requirements.yml`.

**Interview-ready answer:** "Roles are a directory convention — tasks, handlers, templates, files, defaults, vars, meta — that turns a chunk of playbook logic into a reusable, shareable unit. I use `defaults/` for anything the caller should be able to override and reserve `vars/` for role-internal constants, and compose roles together in a top-level playbook rather than writing one giant play."
