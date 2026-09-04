# Helm Deployment Flow

## The Helm Lifecycle

```
helm create
    ↓
helm lint
    ↓
helm template
    ↓
helm install
    ↓
helm status
    ↓
helm upgrade
    ↓
helm history
    ↓
helm rollback
```

## What Happens at Each Stage

| Stage | What happens |
|---|---|
| `helm create` | Scaffold chart structure (Chart.yaml, values.yaml, templates/) |
| `helm lint` | Validate structure/syntax before touching a cluster |
| `helm template` | Render manifests locally — review before applying |
| `helm install` | Render + send manifests to Kubernetes API; creates release revision 1 |
| `helm status` | Confirm the release deployed successfully |
| `helm upgrade` | New revision applied on top of the running release |
| `helm history` | Full audit trail of every revision |
| `helm rollback` | Revert to a prior revision if something breaks |

## First Deploy vs Every Deploy After

```
First ever deploy:
    helm install backend ./charts/backend -f values-dev.yaml

Every deploy after (including CI/CD):
    helm upgrade --install backend ./charts/backend -f values-dev.yaml
```
