# Labels

## What they are
Key/value metadata attached to a metric that together with the metric name
define a unique time series.

```
http_requests_total{method="GET", environment="production"}
```

## Why labels matter
```
Metric
  +
Labels
  |
  v
Specific Time Series
```
Without labels you'd only have one blob of data per metric name. Labels
let you slice `http_requests_total` by method, status code, environment,
route, etc. — each unique combination of label values is its own time
series.

## Label selectors / filtering
```promql
http_requests_total{method="GET"}
http_requests_total{method="GET", status="500"}
http_requests_total{status=~"5.."}      # regex match
http_requests_total{status!="200"}      # negative match
```

## Grouping
```promql
sum by (method) (rate(http_requests_total[5m]))
```
`by (method)` keeps only the `method` label in the aggregated output,
collapsing everything else.

## Cardinality (practical level)
Cardinality = number of unique time series a metric produces. Every unique
combination of label values is a new series stored in memory/disk.

- `http_requests_total{status, method}` with 5 statuses x 4 methods = 20 series. Fine.
- `http_requests_total{user_id, request_id}` with millions of users/requests
  = millions of series. Not fine — this can OOM Prometheus.

## Why uncontrolled/high-cardinality labels are expensive
Each new label-value combination is a new series Prometheus must track in
its head block (memory) and TSDB. Unbounded values (IDs, timestamps, raw
URLs with query strings) turn a handful of series into millions, degrading
query performance and blowing up memory.

## Common mistakes
- Putting user IDs, session IDs, or full URLs (with query params) in labels
- Using labels for things that change every request instead of aggregating
  them into buckets/histograms

## Troubleshooting
- Prometheus memory growing unbounded -> check
  `prometheus_tsdb_head_series` and find the metric with the most unique
  label combinations (`topk` on `count by (__name__)
  ({__name__=~".+"})` style queries, or use `promtool tsdb analyze`)

## Interview-ready answer
"Labels are key/value pairs attached to a metric that, combined with the
metric name, uniquely identify a time series. They enable filtering and
aggregation in PromQL, but every unique combination of label values creates
a new series — so high-cardinality labels like user IDs or request IDs can
cause a cardinality explosion that degrades Prometheus performance."
