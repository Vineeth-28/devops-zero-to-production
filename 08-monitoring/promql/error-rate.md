# PromQL: Error Rate

## What it is
The percentage of requests that resulted in an error over a time window —
one of the most important application-health signals (part of the classic
"rate, errors, duration" / RED method).

## Mental model
```
5xx requests
    |
  rate()
    |
Total requests
    |
 percentage
    |
Error rate
```

## Safe pattern
```promql
sum(rate(http_requests_total{status=~"5.."}[5m]))
  /
sum(rate(http_requests_total[5m]))
```
This gives a fraction (0.0–1.0); multiply by 100 for a percentage.

## Per-service breakdown
```promql
sum by (service) (rate(http_requests_total{status=~"5.."}[5m]))
  /
sum by (service) (rate(http_requests_total[5m]))
```

## Why error rate is often more useful than CPU
CPU usage can be high while the service is perfectly healthy (batch job,
traffic spike handled fine), or low while the service is failing every
request instantly. Error rate ties directly to user-facing impact — it's a
symptom-level signal, whereas CPU is a cause-level signal. Alert on
symptoms (error rate, latency) first; use cause-level metrics (CPU,
memory) for diagnosis after the alert fires.

## Common mistakes
- Dividing raw counters instead of rate()'d counters — using raw counts
  ratios can be skewed by uneven scrape timing
- Not guarding against divide-by-zero when total request rate is 0 (query
  returns no data momentarily during zero traffic — acceptable, but know
  it can happen)

## Troubleshooting
- Error rate query returns nothing -> check the `status` label actually
  exists and uses the values you expect (string "500" vs numeric)
- Error rate spikes but nothing visibly wrong -> check for one noisy
  instance skewing the aggregate; break down `by (instance)`

## Interview-ready answer
"Error rate is computed by dividing the rate of error responses (e.g.
status=~"5..") by the rate of total responses, both computed with rate()
over the same window. It's a symptom-level signal directly tied to user
impact, which is usually why it's alerted on before cause-level metrics
like CPU or memory."
