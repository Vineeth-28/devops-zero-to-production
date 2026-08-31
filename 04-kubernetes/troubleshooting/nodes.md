# Troubleshooting: Nodes

## Commands

```bash
kubectl get nodes
kubectl describe node <node-name>
kubectl top nodes
```

## Node conditions to check

```text
NotReady            -> node's kubelet isn't reporting healthy status
DiskPressure         -> node is running low on disk space
MemoryPressure        -> node is running low on memory
PIDPressure             -> node is running low on process IDs
NetworkUnavailable        -> node network isn't correctly configured
```

Any of these conditions being `True` (other than `Ready`) can prevent new
Pods from being scheduled to that node, and can trigger existing Pods being
evicted.

## Step-by-step checks

1. `kubectl get nodes` — spot which node(s) are `NotReady` or show pressure
   conditions.
2. `kubectl describe node <name>` — read the `Conditions` section and
   recent `Events` for detail.
3. `kubectl top nodes` — confirm actual CPU/memory usage if pressure
   conditions are involved.
4. Check for evicted Pods on that node:
   ```bash
   kubectl get pods --all-namespaces --field-selector spec.nodeName=<node-name>
   ```

## Common mistakes

- Only looking at `Ready` and missing `DiskPressure`/`MemoryPressure` —
  a node can be `Ready` and still be actively evicting Pods due to
  pressure.
- Not checking whether an issue is node-wide (affecting many Pods) vs
  Pod-specific before troubleshooting individual workloads.

## Production considerations

- Node-level problems affect every Pod scheduled there — when multiple
  unrelated Pods show similar symptoms, check node health before assuming
  it's an application bug.
