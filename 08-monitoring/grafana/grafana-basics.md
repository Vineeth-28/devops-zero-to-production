# Grafana Basics

## What it is
An open-source visualization and dashboarding platform that queries
datasources (Prometheus, Loki, databases, etc.) and renders the results as
panels/dashboards.

## Why Grafana
- Prometheus's own UI is functional but not built for polished dashboards
- Supports multiple datasource types in one place (metrics + logs + traces)
- Alerting UI, templating/variables, and sharing/permissions built in

## Grafana vs Prometheus
| | Prometheus | Grafana |
|---|---|---|
| Role | Collects, stores, queries metrics | Visualizes query results |
| Query language | PromQL | Queries via datasource (PromQL for Prometheus datasource) |
| Alerting | Rule evaluation + Alertmanager | Can also alert (Grafana-managed alerts) but often just visualizes Prometheus/Alertmanager state |
| Storage | Its own TSDB | None (stateless, queries live) |

## Mental model
```
Prometheus -> PromQL -> Grafana -> Panels -> Dashboard
```
Grafana does not store metrics itself — every panel queries the
datasource live (or on a refresh interval).

## Production use
- Grafana is typically stateless and horizontally scalable; dashboards and
  datasource configs are provisioned as code (JSON/YAML) rather than
  clicked together by hand
- Use folders + permissions to separate team/service dashboards

## Common mistakes
- Treating Grafana as a data store — if Prometheus loses its data, Grafana
  has nothing to show regardless of dashboard config
- Manually clicking dashboards together in production without exporting
  them to version control (provisioning-as-code)

## Interview-ready answer
"Grafana is a visualization layer that queries datasources like Prometheus
and renders panels/dashboards. It doesn't store data itself — Prometheus
handles collection, storage, and querying; Grafana just presents the
results. In production, dashboards and datasources are usually provisioned
as code rather than configured by hand."
