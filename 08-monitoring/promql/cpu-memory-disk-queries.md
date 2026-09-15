# Production PromQL: CPU / Memory / Disk / Network / HTTP

## What it is
A working set of query patterns for the signals you'll actually be asked
to graph or alert on. Node Exporter metric names shown are the common
defaults — verify against your actual `/metrics` output since exporter
versions can differ.

## Mental model
```
Raw metric -> PromQL -> Operational signal
```

## CPU usage (%)
```promql
100 - (avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100)
```
Idea: idle time rate subtracted from 100% gives busy percentage.

## Memory usage (%)
```promql
100 * (1 - (
  node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes
))
```

## Disk usage (%) per filesystem
```promql
100 * (1 - (
  node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"}
  /
  node_filesystem_size_bytes{fstype!~"tmpfs|overlay"}
))
```

## Filesystem near-full check
```promql
node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"}
  / node_filesystem_size_bytes{fstype!~"tmpfs|overlay"} < 0.10
```

## Network traffic (bytes/sec)
```promql
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])
```

## HTTP request rate
```promql
sum by (method) (rate(http_requests_total[5m]))
```

## HTTP error rate (5xx as % of total)
```promql
sum(rate(http_requests_total{status=~"5.."}[5m]))
  /
sum(rate(http_requests_total[5m]))
```

## Request latency (p95 example)
```promql
histogram_quantile(0.95,
  sum by (le) (rate(http_request_duration_seconds_bucket[5m]))
)
```

## Active connections (Gauge — graph directly)
```promql
app_active_connections
```

## Instance availability
```promql
up{job="node"}          # 1 = up, 0 = down
avg_over_time(up{job="node"}[24h]) * 100   # rough uptime % over 24h
```

## Common mistakes
- Copy-pasting exact metric names without checking your exporter version —
  Node Exporter and application-instrumentation metric names can differ by
  setup (library, version, custom naming)
- Forgetting `fstype!~"tmpfs|overlay"` and including virtual filesystems in
  disk-usage alerts, causing false positives

## Interview-ready answer
"Most production PromQL queries follow the same pattern: take a Counter,
apply rate() over a reasonable window, then aggregate with sum/avg by the
dimension you care about. For percentages like CPU or disk usage, you're
usually computing 100 minus an idle/available ratio. For latency, you use
histogram_quantile() over rate()'d bucket counters."
