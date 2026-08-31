# Troubleshooting: Deployments

## Rollout stuck / not progressing

```bash
kubectl rollout status deployment/<name>
kubectl describe deployment <name>
kubectl get replicasets -l app=<name>
kubectl get pods -l app=<name>
```

Check:

- New ReplicaSet's Pods are failing (CrashLoopBackOff, ImagePullBackOff,
  Pending) — the rollout can't progress if new Pods never become Ready.
- `maxUnavailable`/`maxSurge` settings blocking progress given current
  cluster capacity.

## Old Pods never terminate

- New Pods must pass readiness before old Pods are scaled down — if new
  Pods never become Ready, old Pods stay around indefinitely (this looks
  like a "stuck" deployment).

## Wrong image deployed

```bash
kubectl describe deployment <name> | grep Image
kubectl rollout history deployment/<name>
```

Check the actual image pulled vs what you intended — a common cause is
`imagePullPolicy` and a mutable tag like `:latest` serving a stale cached
image on some nodes.

## Rollback needed

```bash
kubectl rollout undo deployment/<name>
kubectl rollout undo deployment/<name> --to-revision=<N>
```

## Common mistakes

- Assuming `kubectl apply` succeeding means the rollout succeeded — always
  confirm with `kubectl rollout status`.
- Debugging the Deployment object when the real problem is in the newly
  created Pods — check `kubectl get pods` for the actual failure.

## Production considerations

- A stuck rollout in production should be investigated at the Pod level
  first (why aren't new Pods becoming Ready), then rolled back if the fix
  isn't immediate.
