# Prometheus Configuration (prometheus.yml)

## What it is
The single YAML file that defines global settings, scrape jobs, rule
files, and the Alertmanager connection for a Prometheus server.

## Structure
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "rules/*.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets: ["alertmanager:9093"]

scrape_configs:
  - job_name: "node"
    static_configs:
      - targets: ["node-exporter:9100"]

  - job_name: "app"
    metrics_path: /metrics
    static_configs:
      - targets: ["app:8080"]
```

## Key fields
- `global.scrape_interval` — default interval for all jobs unless overridden per-job
- `global.evaluation_interval` — how often rule files are evaluated
- `rule_files` — glob paths to recording/alerting rule files
- `scrape_configs` — list of jobs, each with `job_name`, `metrics_path`,
  and a target-discovery mechanism (`static_configs`, `kubernetes_sd_configs`, etc.)

## Production use
- Use service discovery (`kubernetes_sd_configs`, `ec2_sd_configs`) instead
  of static targets so scrape targets update automatically as infra changes
- Split rule files by concern (`rules/infra.yml`, `rules/app.yml`)
- Keep `scrape_interval` consistent across environments so rate() windows
  behave predictably

## Common mistakes
- Editing `prometheus.yml` without validating it first — a bad reload can
  silently stop scraping
- Setting `scrape_interval` too aggressively (sub-5s) on a large target set,
  overloading both Prometheus and targets
- Forgetting `rule_files` glob doesn't reload automatically without a
  config reload/HUP

## Troubleshooting
- Config won't load -> `promtool check config prometheus.yml` first, always
- Changed config but nothing changed -> did you reload? (`SIGHUP`, `curl -X
  POST http://localhost:9090/-/reload` if `--web.enable-lifecycle` is set,
  or restart the pod)

## Interview-ready answer
"prometheus.yml has three main sections: global settings like scrape and
evaluation intervals, rule_files pointing to recording/alerting rules, and
scrape_configs defining what to scrape and how to discover targets. In
production, targets come from service discovery rather than static lists,
and config changes should always be validated with promtool before a
reload."
