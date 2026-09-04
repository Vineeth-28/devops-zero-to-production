# Helm + CI/CD Workflow

## Production Pipeline

```
Developer
    ↓
GitHub
    ↓
Jenkins / GitHub Actions
    ↓
Tests
    ↓
Docker Build
    ↓
Push Image
    ↓
Helm
    ↓
values-production.yaml
    ↓
helm upgrade --install
    ↓
Kubernetes
    ↓
Deployment
    ↓
Pods
    ↓
Readiness
    ↓
Traffic
```

## Responsibility of Each Component

| Component | Responsibility |
|---|---|
| Developer | Writes code, opens PR |
| GitHub | Source of truth, triggers pipeline on merge |
| CI runner (Jenkins/GH Actions) | Orchestrates the pipeline steps |
| Tests | Verify code correctness before anything is built |
| Docker Build | Packages app + runtime into an image |
| Push Image | Publishes image to a container registry (tagged, e.g. with commit SHA) |
| Helm | Templates the Kubernetes config for this new image |
| values-production.yaml | Supplies production-specific config (replicas, resources, ingress) |
| `helm upgrade --install` | Applies the new release to the cluster, tracked with a new revision |
| Kubernetes | Schedules pods, manages rollout, self-heals |
| Readiness | Gate that decides when a pod starts receiving traffic |
| Traffic | End users now hit the new version |

## Example CI Step

```bash
helm upgrade --install backend ./charts/backend \
  -f values-production.yaml \
  --set image.tag=$CI_COMMIT_SHA \
  --atomic \
  --timeout 5m \
  -n production
```

`--atomic` ensures a failed rollout auto-rolls-back instead of leaving production half-deployed.
