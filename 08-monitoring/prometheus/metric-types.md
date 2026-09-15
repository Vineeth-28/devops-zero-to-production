# Prometheus Metric Types

## The four types

### Counter
Generally only increases; may reset to 0 on process restart.
```
http_requests_total
```
Use with `rate()`/`increase()`, never graph raw — a raw counter graph is
just an ever-climbing line that hides useful information.

### Gauge
Can go up or down.
```
memory usage
active connections
queue depth
```
Graph directly, or use with `avg`/`max`/`min` over time.

### Histogram
Samples observations into configurable buckets and exposes cumulative
counts per bucket, plus `_sum` and `_count`.
```
http_request_duration_seconds_bucket{le="0.1"}
http_request_duration_seconds_bucket{le="0.5"}
http_request_duration_seconds_bucket{le="+Inf"}
http_request_duration_seconds_sum
http_request_duration_seconds_count
```
Server-side aggregatable — you can compute quantiles across multiple
instances after the fact with `histogram_quantile()`.

### Summary
Also measures distributions, but calculates configured quantiles
client-side (e.g. p95, p99) at instrumentation time.
```
http_request_duration_seconds{quantile="0.95"}
http_request_duration_seconds_sum
http_request_duration_seconds_count
```
Not aggregatable across instances (you can't average two p95s and get a
meaningful p95).

## Mental model
| Type | Direction | Aggregatable across instances | Typical use |
|---|---|---|---|
| Counter | up only (resets on restart) | yes (sum) | request counts, error counts |
| Gauge | up/down | yes (sum/avg/max) | memory, connections, queue depth |
| Histogram | bucketed counts | yes | latency, size, aggregatable percentiles |
| Summary | pre-computed quantiles | no | latency where per-instance quantile is enough |

## Production use
Prefer **Histogram** over Summary for anything you'll aggregate across
multiple replicas/pods (which is almost always true in production) —
Summary quantiles can't be combined correctly across instances.

## Common mistakes
- Graphing a raw Counter and being confused why it only goes up
- Using a Summary for latency in a multi-replica service, then trying to
  average the p95s across replicas (mathematically invalid)
- Setting too few/too wide histogram buckets, making `histogram_quantile()`
  inaccurate

## Troubleshooting
- `histogram_quantile()` returns unexpected values -> check bucket
  boundaries actually bracket your real latency distribution
- Counter appears to "go negative" in a rate graph -> normal on restart;
  `rate()` handles counter resets automatically, but raw subtraction does not

## Interview-ready answer
"Prometheus has four metric types: Counter (monotonically increasing,
used with rate/increase), Gauge (goes up or down, like memory or active
connections), Histogram (bucketed observation counts that support
server-side aggregatable quantiles via histogram_quantile), and Summary
(client-side pre-computed quantiles that aren't aggregatable across
instances). In production with multiple replicas, Histogram is generally
preferred over Summary for latency because it can be correctly aggregated."
