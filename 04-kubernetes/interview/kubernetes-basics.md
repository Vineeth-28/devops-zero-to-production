# Interview Questions — Kubernetes Basics

**Q1. What is Kubernetes, and what problem does it solve?**
A container orchestration platform. It solves the problem of running
containers reliably at scale: automatic scheduling, self-healing, scaling,
and networking that would otherwise be manual and error-prone.

Expected answer points:
- Automates placement, restart, scaling, and networking of containers.
- Reconciles actual state to desired state continuously (control loops).
- Replaces manual container management across many machines.

**Q2. Explain the Control Plane vs Worker Node split.**
Expected answer points:
- Control Plane makes cluster-wide decisions (API Server, etcd, Scheduler,
  Controller Manager).
- Worker Nodes actually run workloads (Kubelet, Kube Proxy, Container
  Runtime).
- `kubectl` only ever talks to the API Server, never directly to nodes.

**Q3. What is the API Server's role, and why is everything routed through
it?**
Expected answer points:
- Single entry point for all cluster operations — validates, authenticates,
  and persists changes to etcd.
- Every other component (Scheduler, Controller Manager, Kubelet) watches
  the API Server for changes rather than talking to each other directly.
- This makes the API Server the natural single audit/control point.

**Q4. What is etcd, and why does it matter so much?**
Expected answer points:
- Distributed key-value store holding all cluster state — the single
  source of truth.
- Losing etcd without a backup effectively means losing the cluster's
  configuration and state.
- Should be backed up regularly and treated as critical infrastructure.

**Q5. Difference between the Scheduler and the Kubelet?**
Expected answer points:
- Scheduler decides *which node* a Pod should run on (a decision, recorded
  in the API Server).
- Kubelet, running on that node, actually *starts* the containers via the
  container runtime, and reports status back.

**Q6. What is a Namespace, and what isolation does it actually provide?**
Expected answer points:
- Logical partition for grouping and naming resources.
- Does NOT provide network isolation or security by default — that needs
  NetworkPolicies and RBAC on top.
