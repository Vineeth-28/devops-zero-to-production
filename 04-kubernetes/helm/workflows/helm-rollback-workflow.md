# Helm Rollback Workflow

```
Production incident detected
    ↓
helm status backend         (confirm current revision)
    ↓
helm history backend        (find last known-good revision)
    ↓
helm rollback backend <N>
    ↓
Helm creates a NEW revision matching the content of revision N
    ↓
Kubernetes rolls pods back to that state
    ↓
kubectl get pods            (verify pods healthy)
    ↓
helm status backend         (confirm STATUS: deployed)
```

## Example

```
Revision 1 → v1  (good)
Revision 2 → v2  (good)
Revision 3 → v3  (broken — bad env var, CrashLoopBackOff)
```

```bash
helm rollback backend 2
```

Result: a new **revision 4** is created, containing the same manifests as revision 2. History is never rewritten — `helm history` will show all 4 revisions, with revision 4 marked as the currently `deployed` one.

## Verification

```bash
helm status backend
helm history backend
kubectl get pods
kubectl logs <pod>
```
