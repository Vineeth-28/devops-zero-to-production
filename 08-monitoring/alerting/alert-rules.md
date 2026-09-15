# Prometheus Alert Rules (Syntax + Examples)

## What it is
Rule files defining alerting rules, loaded via `rule_files:` in
`prometheus.yml`, evaluated on `evaluation_interval`.

## Syntax
```yaml
groups:
  - name: node-alerts
    rules:
      - alert: HighCPUUsage
        expr: |
          100 - (avg by (instance) (
            rate(node_cpu_seconds_total{mode="idle"}[5m])
          ) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU on {{ $labels.instance }}"
          description: "CPU usage above 80% for 5+ minutes."
```

## Fields
- `alert` — rule name
- `expr` — PromQL condition
- `for` — how long the condition must hold before firing
- `labels` — routing metadata (merged with the series' own labels)
- `annotations` — human-readable text, supports templating with `{{
  $labels.x }}` and `{{ $value }}`

## Practical examples

```yaml
- alert: InstanceDown
  expr: up == 0
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "{{ $labels.instance }} is down"

- alert: HighErrorRate
  expr: |
    sum(rate(http_requests_total{status=~"5.."}[5m]))
      / sum(rate(http_requests_total[5m])) > 0.05
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "Error rate above 5% for 5 minutes"

- alert: DiskAlmostFull
  expr: |
    node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"}
      / node_filesystem_size_bytes{fstype!~"tmpfs|overlay"} < 0.10
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "Disk on {{ $labels.instance }} below 10% free"
```

## Production use
- Always validate with `promtool check rules` before deploying
- Group rules logically (per team/service) into separate files
- Use `severity` labels consistently (`warning`, `critical`) — Alertmanager
  routing depends on this being predictable

## Common mistakes
- Typos in label names used for routing (silently drops into a default
  route instead of the intended team channel)
- Overly sensitive thresholds without a `for:` buffer causing alert fatigue

## Interview-ready answer
"An alert rule is a named PromQL expression with a `for:` duration,
labels for routing, and annotations for human-readable context. Rules live
in YAML rule files loaded by Prometheus and evaluated on a schedule; when
they fire, the resulting alert (with its labels) is sent to Alertmanager."
