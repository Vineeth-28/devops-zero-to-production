# Prometheus Architecture

## What it is
The set of components that make up a Prometheus deployment: the server
(scraper + TSDB + query engine), exporters, Alertmanager, and optional
service discovery / remote storage integrations.

## Why it matters
Interview questions frequently ask you to "draw" the architecture — know
what talks to what, and who pulls vs who pushes.

## Mental model
```
        +----------------+
        |  Service        |
        |  Discovery      |  (K8s API, EC2 API, static config)
        +--------+--------+
                 |
                 v
        +----------------+        scrape (pull)       +--------------+
        |  Prometheus     | -------------------------> |  Targets      |
        |  Server         |                             | (/metrics)   |
        |  - Retrieval    |                             +--------------+
        |  - TSDB (local) |
        |  - PromQL engine|
        |  - Rule engine  |
        +----+--------+---+
             |        |
             |        | alerts (push)
             v        v
        +--------+  +---------------+
        | Grafana |  | Alertmanager  |
        | (query) |  | (route/notify)|
        +--------+  +---------------+
```

## Components
- **Retrieval**: the scrape loop, pulls `/metrics` from targets
- **TSDB**: local on-disk time-series storage (chunks + WAL)
- **HTTP server**: serves the API Grafana/PromQL clients query
- **Rule evaluator**: runs recording rules and alerting rules on a schedule
- **Alertmanager**: separate process; receives firing alerts and handles
  grouping, routing, silencing, notification

## Production use
- Prometheus itself is stateful and typically not clustered for HA out of
  the box — common pattern is two independent Prometheus replicas scraping
  the same targets, deduplicated downstream (Thanos/Cortex) or accepted as
  redundant alerting paths
- Remote_write to long-term storage decouples retention from local disk

## Common mistakes
- Assuming Prometheus servers replicate/share state with each other natively
- Forgetting Alertmanager is a separate binary/service, not built into the
  Prometheus server process

## Troubleshooting
- Alerts defined but never notifying -> check Prometheus is actually
  pointed at Alertmanager (`alerting:` block in prometheus.yml) and that
  Alertmanager's own config routes them somewhere

## Interview-ready answer
"Prometheus architecture separates concerns: the Prometheus server handles
scraping, storage, and querying; Alertmanager is a separate component that
receives firing alerts from Prometheus and handles grouping, routing, and
notifications; Grafana is a separate visualization layer that queries
Prometheus over its HTTP API. Service discovery feeds the scrape target
list dynamically instead of a static file."
