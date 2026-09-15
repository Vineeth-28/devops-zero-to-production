# Prometheus Basics

## What it is
An open-source systems monitoring and alerting toolkit: a time-series
database + a pull-based scraper + a query language (PromQL) + a rules
engine for alerting, all in one binary.

## Why it is used
- Simple pull model — no agents pushing to a central collector you must scale
- Powerful multi-dimensional data model (metric name + labels)
- PromQL lets you slice, aggregate, and derive rates on the fly
- De facto standard for Kubernetes-native monitoring (kube-state-metrics,
  cAdvisor, Operator pattern all assume Prometheus)
- Huge exporter ecosystem (Node Exporter, Postgres Exporter, Blackbox Exporter...)

## Mental model
```
Targets -> /metrics -> Prometheus -> Time-Series Data -> PromQL -> Grafana / Alerts
```
Prometheus **pulls** from targets on an interval; it does not wait for
targets to push data to it.

## Example
A target exposes:
```
http_requests_total{method="GET",status="200"} 15234
```
Prometheus scrapes this every `scrape_interval` (e.g. 15s) and stores each
sample with a timestamp, building a time series.

## Production use
- Run as a StatefulSet in Kubernetes (or via the Prometheus Operator) with
  persistent storage for the TSDB
- Federate or use remote_write to a long-term store (Thanos, Cortex, Mimir)
  when you need retention beyond local disk limits
- Scrape configs typically driven by service discovery (Kubernetes SD, EC2
  SD) rather than static lists in production

## Common mistakes
- Treating Prometheus as a long-term historical database (local TSDB
  retention is usually 15d by default — not built for years of data)
- Instrumenting with unbounded label values (user IDs, request IDs) causing
  cardinality explosions
- Assuming push-based tools (StatsD-style) work the same way — they don't

## Troubleshooting
- No data in Grafana -> check `/api/v1/targets` first, not the dashboard
- Prometheus using too much memory/disk -> check active series count and
  cardinality (`prometheus_tsdb_head_series`)

## Interview-ready answer
"Prometheus is a pull-based, open-source monitoring system with its own
time-series database and query language, PromQL. It scrapes `/metrics`
endpoints on a schedule, stores samples as multi-dimensional time series
(metric name + labels), and supports alerting through rule evaluation and
Alertmanager. It's the standard for Kubernetes-native monitoring because of
its label model and service-discovery integrations."
