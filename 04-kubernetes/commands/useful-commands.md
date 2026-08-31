# Useful / Misc Commands

## What it is
A grab-bag of commands used often enough to be worth their own quick-reference.

## Why we use it
Small time-savers that come up constantly during revision and real work.

## Commands

```bash
# Watch resources live
kubectl get pods -w

# Get resource usage
kubectl top pods
kubectl top nodes

# Dry-run to validate YAML without applying
kubectl apply -f deployment.yaml --dry-run=client -o yaml

# Diff what would change before applying
kubectl diff -f deployment.yaml

# Explain a resource's fields
kubectl explain pod.spec.containers

# Get all resources of all kinds in a namespace
kubectl get all -n <namespace>

# Get resource YAML for reuse
kubectl get deployment backend -o yaml > backend-export.yaml

# Port-forward to a Pod or Service for local testing
kubectl port-forward pod/<pod-name> 8080:3000
kubectl port-forward svc/<service-name> 8080:80

# Delete all Pods matching a label (forces recreation via controller)
kubectl delete pods -l app=backend
```

## Example

```bash
kubectl port-forward svc/backend 8080:80
curl http://localhost:8080/health
```
Tests a Service from your local machine without exposing it externally.

## Common mistakes

- Using `kubectl delete pods -l ...` and expecting the app to be "down" —
  if it's managed by a Deployment, Pods are immediately recreated.
- Forgetting `--dry-run=client` exists, and applying untested YAML directly
  to a live cluster.

## Production considerations

- `kubectl diff` before `kubectl apply` in production namespaces helps
  catch unintended changes before they land.

## Interview questions

- How would you test a Service without exposing it externally?
- How do you validate a YAML manifest before applying it?
- How would you quickly force a Deployment's Pods to be recreated?
