# Day 25 — Storage, ConfigMaps, Secrets & Health Checks Lab

## Objective
Understand persistent storage, configuration/secret injection, and the
three probe types together.

## Concepts

- Volumes, PV, PVC, StorageClass, dynamic provisioning
- ConfigMaps vs Secrets, `env` vs `envFrom`
- Liveness, Readiness, Startup probes

## Commands Practiced

```bash
kubectl apply -f ../../manifests/pvc.yaml
kubectl apply -f ../../manifests/configmap.yaml
kubectl apply -f ../../manifests/secret.yaml
kubectl apply -f ../../manifests/probes.yaml
kubectl get pvc
kubectl describe pvc mysql-data
kubectl get secret db-secret -o jsonpath='{.data.DB_PASSWORD}' | base64 --decode
kubectl describe pod <pod-name>
```

## Hands-on Tasks

1. Apply `pvc.yaml` and confirm it reaches `Bound` (or investigate why it's
   `Pending` if using a cluster without a default StorageClass).
2. Apply `configmap.yaml` and `secret.yaml`, then deploy a Pod that
   consumes both via `envFrom`/`env`, and confirm the values are present
   with `kubectl exec ... -- env`.
3. Decode the Secret value locally with `base64 --decode` to prove it's
   encoded, not encrypted.
4. Apply `probes.yaml`. Temporarily break the readiness endpoint (or point
   it at a wrong path) and observe the Pod go `Running` but `0/1 Ready`.
5. Fix the readiness probe and confirm the Pod becomes `1/1 Ready` and
   rejoins Service endpoints (if a Service targets it).
6. Delete the Pod (but not the PVC) and confirm the new Pod that replaces
   it still has access to the same persistent data.

## Expected Outcome

You can explain why deleting a Pod doesn't delete its data, why Secrets
aren't automatically secure, and the practical difference between a
liveness and readiness failure.

## Interview Questions

- Why doesn't deleting a Pod delete its persistent data?
- Is a Kubernetes Secret encrypted by default?
- What's the practical difference between liveness and readiness failing?

## Common Mistakes

- Assuming Secrets are encrypted because they're base64-encoded.
- No `startupProbe` on a slow-booting app, causing liveness to kill it
  mid-startup.

## Key Takeaways

- Persistent data survives Pod deletion as long as the PVC survives.
- Readiness controls traffic; liveness controls restarts — mixing these up
  causes very different (and sometimes worse) incidents.
