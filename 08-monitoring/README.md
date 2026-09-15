# 08 — Monitoring (Prometheus, PromQL, Grafana, Alerting)

Production-revision handbook. Assumes you already know the core concepts —
this is for retention, production usage, troubleshooting, and interview
readiness, not a first introduction.

## 1. What is Monitoring?
The practice of continuously collecting, storing, and analyzing signals
(metrics, logs, traces) from systems to understand health, performance,
and behavior over time.

## 2. Why Monitoring?
- Detect problems before/as they happen
- Provide data for debugging ("what changed?")
- Support capacity planning
- Prove SLAs/SLOs
- Reduce MTTR (mean time to recovery)

## 3. Prometheus
Pull-based metrics collection and storage system built around a
time-series database and its own query language (PromQL).
See `prometheus/prometheus-basics.md`.

## 4. Prometheus Architecture
See `prometheus/prometheus-architecture.md`.

## 5. Scraping
See `prometheus/scraping.md`.

## 6. Targets
See `prometheus/targets-and-jobs.md`.

## 7. Jobs
See `prometheus/targets-and-jobs.md`.

## 8. Labels
See `prometheus/labels.md`.

## 9. Metric Types
See `prometheus/metric-types.md`.

## 10. Node Exporter
See `prometheus/node-exporter.md`.

## 11. PromQL
See `promql/` (basics, filtering, rate/increase, aggregation, production
queries, error rate, latency/percentiles).

## 12. Grafana
See `grafana/` (basics, datasource, dashboards, panels, best practices).

## 13. Alerting
See `alerting/prometheus-alerting.md` and `alerting/alert-rules.md`.

## 14. Alertmanager
See `alerting/alertmanager.md`.

## 15. Troubleshooting
See `troubleshooting/monitoring-troubleshooting.md` — 17 scenario decision
trees (target down, no data, alert not firing, Grafana blank panel, etc.).

## 16. Production Architecture
See `workflows/production-monitoring.md` and `workflows/infrastructure-monitoring.md`.

## 17. DevOps Stack Integration
See `workflows/prometheus-grafana.md` for the full pipeline diagram tying
Monitoring into CI/CD, Terraform, Ansible, Docker, Kubernetes, and Helm.

## 18. Important Commands

| Command | Checks |
|---|---|
| `prometheus --version` | Installed Prometheus version |
| `promtool check config prometheus.yml` | Config file syntax and semantics |
| `promtool check rules rules.yml` | Alert/recording rule file syntax |
| `curl http://localhost:9090/-/healthy` | Prometheus server health endpoint |
| `curl http://localhost:9090/-/ready` | Prometheus ready to serve traffic (TSDB loaded) |
| `curl http://localhost:9100/metrics` | Node Exporter is exposing metrics |
| `curl http://localhost:9090/api/v1/targets` | Current scrape target status (up/down) |

Exact endpoints/ports depend on your deployment (defaults shown: Prometheus
`9090`, Node Exporter `9100`, Alertmanager `9093`).

## 19. Interview Checklist
- [ ] Explain pull vs push model and why Prometheus chose pull
- [ ] Explain target, job, label, and how they compose a time series
- [ ] Explain all 4 metric types with a real example of each
- [ ] Explain `rate()` vs `increase()` and when each resets
- [ ] Write a PromQL query for error rate and for p95 latency
- [ ] Explain Prometheus vs Grafana vs Alertmanager responsibilities
- [ ] Explain `for:` duration in alert rules and why it matters
- [ ] Walk through troubleshooting a DOWN target end to end
- [ ] Describe a production monitoring architecture from app to notification
- [ ] Explain how Kubernetes monitoring differs (ServiceMonitors, cAdvisor, kube-state-metrics)

## 20. Revision Checklist
- [ ] `prometheus/` — all 9 files reviewed
- [ ] `promql/` — can write each query type from memory
- [ ] `grafana/` — can build a dashboard from a Prometheus datasource unaided
- [ ] `alerting/` — can write an alert rule + route it through Alertmanager
- [ ] `troubleshooting/` — can diagnose each of the 17 scenarios without notes
- [ ] `interview/` — scored well on the final quiz

```
                 PROMETHEUS
                      |
                   SCRAPE
                      |
          +-----------+-----------+
          |           |           |
       Node Exp     App         Exporter
          |           |           |
       /metrics    /metrics    /metrics
          +-----------+-----------+
                      |
                 Time Series
                      |
                    PromQL
                  /       \
             Grafana      Alerts
                |            |
            Dashboard   Alertmanager
                             |
                        Notification
```
