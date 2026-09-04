# Production Helm Incident Playbook

## Immediate Triage (first 2 minutes)

```bash
helm status backend -n production
helm history backend -n production
kubectl get pods -n production -l app=backend
```

Answer three questions immediately:
1. Is the release itself healthy (`helm status`)?
2. Which revision is live, and did it just change?
3. Are pods actually up and ready?

## Decision Tree

```
Is it a bad deploy (just upgraded)?
  → YES → helm rollback backend <last-good-revision>
  → NO  → Is it a Kubernetes-level issue (resources, node, network)?
            → kubectl describe / logs / events
```

## Full Incident Scenarios Recap

| Scenario | Symptom | Fix |
|---|---|---|
| Bad image tag | `ImagePullBackOff` | Fix tag, `helm upgrade --install` |
| Bad env var | `CrashLoopBackOff` | `helm rollback`, then fix values |
| Bad readiness probe | `0/1 Ready` | Fix probe path, redeploy |
| Invalid template | Install/upgrade fails before touching cluster | Fix template syntax |
| Wrong values | Unexpected config in prod | Fix values file, `helm template` to verify before applying |

## Post-Incident

- Confirm `helm history` shows the rollback/fix as the latest `deployed` revision
- Add a `helm lint` + `helm template` step to CI if the incident could have been caught pre-deploy
- If root cause was a values mistake, consider adding `required` guards in templates for that key
