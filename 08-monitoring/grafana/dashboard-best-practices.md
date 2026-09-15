# Grafana Dashboard Best Practices

## What it is
Design guidance for dashboards that are actually useful during an
incident, not just decorative.

## Principles
- **Diagnosis, not decoration** — every panel should answer a question an
  on-call engineer would actually ask
- **Top-down layout** — overall health/SLO indicators at the top, detailed
  breakdowns below, so triage starts broad and narrows
- **Use variables** — one dashboard, many services/environments, instead of
  N near-duplicate dashboards that drift out of sync
- **Consistent units and thresholds** — match dashboard color thresholds to
  actual alert thresholds so what's "red" on screen matches what pages
- **Link dashboards to runbooks** — panel descriptions or dashboard links
  pointing to the relevant runbook save time mid-incident

## Practical checklist
- [ ] Request rate, error rate, latency (RED method) visible on the main panel
- [ ] Saturation signals (CPU, memory, disk, queue depth) visible nearby
- [ ] Time range defaults to something sane (last 1h or 6h, not 30 days)
- [ ] Variables for environment/service/instance where applicable
- [ ] No panel with more than ~8-10 legend entries (unreadable)
- [ ] Dashboard is provisioned as code, not hand-built only in the UI

## Common mistakes
- Building "vanity" dashboards with dozens of panels nobody looks at during
  an incident
- Mixing unrelated services on one dashboard, forcing the viewer to filter
  mentally
- No default time range or refresh interval set, so every viewer has to
  configure it themselves

## Interview-ready answer
"Good dashboards are built around the questions an on-call engineer needs
answered fast: request rate, error rate, latency, and saturation, laid out
top-down from overall health to detail. They use variables to avoid
duplicate near-identical dashboards, and are provisioned as code so
they're consistent and reviewable, not hand-clicked and drifted."
