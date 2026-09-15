# Production Monitoring Architecture

## What it is
A realistic end-to-end picture of how monitoring is deployed and operated
in a production environment, tying together collection, visualization,
and alerting.

## Full architecture
```
                Production Application
                        |
                   Application
                    Metrics
                        |
                    Prometheus
                        |
                     PromQL
                        |
                    Grafana
                        |
                   Dashboards


Infrastructure:

Linux / EC2
     |
Node Exporter
     |
Prometheus


Alerts:

Prometheus
    |
Alert Rules
    |
Alertmanager
    |
Notification
```

## Production best practices
- **Monitor useful signals, not everything blindly** — instrument what
  you'll actually look at or alert on; excessive metrics increase
  cardinality and noise without adding value
- **Avoid excessive label cardinality** — no unbounded values (user IDs,
  raw URLs, request IDs) as label values
- **Build actionable alerts** — every alert should map to a clear next step
- **Avoid alert fatigue** — group, use `for:` durations, use inhibition
- **Use meaningful alert severity** — consistent `warning`/`critical`
  labels drive routing
- **Add useful annotations** — summary, description, runbook link
- **Use recording rules where appropriate** — precompute expensive/frequent
  queries (e.g. the error-rate query used on every dashboard load) into a
  new metric evaluated once on schedule, rather than recomputing it live
  every time
- **Use dashboards for diagnosis, not just decoration** — built around the
  questions an on-call engineer actually asks
- **Monitor both infrastructure and application health** — hosts,
  containers, and app-level signals all matter
- **Track request rate, errors, latency, and saturation** — the RED +
  saturation model covers most services well
- **Protect monitoring systems** — Prometheus/Grafana/Alertmanager
  themselves need appropriate access control and resource limits
- **Secure endpoints** — `/metrics` endpoints shouldn't be publicly exposed
  without auth if they could leak sensitive operational detail
- **Avoid exposing sensitive metrics publicly** — no secrets or PII in
  metric labels/values, ever
- **Plan retention/storage appropriately** — local TSDB retention vs
  long-term storage (Thanos/Cortex/Mimir) based on actual compliance/
  analysis needs
- **Document runbooks for important alerts** — link them from alert
  annotations so responders have immediate next steps

## Interview-ready answer
"A production monitoring architecture separates collection (Prometheus +
exporters), visualization (Grafana), and alerting (Alertmanager), with
infrastructure metrics from Node Exporter and application metrics from
custom instrumentation feeding the same Prometheus instance. Good
production practice focuses on actionable, low-cardinality, well-routed
alerts and dashboards designed for fast diagnosis rather than raw metric
coverage for its own sake."
