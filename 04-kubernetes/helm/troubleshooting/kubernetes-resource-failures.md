# Troubleshooting: Kubernetes-Level Failures (Post-Helm)

Once `helm install`/`upgrade` reports `deployed`, any further failure is a **Kubernetes** problem, not a Helm problem. Helm's job ended the moment the manifests were applied.

## Standard Investigation Order

```
kubectl get pods
    ↓
kubectl describe pod <pod>
    ↓
kubectl logs <pod>
    ↓
kubectl get events --sort-by=.lastTimestamp
```

## Common Symptoms → Likely Cause

| Symptom | Likely Cause |
|---|---|
| `ImagePullBackOff` | Wrong tag/repo, or missing registry credentials |
| `CrashLoopBackOff` | App error on startup — check `kubectl logs` |
| `Pending` | Insufficient cluster resources, or unschedulable (node selector / taint mismatch) |
| `0/1 Ready` (Running) | Failing readiness probe |
| `OOMKilled` | Container exceeded memory limit — check `resources.limits.memory` |
| Service has no endpoints | Selector labels on Service don't match pod labels (common Helm templating mistake — check `_helpers.tpl` selector labels are used consistently) |

## Key Reminder

Do not keep re-running `helm upgrade` hoping a Kubernetes-level issue will resolve itself. If `helm get manifest` shows the YAML is correct, move fully into `kubectl` troubleshooting — the release layer is no longer the problem.
