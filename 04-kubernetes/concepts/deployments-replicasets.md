# Deployments & ReplicaSets

## What it is
- A **ReplicaSet** ensures a specified number of identical Pod replicas are
  running at all times.
- A **Deployment** manages ReplicaSets on your behalf, adding rolling
  updates, rollback, and revision history on top.

## Why we use it
Manually keeping N Pods alive, and rolling out new versions without
downtime, isn't something you want to do by hand. Deployments automate it.

## How it works

- You declare a **desired state** (`replicas: 3`, a specific container
  image). The Deployment controller continuously reconciles actual state
  toward that desired state — this is **self-healing**.
- A rolling update creates a *new* ReplicaSet with the new Pod template and
  gradually scales it up while scaling the old ReplicaSet down.
- Every rollout is recorded, so you can inspect history and roll back.

## Diagram

```text
Deployment
    │
    ▼
ReplicaSet
    │
    ▼
Pods
```

## Commands

```bash
kubectl apply -f deployment.yaml
kubectl get deployments
kubectl get replicasets
kubectl rollout status deployment/backend
kubectl rollout history deployment/backend
kubectl rollout undo deployment/backend
kubectl scale deployment backend --replicas=5
```

## Example

Updating the image triggers a new ReplicaSet automatically:
```bash
kubectl set image deployment/backend backend=myapp:v2.0.0
kubectl rollout status deployment/backend
```

## Common mistakes

- Editing a ReplicaSet directly instead of the Deployment — the Deployment
  will often just recreate/override it.
- Assuming `kubectl apply` always triggers a rolling update — it only does
  so if the Pod template actually changed.

## Production considerations

- Configure `maxSurge`/`maxUnavailable` on the rolling update strategy to
  control how aggressive updates are relative to capacity headroom.
- Keep enough `revisionHistoryLimit` for rollback, but not unlimited old
  ReplicaSets cluttering the cluster.

## Interview questions

- What's the relationship between a Deployment, a ReplicaSet, and Pods?
- How does a rolling update actually work under the hood?
- How do you roll back to a specific earlier revision?
