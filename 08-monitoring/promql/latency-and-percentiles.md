# PromQL: Latency and Percentiles

## What it is
Measuring how long requests take, and summarizing that distribution with
percentiles (p50, p95, p99) rather than a misleading single average.

## Why averages hide slow requests
An average blends fast and slow requests together. 999 requests at 10ms
and 1 request at 10 seconds averages to ~20ms — looks fine, but one user
had a terrible experience. Percentiles tell you "what's the worst
experience most users have" without being diluted by the bulk of fast
requests.

## Definitions
- **p50 (median)** — half of requests are faster than this
- **p95** — 95% of requests are at or below this value; the slowest 5% are worse
- **p99** — 95%+4% ... i.e. only the worst 1% of requests are slower than this

Example: `p95 = 300ms` means approximately 95% of observed requests
completed in 300ms or less.

## Histograms + histogram_quantile()
Histograms bucket observations into `le` (less-than-or-equal) buckets with
cumulative counts, enabling server-side, aggregatable quantile computation:
```promql
histogram_quantile(0.95,
  sum by (le) (rate(http_request_duration_seconds_bucket[5m]))
)
```
Steps:
1. `rate(..._bucket[5m])` — per-second rate for each bucket
2. `sum by (le) (...)` — combine across instances, keeping bucket boundaries
3. `histogram_quantile(0.95, ...)` — interpolate the 95th percentile from bucket counts

## Practical patterns
```promql
# p50 / p95 / p99 latency
histogram_quantile(0.50, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))
histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))
histogram_quantile(0.99, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))

# per-route p95
histogram_quantile(0.95,
  sum by (le, route) (rate(http_request_duration_seconds_bucket[5m]))
)
```

## Common mistakes
- Alerting on average latency instead of p95/p99 — misses tail-latency
  problems affecting a meaningful chunk of users
- Too few/too wide histogram buckets making `histogram_quantile()`
  inaccurate — bucket boundaries should bracket your real latency
  distribution (e.g. buckets at 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10s)
- Trying to average multiple instances' Summary-based quantiles (not
  mathematically valid — this is exactly why Histogram is preferred)

## Interview-ready answer
"Percentiles like p95 or p99 describe the tail of a latency distribution
in a way averages can't — p95=300ms means 95% of requests finished in
300ms or less. Prometheus computes this from Histogram bucket data using
histogram_quantile(), which interpolates a quantile from cumulative bucket
counts aggregated with rate() and sum by (le). This is aggregatable across
instances, unlike Summary-type pre-computed quantiles."
