# Helm Basics — Commands

### `helm version`
- **Purpose:** Check installed Helm CLI version.
- **Syntax:** `helm version`
- **Example:** `helm version`
- **Production use:** Confirm CI runner has the expected Helm version before deploys.

### `helm create <name>`
- **Purpose:** Scaffold a new chart with default structure.
- **Syntax:** `helm create <chart-name>`
- **Example:** `helm create backend`
- **Production use:** Starting point for a new service's chart — always trimmed down afterward.

### `helm repo add <name> <url>`
- **Purpose:** Register a chart repository.
- **Syntax:** `helm repo add <repo-name> <repo-url>`
- **Example:** `helm repo add bitnami https://charts.bitnami.com/bitnami`
- **Production use:** Required before installing/depending on third-party charts (Redis, Postgres, etc.).

### `helm repo update`
- **Purpose:** Refresh local cache of chart repo indexes.
- **Syntax:** `helm repo update`
- **Example:** `helm repo update`
- **Production use:** Run before installing to ensure you get the latest chart versions.

### `helm search repo <term>`
- **Purpose:** Search added repos for a chart.
- **Syntax:** `helm search repo <term>`
- **Example:** `helm search repo redis`
- **Production use:** Finding the right chart name/version to depend on.

### `helm lint <chart-path>`
- **Purpose:** Validate chart structure and template syntax without installing.
- **Syntax:** `helm lint <chart-path>`
- **Example:** `helm lint ./charts/backend`
- **Production use:** Run in CI before every deploy — catches broken templates early.

### `helm template <chart-path>`
- **Purpose:** Render the chart to plain Kubernetes YAML **without installing it**.
- **Syntax:** `helm template <release-name> <chart-path>`
- **Example:** `helm template backend ./charts/backend -f values-production.yaml`
- **Production use:** Preview exactly what will be applied — critical for reviewing changes before an upgrade.
