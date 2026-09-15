# Alertmanager

## What it does
Receives firing alerts from Prometheus and handles everything after that:
grouping, routing, silencing, inhibition, and sending notifications.

## Mental model
```
Prometheus
    |
Alert Rule
    |
Alert fires
    |
Alertmanager
    |
Grouping
Routing
Inhibition
Silencing
    |
Notification
```

## Responsibility split
- **Prometheus** — detects/evaluates alert conditions (the "is something
  wrong" decision)
- **Alertmanager** — manages, groups, routes, and sends notifications for
  alerts that are already firing (the "who do I tell, and how" decision)

## Concepts
- **Grouping** — batches related alerts into a single notification (e.g.
  all `InstanceDown` alerts for the same cluster in one message instead of
  20 separate pages)
- **Routing** — a tree of matchers that decides which receiver
  (Slack/PagerDuty/email) gets which alert, based on labels like `severity`
  or `team`
- **Silencing** — temporarily mute alerts matching a label set (e.g. during
  planned maintenance)
- **Inhibition** — suppress lower-priority alerts when a related
  higher-priority alert is already firing (e.g. suppress "high latency"
  once "instance down" is already firing for the same instance)
- **Notification receivers** — the actual destinations (Slack webhook,
  PagerDuty, email, etc.)

## Example config sketch
```yaml
route:
  receiver: default
  group_by: ["alertname", "cluster"]
  routes:
    - match:
        severity: critical
      receiver: pagerduty
    - match:
        severity: warning
      receiver: slack

receivers:
  - name: default
    slack_configs:
      - channel: "#alerts"
  - name: pagerduty
    pagerduty_configs:
      - service_key: "<key>"
  - name: slack
    slack_configs:
      - channel: "#alerts-warning"
```

## Alert fatigue and good alert design
Too many low-value alerts train responders to ignore notifications
entirely — the most dangerous failure mode in monitoring. Combat it with:
grouping, sensible `for:` durations, inhibition of redundant alerts, and
only alerting on symptoms that require human action.

## Common mistakes
- No grouping — a single incident spamming 50 individual notifications
- Every alert routed to the same channel regardless of severity
- No inhibition rules, so a full outage triggers dozens of downstream
  alerts on top of the root cause

## Troubleshooting
- Alert fires in Prometheus but no notification arrives -> check
  Prometheus's `alerting:` block actually points at Alertmanager, then
  check Alertmanager's routing tree matches the alert's labels, then check
  the receiver's own config (webhook URL, credentials)

## Interview-ready answer
"Alertmanager sits downstream of Prometheus's rule evaluation. Prometheus
decides something is wrong and sends the firing alert to Alertmanager,
which groups related alerts, routes them to the right receiver based on
label matchers, supports silencing for planned work, and can inhibit
lower-priority alerts when a related higher-priority one is already
firing — all aimed at reducing alert fatigue."
