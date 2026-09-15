# PromQL Basics

## What it is
Prometheus's own functional query language for selecting and aggregating
time-series data.

## Core concepts

**Instant vector** — a set of time series, each with a single sample at one
timestamp.
```promql
http_requests_total
```

**Range vector** — a set of time series, each with a range of samples over
a time window.
```promql
http_requests_total[5m]
```
Range vectors aren't graphed directly — they're input to functions like
`rate()` or `increase()`.

## Metric + label selectors
```promql
http_requests_total                              # all series for this metric
http_requests_total{method="GET"}                 # filtered by one label
http_requests_total{method="GET", status="200"}   # filtered by multiple labels
```

## Filtering operators
```promql
{status="200"}    # equals
{status!="200"}    # not equals
{status=~"5.."}    # regex match
{status!~"4.."}    # negative regex match
```

## Mental model
```
Raw metric -> label selector -> instant/range vector -> function/aggregation -> result
```

## Production use
Start every PromQL query by narrowing with label selectors before applying
functions — filtering early is both clearer and cheaper.

## Common mistakes
- Graphing a bare Counter with no `rate()` — produces a meaningless
  ever-climbing line
- Confusing instant vector syntax (`metric{}`) with range vector syntax
  (`metric{}[5m]`) — a range vector alone is not directly graphable

## Interview-ready answer
"PromQL queries operate on instant vectors (one sample per series at a
point in time) or range vectors (a window of samples per series, used as
input to functions like rate()). Label selectors filter which series a
query touches using equality or regex matches."
