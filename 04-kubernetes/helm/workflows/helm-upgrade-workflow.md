# Helm Upgrade Workflow

```
New code merged
    ↓
CI builds + pushes image (new tag)
    ↓
helm upgrade --install backend ./charts/backend \
    -f values-production.yaml \
    --set image.tag=<new-tag>
    ↓
Helm renders new manifests
    ↓
Kubernetes performs a rolling update
    ↓
New pods created → readiness checked → old pods terminated
    ↓
helm history backend   (new revision recorded)
    ↓
helm status backend    (confirm deployed + healthy)
```

## Safety Checklist Before Upgrading Production

1. `helm template backend ./charts/backend -f values-production.yaml` — review the diff
2. `helm lint ./charts/backend` — no syntax errors
3. Confirm the image tag being deployed actually exists in the registry
4. Use `--atomic` so a failed upgrade rolls back automatically
5. Watch the rollout: `kubectl rollout status deployment/backend`
