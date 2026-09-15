# PromQL Aggregation

## What it is
Operators that combine multiple time series into fewer (or one) result
series: `sum`, `avg`, `min`, `max`, `count`, `topk`, `bottomk`, etc.

## Core operators
```promql
sum(http_requests_total)
avg(node_memory_MemAvailable_bytes)
min(up)
max(process_resident_memory_bytes)
count(up == 1)
```

## Grouping
```promql
sum by (method) (
  rate(http_requests_total[5m])
)

sum without (instance) (
  rate(http_requests_total[5m])
)
```

## Mental model
```
Server 1
Server 2
Server 3
    |
Aggregation
    |
Combined result
```
Aggregation collapses the `instance` (and any other unlisted) label,
combining series that share the remaining labels.

## Practical examples
```promql
# total request rate across all instances, per method
sum by (method) (rate(http_requests_total[5m]))

# how many targets are currently up, per job
count by (job) (up == 1)

# top 5 instances by memory usage
topk(5, process_resident_memory_bytes)
```

## Production use
- `sum by (...)` is the standard pattern for per-service dashboards
  (combine replicas, keep the dimension you care about)
- `count(up == 0)` is a quick way to alert on "N targets down" cluster-wide

## Common mistakes
- Aggregating before filtering (compute cost + confusing intermediate
  results) — filter with label selectors first, then aggregate
- Forgetting `by`/`without` entirely, collapsing everything into a single
  series when you wanted it broken out by service

## Troubleshooting
- Aggregated number looks too high/low -> check whether you're
  double-counting because of an extra label still present in the group
  (e.g. a `pod` label with rolling replicas)

## Interview-ready answer
"Aggregation operators like sum, avg, count, topk combine multiple time
series into fewer results. Used with `by (labels)` to keep specific
dimensions or `without (labels)` to collapse specific ones — this is how
you go from per-replica raw metrics to per-service dashboard numbers."
