# Values Commands

### Using a values file
- **Purpose:** Override defaults with an environment-specific file.
- **Syntax:** `helm upgrade --install <release> <chart> -f <values-file>`
- **Example:**
  ```bash
  helm upgrade --install backend ./charts/backend \
    -f values-production.yaml
  ```
- **Production use:** Standard way to deploy the same chart differently per environment.

### `--set`
- **Purpose:** Override a single value inline, without editing a file.
- **Syntax:** `helm upgrade --install <release> <chart> --set <key>=<value>`
- **Example:**
  ```bash
  helm upgrade --install backend ./charts/backend \
    --set image.tag=2.0.0
  ```
- **Production use:** CI/CD pipelines commonly `--set image.tag=$CI_COMMIT_SHA` on top of a values file.

### When to prefer values files vs `--set`

| Use `-f values-file.yaml` when... | Use `--set` when... |
|---|---|
| Many values differ per environment | Only one or two values need overriding |
| You want the config reviewable/versioned in Git | It's a quick manual override or CI variable injection |
| Nested/structured config (lists, maps) | Simple scalar values |

**Rule of thumb:** values files for structural/environment config, `--set` for CI-injected values like image tag or build number. Avoid long chains of `--set` flags — they become unreadable and easy to typo.

### `helm show values`
- **Purpose:** Print default values before overriding.
- **Syntax:** `helm show values <chart>`
- **Example:** `helm show values ./charts/backend`
