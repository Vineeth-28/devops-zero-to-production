# Grafana Dashboards

## What it is
A collection of panels (graphs, tables, stat displays) arranged on a grid,
usually built around a specific service or concern (e.g. "API Overview",
"Node Health").

## Key concepts
- **Panel** — a single visualization tied to one or more queries
- **Row** — a collapsible group of panels
- **Variable** — a templated value (e.g. `$environment`, `$instance`) that
  lets one dashboard serve many targets by selection instead of duplicating
  dashboards
- **Time range** — the window the dashboard queries (top-right picker);
  affects every panel unless overridden per-panel

## Mental model
```
Prometheus
    |
  PromQL
    |
 Grafana
    |
  Panels
    |
 Dashboard
```

## Production use
- Store dashboard JSON in version control, provisioned automatically on
  Grafana startup — not edited ad hoc in the UI in prod
- Use variables (`$job`, `$instance`, `$namespace`) so one dashboard
  covers every service/environment instead of copy-pasting dashboards
- Design dashboards top-down: high-level health/SLO panel at top, drill-down
  detail panels below

## Common mistakes
- One dashboard per environment/instance instead of using variables —
  maintenance nightmare
- Overloading a single dashboard with everything, making it useless for
  fast incident triage

## Troubleshooting
- Dashboard variable shows no options -> check the variable's query
  (usually a `label_values()` query) actually matches existing series
- Panels blank after a Prometheus upgrade/relabel -> check underlying
  metric/label names didn't change

## Interview-ready answer
"A Grafana dashboard is a set of panels built from datasource queries,
typically parameterized with variables so one dashboard can serve multiple
services or environments. In production, dashboards are version-controlled
and provisioned as code rather than hand-edited."
