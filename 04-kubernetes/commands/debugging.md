# Debugging Commands

## What it is
The core command set used to investigate almost any Kubernetes issue.

## Why we use it
This is the standard first-response toolkit — the same handful of commands
covers most incidents, from Pending Pods to broken Services.

## Commands

```bash
kubectl get pods -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

kubectl get svc,endpointslices
kubectl get pods --show-labels

kubectl exec -it <pod-name> -- /bin/sh
kubectl run debug --image=busybox -it --rm -- /bin/sh

kubectl get all -n <namespace>
```

## Example

```bash
kubectl run debug --image=busybox -it --rm -- /bin/sh
# then, inside the shell:
wget -O- http://backend:3000/health
```
Spins up a throwaway debug Pod inside the cluster network to test
connectivity to a Service by name — confirms whether DNS/networking is the
problem.

## Common mistakes

- Jumping straight to `kubectl logs` and skipping `kubectl describe pod`,
  missing scheduling/event-level information that explains *why* a Pod
  never got to the point of producing logs.
- Not sorting events by timestamp, making it hard to find the most recent
  (most relevant) one.

## Production considerations

- Always check `kubectl get events --sort-by=.metadata.creationTimestamp`
  early — Events often show the root cause before logs even become
  relevant.

## Interview questions

- Walk through your first three commands when a Pod is reported "down."
- How do you test Service connectivity from inside the cluster?
- Why check Events before diving into container logs?
