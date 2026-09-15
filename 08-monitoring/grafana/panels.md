# Grafana Panels

## What it is
The individual visualization unit inside a dashboard — a graph, stat,
gauge, table, heatmap, etc., each backed by one or more queries.

## Common panel types
- **Time series / Graph** — line/area graph over time (most common for
  rate/latency/usage metrics)
- **Stat** — single big number (e.g. current error rate, uptime %)
- **Gauge** — single number shown against thresholds (e.g. disk usage %)
- **Table** — raw tabular query results (good for top-N lists)
- **Heatmap** — good for visualizing histogram/bucket distributions over
  time (latency heatmaps)

## Key settings per panel
- **Query** — the PromQL expression(s) driving the panel
- **Legend** — how series are labeled (often templated, e.g. `{{instance}}`)
- **Thresholds** — color bands (green/yellow/red) tied to value ranges
- **Unit** — display formatting (seconds, bytes, percent) so raw numbers
  are human-readable

## Production use
- Set units explicitly (Prometheus returns raw floats — Grafana doesn't
  know if `1024` means bytes or milliseconds unless you tell it)
- Use thresholds consistently with your alert rule thresholds so the
  dashboard visually matches what pages you

## Common mistakes
- Leaving unit as "none" for byte/second/percent metrics, making panels
  hard to read at a glance
- Too many series on one time-series panel (unreadable legend) — pair with
  variables/filters or `topk()` to limit displayed series

## Troubleshooting
- Panel shows "No data" -> check the query independently in Prometheus/
  Grafana's Explore view before assuming the panel config is wrong
- Legend shows raw label soup -> customize the legend format string
  (e.g. `{{method}} - {{status}}`)

## Interview-ready answer
"A panel is the basic visualization unit in Grafana, backed by a query
against a datasource. Time series panels are the default for metrics like
rate or latency; stat/gauge panels are better for single current values;
tables and heatmaps have specific use cases like top-N lists or latency
distributions."
