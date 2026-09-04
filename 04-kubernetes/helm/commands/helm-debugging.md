# Debugging Commands

### `helm lint`
- **Purpose:** Validate chart syntax/structure.
- **Syntax:** `helm lint <chart-path>`
- **Example:** `helm lint ./charts/backend`
- **Production use:** First line of defense in CI — catches malformed YAML/templates before install.

### `helm template`
- **Purpose:** Render manifests locally without touching the cluster.
- **Syntax:** `helm template <release> <chart-path> -f <values-file>`
- **Example:** `helm template backend ./charts/backend -f values-production.yaml`
- **Production use:** Review exactly what would be deployed — diff against previous output before upgrading.

### `helm status`
- **Purpose:** Current state of a release.
- **Syntax:** `helm status <release>`
- **Example:** `helm status backend`
- **Production use:** Is the release healthy? What revision is live?

### `helm history`
- **Purpose:** Revision history of a release.
- **Syntax:** `helm history <release>`
- **Example:** `helm history backend`
- **Production use:** Identify when things broke and what changed.

### `helm get values`
- **Purpose:** Show values actually in effect.
- **Syntax:** `helm get values <release>`
- **Example:** `helm get values backend`
- **Production use:** Confirm the live config matches what you intended to deploy.

### `helm get manifest`
- **Purpose:** Show rendered manifests actually applied.
- **Syntax:** `helm get manifest <release>`
- **Example:** `helm get manifest backend`
- **Production use:** Ground-truth of what Kubernetes objects exist because of this release.

### `helm get all`
- **Purpose:** Values + manifest + notes + hooks together.
- **Syntax:** `helm get all <release>`
- **Example:** `helm get all backend`

## Connecting Helm Debugging → Kubernetes Debugging

```
helm status
    ↓
helm history
    ↓
kubectl get pods
    ↓
kubectl describe pod
    ↓
kubectl logs
    ↓
kubectl get events
```

**Important principle:** Helm does NOT replace Kubernetes troubleshooting. Helm manages the packaging/release layer. Kubernetes still runs and manages the actual resources — once `helm install`/`upgrade` succeeds, all further pod-level debugging is pure Kubernetes territory.
