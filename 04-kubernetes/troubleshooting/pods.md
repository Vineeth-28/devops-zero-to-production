# Troubleshooting: Pods

## Pod Pending

A Pod stuck in `Pending` never got scheduled to a node.

```bash
kubectl get pods
kubectl describe pod <pod-name>
```

Check, in `describe pod` events:

- Insufficient CPU / memory across all nodes
- No node availability at all
- PVC stuck Pending (Pod can't start without its volume)
- `nodeSelector` matching no node
- Affinity/anti-affinity rules no node satisfies
- Taints with no matching toleration

## CrashLoopBackOff

The container starts, crashes, and Kubernetes keeps restarting it with
increasing backoff delay.

```bash
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl describe pod <pod-name>
```

Possible causes:

- Application crashes on startup (bug, unhandled exception)
- Wrong or missing environment variable
- Missing Secret or ConfigMap the app expects
- Database/dependency connection failure
- Wrong container start command/entrypoint

## ImagePullBackOff

```bash
kubectl describe pod <pod-name>
```

Check:

- Image name spelled correctly
- Image tag actually exists in the registry
- Private registry credentials (`imagePullSecrets`) configured correctly
- Network/registry access from the node

## OOMKilled

Container exceeded its allowed memory (`limits.memory`) and was killed by
the kernel's OOM killer.

Check:

- `resources.limits.memory` — is it realistic for the app?
- Actual memory usage: `kubectl top pod <pod-name>`
- Possible application memory leak
- Whether the workload's real peak usage was ever profiled

## Running but 0/1 Ready

Container is running, but the readiness probe is failing.

Check:

- Readiness probe path/port match the actual app
- Application is genuinely ready (dependencies like DB reachable)
- Port mismatch between probe config and container

## Common mistakes

- Reading only current `logs` and skipping `--previous` after a crash.
- Fixing the symptom (bumping memory limit) without checking `kubectl top
  pod` for a real leak.

## Production considerations

- Always check `kubectl describe pod` before logs — the Events section
  often explains *why* a Pod never got far enough to log anything useful.
