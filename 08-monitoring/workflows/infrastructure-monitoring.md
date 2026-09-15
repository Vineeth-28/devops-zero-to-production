# Monitoring Across the Infrastructure Layer

## What it covers
How monitoring responsibility shifts across EC2, Docker, Kubernetes,
applications, APIs, and databases.

## EC2 / Linux hosts
- Node Exporter for host-level metrics (CPU, memory, disk, network)
- Focus: is the underlying machine healthy?

## Docker
- Container-level resource usage (cAdvisor, or Docker's own stats API)
- Focus: is this container using expected CPU/memory, is it restarting?

## Kubernetes
- **kube-state-metrics** — cluster object state (deployments, pods,
  replicasets, node conditions) — "what does the cluster think is true"
- **cAdvisor** (built into kubelet) — per-container resource usage
- **Node Exporter** (as a DaemonSet) — per-node host metrics
- **Prometheus Operator** (common pattern) — `ServiceMonitor`/`PodMonitor`
  CRDs let Prometheus auto-discover new scrape targets from Kubernetes
  labels instead of static config
- Focus: cluster health, scheduling issues, resource pressure, and rollout status

## Applications
- Custom instrumentation exposing business/HTTP metrics (`http_requests_total`,
  latency histograms, queue depth, custom domain metrics)
- Focus: is the application itself behaving correctly for users?

## APIs
- Same as applications, typically layered with request rate, error rate,
  and latency (RED method) per route/endpoint
- Focus: per-endpoint health, not just service-wide aggregate

## Databases (high level)
- Exporters exist per database (postgres_exporter, mysqld_exporter,
  redis_exporter) exposing connection counts, query latency, replication
  lag, cache hit ratio
- Focus: is the data layer a bottleneck or a risk (replication lag,
  connection exhaustion)?

## Mental model
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

## Common mistakes
- Only monitoring hosts (Node Exporter) and assuming that covers
  containers/applications too — it doesn't
- No database-layer monitoring until a replication-lag incident forces it

## Interview-ready answer
"Monitoring layers stack: Node Exporter covers hosts, cAdvisor and
kube-state-metrics cover containers and cluster state in Kubernetes,
application instrumentation covers business/HTTP metrics, and
database-specific exporters cover the data layer. Each layer answers a
different question, and a mature setup has visibility at every layer, not
just infrastructure."
