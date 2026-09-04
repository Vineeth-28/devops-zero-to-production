# Day 27 — Helm Fundamentals Lab

## Objective

Get hands-on with the core Helm lifecycle: create a chart, understand its structure, modify values, render templates, install, upgrade, check history, and roll back.

## Concepts Covered

- Chart structure
- values.yaml
- helm template rendering
- Install / upgrade / rollback
- Release history

## Prerequisites

- A running Kubernetes cluster (minikube / kind / Docker Desktop)
- Helm CLI installed (`helm version`)
- `kubectl` configured against the cluster

## Commands Used

```bash
helm create backend
helm show values ./backend
helm template backend ./backend
helm lint ./backend
helm install backend ./backend
helm list
helm status backend
helm upgrade backend ./backend --set replicaCount=3
helm history backend
helm rollback backend 1
kubectl get all -l app.kubernetes.io/instance=backend
```

## Hands-On Tasks

1. Create a Helm chart — `helm create backend`
2. Inspect chart structure — walk through `Chart.yaml`, `values.yaml`, `templates/`
3. Modify `values.yaml` — change `replicaCount` to `2`
4. Render using `helm template` — confirm the replica count shows up in the rendered Deployment
5. Run `helm lint` — confirm no errors
6. Install chart — `helm install backend ./backend`
7. Check `helm list` — confirm release appears with revision 1
8. Check `helm status` — confirm `STATUS: deployed`
9. Upgrade release — change `replicaCount` to `3`, run `helm upgrade`
10. Check history — `helm history backend` should show 2 revisions
11. Rollback release — `helm rollback backend 1`
12. Verify Kubernetes resources — `kubectl get pods` shows replica count back to 1

## Expected Output

- `helm list` shows `backend` with `STATUS: deployed`
- `helm history backend` shows 3 revisions total (install, upgrade, rollback)
- `kubectl get deployment backend` replica count matches the currently active revision

## Interview Questions

- What's the difference between `helm template` and `helm install`?
- What does `helm lint` check that `helm template` doesn't?
- Why does a rollback create a new revision instead of deleting history?

## Common Mistakes

- Forgetting `helm lint`/`helm template` before install — catching typos only after a failed install wastes time
- Confusing `replicaCount` in `values.yaml` with `kubectl scale` (scaling manually causes drift from what Helm thinks is deployed)
- Not checking `helm status` after install — assuming "no error" means "healthy"

## Key Takeaways

- Chart = package, Release = installed instance
- `helm template` for local preview, `helm install`/`upgrade` for actual deploys
- Every upgrade creates a new, rollback-able revision
