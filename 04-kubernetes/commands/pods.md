# Pod Commands

## What it is
Commands to create, inspect, and interact with Pods — the smallest
deployable unit in Kubernetes.

## Why we use it
Pods are where your application actually runs; these are the first commands
used in almost any investigation.

## Commands

```bash
kubectl get pods
kubectl get pods -o wide
kubectl get pods -n <namespace>
kubectl get pods --show-labels
kubectl get pods -l app=backend

kubectl describe pod <pod-name>

kubectl logs <pod-name>
kubectl logs <pod-name> -f
kubectl logs <pod-name> --previous
kubectl logs <pod-name> -c <container-name>

kubectl exec -it <pod-name> -- /bin/sh
kubectl exec -it <pod-name> -c <container-name> -- /bin/sh

kubectl delete pod <pod-name>
kubectl apply -f pod.yaml
```

## Example

```bash
kubectl logs backend-7d4d9c9f8b-x2kqp --previous
```
Shows logs from the previous (crashed) instance of a container — essential
for diagnosing `CrashLoopBackOff`.

## Common mistakes

- Forgetting `--previous` when a container has already restarted — the
  current logs may be empty or unrelated to the crash.
- Using `kubectl logs` on a multi-container Pod without `-c` and getting an
  error or the wrong container's logs.

## Production considerations

- `kubectl exec` into a running container is useful for debugging but
  changes made this way are not persisted — the container is disposable.

## Interview questions

- How do you view logs from a Pod that just crashed and restarted?
- How do you get a shell inside a running container?
- What's the difference between `kubectl delete pod` on a Pod managed by a
  Deployment vs a standalone Pod?
