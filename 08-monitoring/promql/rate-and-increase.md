# PromQL: rate() and increase()

## What they are
Functions that compute how fast a Counter is growing over a range vector,
correctly handling counter resets (e.g. process restarts).

## Definitions
- `rate(metric[5m])` — per-second average rate of increase over the range,
  extrapolated. Best for graphing and alerting.
- `increase(metric[5m])` — total increase over the range (essentially
  `rate() * range_seconds`). Best for "how many X happened in this window".

## Example
```promql
rate(http_requests_total[5m])
increase(http_requests_total[1h])
```

## Why counters need rate()
A Counter only increases (and resets to 0 on restart). Graphing it raw
gives you an ever-climbing sawtooth that tells you almost nothing.
`rate()` converts that into a meaningful per-second trend, and
automatically compensates for resets so a restart doesn't look like a
massive negative spike.

## Mental model
```
rate()     -> per-second average increase over a range   (velocity)
increase() -> total increase over a range                 (distance)
```

## Practical examples
```promql
# requests per second, averaged over last 5 minutes
rate(http_requests_total[5m])

# total errors in the last hour
increase(http_requests_total{status=~"5.."}[1h])

# CPU seconds used per second (i.e. CPU usage ratio)
rate(process_cpu_seconds_total[5m])
```

## Production use
- Use a range at least 4x your scrape interval (common guidance: >= 4x
  `scrape_interval`) so `rate()` has enough samples to compute a stable value
- Prefer `rate()` in alert rules over `increase()` for consistency with
  dashboards, unless you specifically want a total count

## Common mistakes
- Using a range window shorter than a few scrape intervals (noisy/unstable
  results, sometimes `NaN` at graph edges)
- Applying `rate()` to a Gauge (nonsensical — Gauges aren't monotonic)
- Confusing `irate()` (instantaneous rate from last two points, good for
  volatile fast-moving graphs) with `rate()` (smoothed average, good for
  alerting) — know both exist

## Troubleshooting
- `rate()` output looks like a flat line at 0 -> check the range window
  isn't smaller than the scrape interval, and that the counter is actually
  incrementing
- Sudden negative-looking dip that self-corrects -> normal counter reset
  handling; if it doesn't self-correct, investigate actual data issues

## Interview-ready answer
"rate() computes the per-second average rate of increase of a Counter over
a range window, automatically handling counter resets — it's the standard
way to graph and alert on Counters. increase() gives the total increase
over the window instead of a per-second rate. Both require a range vector
input, e.g. metric[5m]."
