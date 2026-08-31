# Interview Questions — Pods & Deployments

**Q1. Pod vs Deployment — what's the difference and why does it matter?**
Expected answer points:
- A Pod is the smallest deployable unit — one or more containers sharing
  network/storage.
- A Deployment manages ReplicaSets, which manage Pods — adding self-healing,
  scaling, and rolling updates on top of raw Pods.
- Standalone Pods have none of that — if deleted or crashed beyond
  restart, nothing recreates them.

**Q2. Explain the Deployment -> ReplicaSet -> Pod relationship.**
Expected answer points:
- Deployment defines desired state (replicas, Pod template) and manages
  rollout strategy/history.
- ReplicaSet's only job is maintaining N running Pods matching a Pod
  template.
- A rolling update works by creating a *new* ReplicaSet and shifting
  replicas from old to new.

**Q3. What are the Pod lifecycle states, and what does each mean?**
Expected answer points:
- `Pending` — accepted, not yet running (scheduling/image pull in
  progress).
- `Running` — bound to a node, at least one container running.
- `Succeeded` — all containers exited successfully (batch/Job use case).
- `Failed` — all containers terminated, at least one failed.
- `Unknown` — node communication lost.

**Q4. What's the difference between a container restarting and a Pod being
recreated?**
Expected answer points:
- A container can restart *within* the same Pod (per `restartPolicy`) —
  this is what shows up as `CrashLoopBackOff`.
- A Pod being recreated means an entirely new Pod object (new name, new
  IP) — happens when the controller managing it (e.g. ReplicaSet) replaces
  it.

**Q5. Deployment vs StatefulSet — conceptually, when would you need a
StatefulSet instead?**
Expected answer points:
- Deployments assume Pods are interchangeable (stateless) — any replica
  can serve any request.
- StatefulSets are for workloads needing stable network identity and/or
  stable per-replica storage (e.g. a database cluster where each replica
  has its own persistent identity).

**Q6. How does a rolling update avoid downtime?**
Expected answer points:
- New Pods must pass readiness before old Pods are scaled down.
- `maxSurge`/`maxUnavailable` control the pace and headroom of the
  transition.
- A broken new version that never becomes Ready stalls the rollout rather
  than replacing all working replicas.
