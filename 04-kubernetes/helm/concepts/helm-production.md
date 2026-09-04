# Helm in Production

## The Full Mental Model

```
Kubernetes
    ↓
Raw YAML becomes difficult to manage
    ↓
Helm
    ↓
Chart
    ↓
values.yaml + templates
    ↓
Rendered Kubernetes manifests
    ↓
Release
    ↓
Kubernetes resources
    ↓
Upgrade / Rollback / Troubleshoot
```

## Environment Strategy

```
Same Chart
    ↓
Different values
    ↓
Different environments
```

One chart, multiple values files:

```
values.yaml              # shared defaults
values-dev.yaml           # dev overrides
values-staging.yaml        # staging overrides
values-production.yaml      # production overrides
```

```bash
helm upgrade --install backend ./charts/backend -f values-production.yaml
```

## Helm's Place in the Bigger Picture

```
Docker
    ↓
packages the application (code + runtime) into an image
    ↓
Helm
    ↓
packages/templates the Kubernetes deployment configuration
    ↓
Kubernetes
    ↓
runs the application (scheduling, networking, scaling, self-healing)
```

This distinction matters: **Helm never runs your app.** It only produces the YAML that tells Kubernetes how to run it.

## Production Principles

1. **Never edit a live release by hand with `kubectl edit`** — always change values/chart and `helm upgrade`, so Helm's history stays accurate.
2. **Pin chart and dependency versions** — don't let CI pull a moving `latest` chart version.
3. **Use `--atomic`** in CI/CD (`helm upgrade --install --atomic`) so a failed upgrade automatically rolls back instead of leaving the release half-applied.
4. **Keep values files environment-specific but minimal** — only override what actually differs; inherit the rest from `values.yaml`.
5. **Treat Helm troubleshooting and Kubernetes troubleshooting as two layers** — Helm tells you what was released; `kubectl` tells you what's actually running.
