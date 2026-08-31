# Production Workflow

## What it is
The full lifecycle of a change from commit to running safely in production,
tying together CI/CD (Jenkins/GitHub Actions from `07-cicd/`) with
Kubernetes deployment.

## Flow

```text
Developer
   │
   ▼
git push
   │
   ▼
CI/CD Pipeline (Jenkins or GitHub Actions)
   │
   ▼
Build + Test
   │
   ▼
Docker Build + Tag (commit SHA)
   │
   ▼
Docker Push to Registry
   │
   ▼
kubectl apply -f deployment.yaml
(image tag updated to new SHA)
   │
   ▼
Deployment Controller creates new ReplicaSet
   │
   ▼
Rolling Update (readiness-gated)
   │
   ▼
kubectl rollout status
   │
   ▼
Verify: Pods Ready, Service has endpoints, app responding
   │
   ▼
Monitor (metrics, logs, events)
   │
   ▼
Rollback if needed (kubectl rollout undo)
```

## Key points

- The same `github.sha`/commit-SHA tagging discipline from the CI/CD module
  carries directly into Kubernetes — deploying a specific image tag (not
  `latest`) is what makes `kubectl rollout undo` a reliable, precise
  rollback.
- "Deployed" isn't the same as "verified" — always confirm rollout status
  and real application health before considering a deploy complete.

## Common mistakes

- Deploying `latest` to Kubernetes — makes rollback ambiguous, since the
  previous ReplicaSet's Pod template may reference the same mutable tag.

## Interview questions

- How does commit-SHA image tagging from CI/CD help with Kubernetes
  rollbacks?
- What would you check to confirm a deploy is actually complete and
  healthy, not just "applied"?
