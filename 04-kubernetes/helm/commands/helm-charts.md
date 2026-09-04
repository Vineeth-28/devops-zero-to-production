# Chart Commands

### `helm create`
- **Purpose:** Scaffold a new chart.
- **Syntax:** `helm create <name>`
- **Example:** `helm create backend`
- **Production use:** Baseline structure — customize `templates/` and `values.yaml` from there.

### `helm package <chart-path>`
- **Purpose:** Package a chart directory into a versioned `.tgz`.
- **Syntax:** `helm package <chart-path>`
- **Example:** `helm package ./charts/backend`
- **Production use:** Publishing a chart to an internal chart repository (e.g. ChartMuseum, OCI registry).

### `helm dependency update`
- **Purpose:** Download dependency charts declared in `Chart.yaml`.
- **Syntax:** `helm dependency update <chart-path>`
- **Example:** `helm dependency update ./charts/backend`
- **Production use:** Before install/upgrade if the chart declares sub-charts (Redis, Postgres).

### `helm dependency build`
- **Purpose:** Rebuild `charts/` from `Chart.lock` (reproducible, doesn't re-resolve versions).
- **Syntax:** `helm dependency build <chart-path>`
- **Example:** `helm dependency build ./charts/backend`
- **Production use:** Preferred over `dependency update` in CI/CD for reproducible builds.

### `helm show values <chart>`
- **Purpose:** Print a chart's default `values.yaml` without installing.
- **Syntax:** `helm show values <chart>`
- **Example:** `helm show values bitnami/redis`
- **Production use:** Discover what values a third-party chart exposes before writing an override file.
