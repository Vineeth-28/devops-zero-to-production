# Rolling Update Flow

## What it is
The sequence Kubernetes follows internally when a Deployment's Pod
template changes (e.g. a new image).

## Flow

```text
kubectl set image deployment/backend backend=myapp:v2.0.0
      │
      ▼
Deployment Controller creates a NEW ReplicaSet
(with the updated Pod template)
      │
      ▼
New ReplicaSet scales up gradually
(respecting maxSurge)
      │
      ▼
New Pods must pass readiness probes
      │
      ▼
Old ReplicaSet scales down gradually
(respecting maxUnavailable)
      │
      ▼
Repeat until:
new ReplicaSet = desired replicas
old ReplicaSet = 0
      │
      ▼
Rollout complete
```

## Key points

- Old Pods are only removed as new Pods become Ready — a broken new image
  that never passes readiness will stall the rollout indefinitely rather
  than taking the app down.
- `maxSurge`/`maxUnavailable` control how many extra/how few Pods are
  allowed during the transition.

## Common mistakes

- Assuming a rolling update is instant — it's a gradual, readiness-gated
  process that can take time proportional to probe delays and replica
  count.

## Interview questions

- Why doesn't a bad rolling update usually cause full downtime?
- What controls how aggressive vs conservative a rolling update is?
