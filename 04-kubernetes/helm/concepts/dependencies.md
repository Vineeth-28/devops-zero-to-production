# Chart Dependencies

A chart can depend on other charts (sub-charts):

```
backend Chart
    ├── backend        (your app)
    ├── redis           (dependency)
    └── postgres         (dependency)
```

## Declaring Dependencies

In `Chart.yaml`:

```yaml
dependencies:
  - name: redis
    version: "18.x.x"
    repository: "https://charts.bitnami.com/bitnami"
  - name: postgresql
    version: "15.x.x"
    repository: "https://charts.bitnami.com/bitnami"
```

## Commands

```bash
helm dependency update
```
Downloads the dependency charts into `charts/` based on `Chart.yaml`.

```bash
helm dependency build
```
Rebuilds `charts/` from the lock file (`Chart.lock`) — more reproducible than `update` for CI/CD.

## Key Takeaway

Dependencies let you compose infrastructure (app + database + cache) as one installable unit, without hand-writing Redis/Postgres manifests yourself. Keep this in mind conceptually — most teams don't hand-roll stateful dependencies in production charts; they use well-maintained public charts (e.g. Bitnami) for this.
