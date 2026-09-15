# Inventory — Static Inventory, Groups, Patterns

**What it is:** The inventory is the list of managed nodes Ansible knows about, organized into groups. Default formats: INI or YAML.

**Why:** You rarely target "one server" in production — you target roles (`webservers`, `dbservers`) so playbooks stay portable across environments.

**Mental model:**
```
Inventory
 ├── group: webservers → web1, web2
 ├── group: dbservers  → db1
 └── group: all        → everything
```

**Syntax/example — INI:**
```ini
[webservers]
web1 ansible_host=10.0.1.10
web2 ansible_host=10.0.1.11

[dbservers]
db1 ansible_host=10.0.2.10

[production:children]
webservers
dbservers

[webservers:vars]
http_port=80
```

**Syntax/example — YAML:**
```yaml
all:
  children:
    webservers:
      hosts:
        web1:
          ansible_host: 10.0.1.10
        web2:
          ansible_host: 10.0.1.11
      vars:
        http_port: 80
    dbservers:
      hosts:
        db1:
          ansible_host: 10.0.2.10
```

**Host patterns:**
| Pattern | Meaning |
|---|---|
| `all` | every host |
| `webservers` | one group |
| `web1:web2` | union of hosts |
| `webservers:&production` | intersection |
| `webservers:!web2` | exclude web2 |
| `web*` | wildcard match |

**`group_vars` / `host_vars`:** Directories that auto-load variables per group/host without cluttering the inventory file itself:
```
inventory/
├── hosts.ini
├── group_vars/
│   ├── webservers.yml
│   └── all.yml
└── host_vars/
    └── web1.yml
```

**Production use:** Separate inventory files per environment (`inventory/dev`, `inventory/staging`, `inventory/prod`) rather than one inventory with environment as a variable — reduces the blast radius of a mistyped target.

**Common mistakes:** Targeting `all` by habit and accidentally hitting production; forgetting `[group:children]` syntax for nested groups; hardcoding IPs instead of using `group_vars`.

**Troubleshooting:** `ansible-inventory --list` (or `--graph`) to see exactly what Ansible resolved before running anything destructive. If a host is "missing," check group membership and file location (`ansible.cfg`'s `inventory =` path).

**Interview-ready answer:** "Inventory defines targets as groups, not just individual hosts, so playbooks stay reusable. I keep per-environment inventory files, use `group_vars`/`host_vars` for variable scoping, and always sanity-check with `ansible-inventory --graph` before a prod run."
