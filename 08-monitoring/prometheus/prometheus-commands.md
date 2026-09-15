# Prometheus Commands & Endpoints

## What it covers
Practical CLI/HTTP checks used day-to-day and in interviews.

## Commands

```bash
# Check installed version
prometheus --version

# Validate the main config file BEFORE reloading/restarting
promtool check config prometheus.yml

# Validate alerting/recording rule files
promtool check rules rules.yml

# Server health — is the process alive?
curl http://localhost:9090/-/healthy

# Server readiness — has the TSDB finished loading and is it ready to serve?
curl http://localhost:9090/-/ready

# Trigger a config reload without restarting (requires --web.enable-lifecycle)
curl -X POST http://localhost:9090/-/reload

# See current scrape target status (up/down, last scrape, error)
curl http://localhost:9090/api/v1/targets

# Confirm an exporter is exposing metrics at all
curl http://localhost:9100/metrics
```

## What each checks
| Command | Purpose |
|---|---|
| `promtool check config` | Catches YAML/semantic errors before they break a running server |
| `promtool check rules` | Catches invalid PromQL or rule-file syntax before evaluation fails silently |
| `/-/healthy` | Process liveness |
| `/-/ready` | TSDB/storage ready to accept queries |
| `/-/reload` | Applies config changes without a restart (keeps TSDB warm) |
| `/api/v1/targets` | First place to look when "there's no data" |
| exporter `/metrics` | Confirms the exporter itself works, independent of Prometheus |

## Production use
Always run `promtool check config` and `promtool check rules` in CI before
deploying a config change — a broken config either fails to reload (safe,
old config keeps running) or, worse, isn't caught until an alert silently
stops firing.

## Common mistakes
- Editing rule files in production without validating them first
- Assuming `/-/reload` works without `--web.enable-lifecycle` enabled on
  the Prometheus process (it 403s by default)

## Interview-ready answer
"The two most important operational habits are validating with
`promtool check config` / `check rules` before any deploy, and checking
`/api/v1/targets` first whenever data looks missing — it tells you
immediately whether the problem is Prometheus not scraping, or something
downstream in PromQL/Grafana."
