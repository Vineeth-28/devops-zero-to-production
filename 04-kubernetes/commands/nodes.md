# Node Commands

## What it is
Commands to inspect the worker (and control plane) nodes that make up the
cluster.

## Why we use it
Node health directly affects whether Pods can be scheduled and stay
running.

## Commands

```bash
kubectl get nodes
kubectl get nodes -o wide
kubectl describe node <node-name>

kubectl top nodes
kubectl top pods

kubectl cordon <node-name>
kubectl drain <node-name> --ignore-daemonsets
kubectl uncordon <node-name>

kubectl label node <node-name> disktype=ssd
```

## Example

```bash
kubectl describe node worker-2 | grep -A5 Conditions
```
Shows node Conditions (`Ready`, `MemoryPressure`, `DiskPressure`,
`PIDPressure`, `NetworkUnavailable`) — the key signal for node-level
problems.

## Common mistakes

- Draining a node without `--ignore-daemonsets` when DaemonSet Pods are
  present, causing the drain to hang.
- Ignoring `DiskPressure`/`MemoryPressure` conditions until Pods start being
  evicted.

## Production considerations

- `kubectl cordon` before `kubectl drain` for planned maintenance — cordon
  stops new scheduling, drain evicts existing Pods safely.

## Interview questions

- What does `NotReady` on a node mean, and what would you check next?
- Difference between `cordon` and `drain`?
- What node conditions can prevent new Pods from being scheduled there?
