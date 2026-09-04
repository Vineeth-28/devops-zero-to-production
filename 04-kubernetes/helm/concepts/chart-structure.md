# Chart Structure

```
backend/
├── Chart.yaml          # Chart metadata
├── values.yaml          # Default configuration values
├── values-dev.yaml       # Dev environment overrides
├── values-staging.yaml    # Staging environment overrides
├── values-production.yaml # Production environment overrides
├── .helmignore          # Files to exclude when packaging
│
└── templates/
    ├── deployment.yaml    # Templated Deployment manifest
    ├── service.yaml       # Templated Service manifest
    ├── configmap.yaml     # Templated ConfigMap manifest
    ├── secret.yaml        # Templated Secret manifest
    ├── ingress.yaml        # Templated Ingress manifest
    ├── _helpers.tpl        # Reusable template snippets (labels, names)
    └── NOTES.txt           # Message shown after install/upgrade
```

## Purpose of Each File

### `Chart.yaml`
Metadata about the chart itself — not your app's runtime config.
Contains: chart name, chart version, app version, description, dependencies.

### `values.yaml`
Default configuration values, referenced inside templates as `.Values.xxx`.
This is the "dial panel" for the whole chart.

### `templates/`
Kubernetes YAML manifests, but with `{{ }}` placeholders instead of hardcoded values. Helm renders these into real YAML at install/upgrade time.

### `charts/` (not always present)
Sub-charts / dependencies (e.g. bundling a `redis` or `postgres` chart alongside your app).

### `_helpers.tpl`
Named templates (like functions) — used to avoid repeating the same label/selector blocks in every manifest.

### `NOTES.txt`
Plain text (with template support) printed to the terminal after `helm install` / `helm upgrade`. Commonly used to show the user how to access the app.

### `.helmignore`
Like `.gitignore` — tells Helm which files to skip when packaging the chart (e.g. `.git/`, `*.swp`, `README.md`).

## Key Principle

Nothing here is magic — `templates/` files are just Kubernetes YAML with Go template syntax mixed in. Helm's job is to **render** them into plain YAML and hand that to the Kubernetes API.
