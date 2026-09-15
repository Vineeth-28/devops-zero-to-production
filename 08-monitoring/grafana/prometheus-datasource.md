# Grafana: Prometheus Datasource

## What it is
The configuration that tells Grafana where a Prometheus server lives and
how to query it (URL, auth, scrape interval hints).

## Example provisioning config
```yaml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    jsonData:
      timeInterval: "15s"
```

## Key fields
- `url` — where Grafana sends PromQL queries
- `access: proxy` — Grafana's backend proxies the request (recommended over
  `direct`, which requires the browser to reach Prometheus directly)
- `timeInterval` — hints Grafana about your scrape interval for smarter
  auto-resolution of graph step size

## Production use
- Provision datasources as code (YAML file mounted into Grafana) instead of
  clicking through the UI, so datasource config is reproducible
- Use `access: proxy` almost always — keeps Prometheus off the public
  network and centralizes auth through Grafana

## Common mistakes
- Using `access: direct` and then wondering why dashboards break for users
  whose browsers can't reach the Prometheus URL directly
- Pointing at the wrong Prometheus instance in multi-environment setups
  (staging dashboard silently querying prod, or vice versa)

## Troubleshooting
- "Datasource not found" errors -> check the datasource `name` referenced
  in dashboard JSON matches the provisioned datasource name exactly
- Queries time out -> check Grafana pod/container can actually reach the
  Prometheus URL (network policy, DNS)

## Interview-ready answer
"The Prometheus datasource in Grafana just needs a URL and an access
mode — proxy mode routes queries through the Grafana backend, which is
the standard production setup since it avoids exposing Prometheus directly
to browsers and centralizes access control."
