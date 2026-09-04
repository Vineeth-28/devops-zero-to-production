# Upgrades & Rollbacks

## Upgrade

```bash
helm upgrade backend ./backend
```

Applies a new revision of the chart/values to an **already-installed** release. Fails if the release doesn't exist yet.

## Install or Upgrade (the CI/CD standard)

```bash
helm upgrade --install backend ./backend
```

- If the release exists → upgrade it
- If it doesn't exist → install it

**This is why `helm upgrade --install` is used constantly in CI/CD pipelines** — the pipeline doesn't need to know or check whether this is the first deploy or the hundredth. Same command, every time, idempotent.

## Rollback

```
Revision 1 → v1
Revision 2 → v2
Revision 3 → v3  ❌ (broken deploy)
```

```bash
helm rollback backend 2
```

**What happens:**
- Helm re-applies the manifests from revision 2
- A **new revision (4)** is created whose content matches revision 2 (rollback is itself tracked as a new event, not a deletion of history)
- Kubernetes reconciles pods back to the revision-2 state

**Why it's useful:** instant recovery from a bad deploy without manually reconstructing old YAML.

**How to verify:**
```bash
helm status backend
helm history backend
kubectl get pods
```

## `helm rollback` vs `kubectl rollout undo`

| | `helm rollback` | `kubectl rollout undo` |
|---|---|---|
| Scope | Entire release (Deployment + Service + ConfigMap + Secret + Ingress, everything the chart manages) | Only that specific Deployment's pod template |
| Tracks | Helm release revisions | Kubernetes ReplicaSet history for one Deployment |
| Use when | You deployed via Helm and need a full release rollback | You're working with raw `kubectl` and only a Deployment needs reverting |

**Rule of thumb:** if you deployed with Helm, roll back with Helm — rolling back only the Deployment via `kubectl` can leave ConfigMaps/Secrets/Services out of sync with what the Deployment expects.
