# Useful Commands — Quick Reference

```bash
# Setup / discovery
helm version
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo redis

# Chart authoring
helm create backend
helm lint ./charts/backend
helm template backend ./charts/backend -f values-dev.yaml
helm dependency update ./charts/backend
helm dependency build ./charts/backend

# Install / upgrade
helm install backend ./charts/backend -f values-dev.yaml
helm upgrade backend ./charts/backend -f values-production.yaml
helm upgrade --install backend ./charts/backend -f values-production.yaml
helm upgrade --install backend ./charts/backend --set image.tag=2.0.0
helm upgrade --install backend ./charts/backend -f values-production.yaml --atomic --timeout 5m

# Release inspection
helm list -n production
helm status backend
helm history backend
helm get values backend
helm get manifest backend
helm get all backend

# Rollback
helm rollback backend 2

# Removal
helm uninstall backend
```
