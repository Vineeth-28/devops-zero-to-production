# Targets and Jobs

## Definitions
**Target** — a single scrapable endpoint (one instance, e.g. `10.0.1.10:9100`).

**Job** — a logical grouping of targets that are scraped the same way and
represent the same kind of thing (e.g. job `node` groups every Node
Exporter instance).

## Mental model
```
job: "node"
  target: 10.0.1.10:9100  (instance="10.0.1.10:9100")
  target: 10.0.1.11:9100  (instance="10.0.1.11:9100")
  target: 10.0.1.12:9100  (instance="10.0.1.12:9100")
```
Every scraped series automatically gets two labels attached: `job` (the
job name) and `instance` (the target address). This is how you later
filter/group PromQL queries by job or instance.

## Example
```yaml
scrape_configs:
  - job_name: "node"
    static_configs:
      - targets: ["10.0.1.10:9100", "10.0.1.11:9100"]

  - job_name: "api"
    static_configs:
      - targets: ["10.0.2.10:8080"]
```
Resulting series carry labels like:
```
up{job="node", instance="10.0.1.10:9100"} 1
up{job="api",  instance="10.0.2.10:8080"} 1
```

## Production use
- Job names should map to a meaningful service/tier ("node", "api",
  "postgres-exporter"), not implementation detail
- In Kubernetes, job names are usually driven by `kubernetes_sd_configs`
  relabeling rather than typed by hand

## Common mistakes
- Putting unrelated services in the same job (loses the clean `job=`
  filter for dashboards/alerts)
- Assuming `instance` is stable across restarts in dynamic environments
  (pod IPs change — this affects long-running queries across pod restarts)

## Troubleshooting
- `up{job="x"} == 0` for one instance -> that specific target is
  unreachable; check its container/host and network path
- Query returns nothing for a job you expect -> check the job name spelling
  matches exactly (`job="node"` vs `job="Node"`)

## Interview-ready answer
"A target is a single endpoint Prometheus scrapes; a job is a named group
of targets scraped the same way, representing the same kind of service.
Prometheus automatically labels every scraped series with `job` and
`instance`, which is how PromQL queries filter or aggregate by service or
by specific host."
