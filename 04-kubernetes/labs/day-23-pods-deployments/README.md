# Day 23 — Pods, Deployments & ReplicaSets Lab

## Objective
Understand Pods as the smallest deployable unit, and Deployments/
ReplicaSets as the production-standard way to run them.

## Concepts

- Pod vs container, Pod lifecycle and states
- Deployment -> ReplicaSet -> Pods
- Self-healing, rolling updates, rollback

## Commands Practiced

```bash
kubectl apply -f ../../manifests/pod.yaml
kubectl apply -f ../../manifests/deployment.yaml
kubectl get pods
kubectl get deployments
kubectl get replicasets
kubectl scale deployment backend --replicas=5
kubectl set image deployment/backend backend=myapp:v2.0.0
kubectl rollout status deployment/backend
kubectl rollout history deployment/backend
kubectl rollout undo deployment/backend
```

## Hands-on Tasks

1. Apply the standalone `pod.yaml` and inspect it with `kubectl describe
   pod`. Delete it and confirm it does **not** come back — standalone Pods
   have no self-healing.
2. Apply `deployment.yaml`. Delete one of its Pods with `kubectl delete
   pod <name>` and confirm a replacement Pod appears automatically — this
   is self-healing via the ReplicaSet.
3. Scale the Deployment up and down with `kubectl scale`.
4. Trigger a rolling update by changing the image tag, and watch it with
   `kubectl rollout status`.
5. Intentionally set a broken/nonexistent image tag and observe the
   rollout stall — old Pods stay up because new Pods never become Ready.
6. Roll back with `kubectl rollout undo` and confirm the broken rollout is
   reverted.

## Expected Outcome

You can explain, and demonstrate live, why a standalone Pod doesn't
self-heal but a Deployment-managed Pod does, and how a rolling update
protects against a bad deploy taking the app down.

## Interview Questions

- What's the relationship between a Deployment, a ReplicaSet, and Pods?
- How does a rolling update avoid downtime?
- How do you roll back to a specific earlier revision?

## Common Mistakes

- Editing a ReplicaSet directly instead of the Deployment.
- Assuming every `kubectl apply` triggers a new rollout — only Pod
  template changes do.

## Key Takeaways

- Deployments give you self-healing and safe rollouts that standalone Pods
  don't have.
- A bad rollout with proper readiness probes stalls safely — it doesn't
  usually cause an outage on its own.
