# Scraping (Pull Model)

## What it is
The mechanism by which Prometheus retrieves metrics: it makes an HTTP GET
request to a target's `/metrics` endpoint on a fixed interval.

## Why the pull model
- Prometheus controls the cadence — a misbehaving target can't flood it
- Easy to tell a target is down: the scrape itself fails
- No need for targets to know where Prometheus lives, or to manage a
  delivery/retry queue on the client side
- Centralized control of scrape frequency and timeouts

## Mental model
```
Prometheus
    | HTTP GET request
    v
  Target
    |
 /metrics
    |
  Metrics (plaintext exposition format)
    |
    v
Prometheus (parses + stores)
```

## Key config concepts
- **scrape_target**: an endpoint Prometheus scrapes (host:port + path)
- **/metrics**: the conventional path exposing metrics in Prometheus
  exposition format (plain text, one sample per line)
- **scrape_interval**: how often Prometheus scrapes this job (default from
  `global`, overridable per job)
- **scrape_configs / job_name**: logical group of targets scraped the same way
- **static_configs**: the simplest target list — a fixed array of `host:port`
- **target health**: each scrape sets the synthetic `up` metric to 1 or 0

## Safe example
```yaml
scrape_configs:
  - job_name: "node"
    scrape_interval: 15s
    static_configs:
      - targets: ["10.0.1.10:9100", "10.0.1.11:9100"]
```

## Service discovery (basic concept)
Instead of hardcoding targets, Prometheus can query an external system
(Kubernetes API, EC2 API, Consul) to build the target list dynamically.
Example: `kubernetes_sd_configs` discovers pods/services/endpoints tagged
with the right annotations, so new pods are scraped automatically without
touching `prometheus.yml`.

## Production use
- Always use SD in Kubernetes — static target lists don't survive pod churn
- Set sane `scrape_timeout` (< `scrape_interval`) so slow targets don't
  back up the scrape queue

## Common mistakes
- Confusing "scrape interval" with "how fresh my dashboard is" — a 15s
  scrape interval means data is at most ~15s stale, not real-time
- Not exposing `/metrics` on a path Prometheus is configured to hit
  (mismatched `metrics_path`)

## Troubleshooting
- Target shows `up == 0` -> check network reachability, correct port, and
  that the app actually exposes `/metrics`
- Scrapes timing out -> check `scrape_timeout` vs how long the target takes
  to render metrics (expensive Summary/Histogram calculations can be slow)

## Interview-ready answer
"Prometheus uses a pull model: it scrapes each target's /metrics HTTP
endpoint at a configured interval and parses the exposition-format
response into time series. This gives Prometheus centralized control over
scrape frequency and makes target health trivial to detect via the `up`
metric — if the scrape fails, the target is down."
