# Scheduling

## What it is
The process by which the Scheduler decides which node a new Pod should run
on.

## Why we use it
Clusters have many nodes with different capacity and characteristics —
something has to decide placement so resources are used efficiently and
constraints are respected.

## How it works

The Scheduler filters nodes based on:
- **Resource availability** — does the node have enough unallocated CPU/
  memory to satisfy the Pod's `requests`?
- **nodeSelector** — simple key-value match against node labels.
- **Affinity / anti-affinity** — more expressive rules (prefer/require
  co-locating with, or staying away from, other Pods or nodes).
- **Taints and tolerations** — a node can be "tainted" to repel Pods unless
  they explicitly "tolerate" that taint.

If no node satisfies all constraints, the Pod stays **Pending**.

## Example

```yaml
nodeSelector:
  disktype: ssd
```

```yaml
tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "gpu"
    effect: "NoSchedule"
```

## Why Pods can remain Pending

- Insufficient CPU/memory across all nodes for the requested amounts.
- `nodeSelector`/affinity rules that no node satisfies.
- Taints on all candidate nodes with no matching toleration.
- No nodes available at all (cluster autoscaler not configured/triggered).

## Common mistakes

- Setting `requests` far higher than actually needed, artificially
  reducing schedulable capacity and causing avoidable Pending Pods.
- Confusing taints/tolerations (repel unless tolerated) with node affinity
  (attract based on preference/requirement) — they solve different
  problems.

## Production considerations

- Use taints/tolerations to reserve specific nodes (e.g. GPU nodes) for
  specific workloads.
- Use anti-affinity to spread replicas of the same Deployment across nodes
  for availability.

## Interview questions

- Why might a Pod stay Pending indefinitely?
- Difference between nodeSelector and affinity/anti-affinity?
- How do taints and tolerations work together?
