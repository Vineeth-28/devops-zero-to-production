# Prometheus Alerting Overview

## Why alerts
Dashboards require a human to be looking at them. Alerts push notification
of a problem to the right person/channel without requiring constant
watching — the whole point of automated monitoring.

## Mental model
```
CPU > 80%
for 5 minutes
    |
Alert fires
```

## Core concepts
- **Alert rule** — a PromQL expression evaluated on `evaluation_interval`;
  when it returns results, those results become candidate alerts
- **for duration** — how long the condition must stay true continuously
  before the alert actually fires (moves Pending -> Firing)
- **Pending** — condition is true but hasn't been true long enough yet
- **Firing** — condition has been true for at least `for:` duration; sent
  to Alertmanager
- **Labels** — attached to the alert, used by Alertmanager for
  routing/grouping (e.g. `severity="critical"`)
- **Annotations** — human-readable context (summary, description, runbook
  link) — not used for routing, just for display

## Why `for:` matters
```promql
expr: cpu_usage > 80
for: 5m
```
Without `for:`, a 10-second CPU spike would fire an alert instantly. `for:
5m` means the condition must be continuously true for 5 minutes before
anything fires — this filters out short-lived, self-resolving blips and
reduces noisy/false alerts.

## Production use
- Always set `for:` on anything that can legitimately spike briefly
  (CPU, latency) — but keep it short enough that real incidents still page
  promptly
- Separate rule files by severity/team for easier ownership

## Common mistakes
- No `for:` duration on noisy metrics -> alert fatigue from flapping
- `for:` set too long on critical conditions -> real incidents take too
  long to page

## Interview-ready answer
"Prometheus alert rules are PromQL expressions evaluated on a schedule; if
the expression returns results, the alert enters Pending, and only starts
Firing (and gets sent to Alertmanager) once the condition has been true
continuously for the `for:` duration. This debounces short-lived spikes so
you don't get paged for a 10-second blip."
