# Day 28 — Helm Production Lab

## Objective

Practice production-style Helm usage: environment-specific values, CI/CD-style deploys, image tag overrides, upgrades, rollbacks, troubleshooting, and release verification.

## Concepts Covered

- Environment-specific values files
- `helm upgrade --install`
- `--set` for CI-injected values
- `--atomic` for safe upgrades
- Rollback under a simulated incident
- Helm → Kubernetes troubleshooting handoff

## Prerequisites

- Completion of Day 27 lab
- The `backend` chart from `04-kubernetes/helm/charts/backend/`

## Commands Used

```bash
helm upgrade --install backend ./charts/backend -f values-dev.yaml -n dev
helm upgrade --install backend ./charts/backend -f values-staging.yaml -n staging
helm upgrade --install backend ./charts/backend -f values-production.yaml --set image.tag=1.0.1 --atomic -n production
helm history backend -n production
helm rollback backend <N> -n production
helm get manifest backend -n production
kubectl get pods -n production
kubectl describe pod <pod> -n production
kubectl logs <pod> -n production
```

## Hands-On Tasks

1. Deploy to `dev` using `values-dev.yaml`
2. Deploy to `staging` using `values-staging.yaml`, confirm `ingress.enabled: true`
3. Deploy to `production` using `values-production.yaml` with `--atomic`
4. Simulate a CI deploy: override `image.tag` via `--set`
5. Intentionally break it — set an image tag that doesn't exist, upgrade, and observe `--atomic` auto-rollback
6. Fix the tag and redeploy successfully
7. Simulate a bad readiness probe path, observe `0/1 Ready`, then fix and redeploy
8. Run `helm history` and identify every revision's cause
9. Roll back manually to a specific earlier revision
10. Verify with `helm get manifest` that the rendered image tag matches what's actually running (`kubectl get pods -o jsonpath`)

## Expected Output

- Three independent releases (or namespaces) running the same chart with different config
- A demonstrated `--atomic` auto-rollback after a broken deploy
- `helm history` showing a clear, explainable trail of every revision

## Interview Questions

- Why is `--atomic` recommended for CI/CD pipelines?
- How would you deploy the exact same chart differently to dev, staging, and production?
- Walk through your troubleshooting steps if a production upgrade causes `CrashLoopBackOff`.

## Common Mistakes

- Using `--set` for large amounts of config instead of a values file (unreadable, error-prone)
- Not using `--atomic`, leaving a broken release stuck mid-upgrade
- Debugging with `kubectl` first instead of confirming `helm status`/`history` first — losing the release-level picture

## Key Takeaways

- Same chart, different values files = environment strategy
- `--atomic` is a production safety net, not optional nice-to-have
- Helm troubleshooting and Kubernetes troubleshooting are sequential, not interchangeable — check Helm's view first, then drop into `kubectl`
