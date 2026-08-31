# Deployment Commands

## What it is
Commands to create, scale, update, and roll back Deployments.

## Why we use it
Deployments are the standard way to run stateless applications in
production — they manage ReplicaSets and Pods for you.

## Commands

```bash
kubectl apply -f deployment.yaml
kubectl get deployments
kubectl get deployments -o wide
kubectl describe deployment <name>

kubectl scale deployment <name> --replicas=5

kubectl rollout status deployment <name>
kubectl rollout history deployment <name>
kubectl rollout history deployment <name> --revision=2
kubectl rollout undo deployment <name>
kubectl rollout undo deployment <name> --to-revision=2
kubectl rollout restart deployment <name>

kubectl set image deployment/<name> <container>=<image>:<tag>
```

## Example

```bash
kubectl set image deployment/backend backend=myapp:v2.1.0
kubectl rollout status deployment/backend
```
Triggers a rolling update and watches it complete.

## Common mistakes

- Scaling manually while an HPA is also managing replicas — the two fight
  each other.
- Forgetting `kubectl rollout status` after a deploy and assuming success
  without confirming the rollout actually completed.

## Production considerations

- `kubectl rollout undo` is the fastest safe rollback — it's much quicker
  than re-deploying an old image manually.
- Keep `revisionHistoryLimit` reasonable so `rollout history` has usable
  rollback points without keeping unlimited old ReplicaSets.

## Interview questions

- How do you roll back a bad deployment?
- What's the difference between `kubectl scale` and letting an HPA manage
  replicas?
- How do you check whether a rolling update has finished?
