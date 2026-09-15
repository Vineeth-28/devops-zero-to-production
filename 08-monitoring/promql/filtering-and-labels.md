# PromQL: Filtering and Labels

## What it is
Using label selectors to narrow which time series a query touches, and
`by`/`without` to control which labels survive an aggregation.

## Filtering examples
```promql
http_requests_total{method="GET"}
http_requests_total{method="GET", environment="production"}
http_requests_total{status=~"5.."}
up{job="node"} == 0
```

## Grouping in aggregations
```promql
sum by (method) (rate(http_requests_total[5m]))
sum without (instance) (rate(http_requests_total[5m]))
```
- `by (labels...)` — keep only the listed labels in the output
- `without (labels...)` — drop the listed labels, keep everything else

## Mental model
```
Server 1 (instance=a)
Server 2 (instance=b)
Server 3 (instance=c)
        |
    Aggregation (by method, dropping instance)
        |
    Combined result per method
```

## Production use
Use `by` when you know exactly which dimension you want left (e.g. per
route, per method); use `without` when you want "everything except this
noisy label" (e.g. drop `instance` to combine replicas).

## Common mistakes
- Forgetting that filtering (`{}`) happens on the raw series, while
  `by`/`without` happens on the aggregation result — mixing these up leads
  to "why didn't my filter work" confusion
- Using `by (instance)` when you actually want to combine across instances
  (should use `without (instance)` or omit `instance` from `by`)

## Troubleshooting
- Aggregated result has more series than expected -> you likely need
  `without` for a label instead of `by`, or you're missing a label in `by`
- Query returns nothing -> label value typo, or the label doesn't exist on
  that metric (check with the metric's raw output first)

## Interview-ready answer
"Label selectors filter which time series a query operates on, using
equality or regex matching. `by` and `without` control aggregation output
labels — `by` keeps only the named labels, `without` drops them and keeps
the rest. Getting these mixed up is a very common source of PromQL bugs."
