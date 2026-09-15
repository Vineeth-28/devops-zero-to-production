# Jinja2 & Templates

**What it is:** Jinja2 is the templating language Ansible uses to render dynamic files from `.j2` templates by substituting variables/facts, evaluating conditionals, and looping — via the `ansible.builtin.template` module.

**Why templates:** Config files (nginx, app configs, systemd units) differ per environment/host. A `.j2` template plus variables lets one file generate every environment's version instead of maintaining N near-identical static files.

**Mental model:**
```
Variables
    ↓
Jinja2 template
    ↓
Rendered configuration
    ↓
Managed server
```

**Basic syntax:**
| Syntax | Purpose |
|---|---|
| `{{ variable }}` | Output a value |
| `{% if condition %} ... {% endif %}` | Conditional block |
| `{% for item in list %} ... {% endfor %}` | Loop |
| `{{ variable | default('fallback') }}` | Filter — fallback if undefined |
| `{{ variable | upper }}` | Filter — transform value |

**Syntax/example — `nginx.conf.j2`:**
```
server {
    listen {{ app_port }};
    server_name {{ server_name }};

    {% if enable_ssl | default(false) %}
    ssl_certificate     {{ ssl_cert_path }};
    ssl_certificate_key {{ ssl_key_path }};
    {% endif %}

    {% for location in extra_locations | default([]) %}
    location {{ location.path }} {
        proxy_pass {{ location.upstream }};
    }
    {% endfor %}
}
```
Using the template module:
```yaml
- name: Deploy nginx configuration
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: "0644"
  notify: Restart nginx
```

**Filters worth knowing:** `default(...)`, `upper`/`lower`, `join(',')`, `to_json`/`to_yaml`, `bool`, `int`.

**Production use:** Keep templates environment-agnostic; drive differences entirely through variables (`group_vars`/`host_vars`), never hardcode an environment value inside the `.j2` file itself.

**Common mistakes:** Referencing an undefined variable with no `| default(...)` — the play fails with `'x' is undefined` at render time; forgetting `{% endif %}`/`{% endfor %}` closing tags; editing the rendered file directly on the server instead of the source template (changes get overwritten next run — which is actually the point of idempotency, but it surprises people).

**Troubleshooting:** "Template/Jinja error" or "undefined variable" — run with `-vvv` to see which variable/line failed; use `ansible.builtin.template` in `--check --diff` mode to preview the rendered output before applying it.

**Interview-ready answer:** "Templates use Jinja2 to render config files dynamically from variables and facts — `{{ }}` for substitution, `{% if %}`/`{% for %}` for logic, and filters like `default()` for safe fallbacks. That's how one template produces correct, environment-specific output instead of maintaining separate static files per host."
