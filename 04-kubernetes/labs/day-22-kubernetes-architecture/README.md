# Day 22 — Kubernetes Architecture Lab

## Objective
Understand the Control Plane / Worker Node split and confirm it hands-on
against a real (or local, e.g. Minikube/kind) cluster.

## Concepts

- Cluster, Control Plane, Worker Nodes
- API Server, etcd, Scheduler, Controller Manager
- Kubelet, Kube Proxy, Container Runtime
- The `kubectl -> API Server -> Scheduler -> Kubelet -> Container Runtime`
  flow

## Commands Practiced

```bash
kubectl cluster-info
kubectl get nodes -o wide
kubectl describe node <node-name>
kubectl get pods -n kube-system
kubectl api-resources
```

## Hands-on Tasks

1. Run `kubectl cluster-info` and identify the API Server endpoint.
2. List nodes and identify which (if any) are control-plane nodes vs
   worker nodes (`kubectl get nodes -o wide`, check labels/roles).
3. List Pods in `kube-system` and identify the control plane components
   running as Pods (API Server, etcd, Scheduler, Controller Manager on
   self-hosted/kubeadm clusters; on managed clusters like EKS/GKE some of
   these are hidden from you).
4. `kubectl describe node <name>` — read through Capacity, Allocatable,
   and Conditions.
5. Apply a simple Pod and narrate out loud (or in writing) every hop it
   takes from `kubectl apply` to a running container, using the
   architecture diagram in `../../concepts/kubernetes-architecture.md`.

## Expected Outcome

You can draw the architecture diagram from memory and explain, in your own
words, what happens between running `kubectl apply` and a container
actually starting.

## Interview Questions

- What does the API Server do, and why is it the only thing `kubectl`
  talks to?
- What's the difference between the Scheduler's job and the Kubelet's job?
- Why is etcd so important to back up?

## Common Mistakes

- Thinking `kubectl` talks directly to nodes — it only ever talks to the
  API Server.
- Confusing the Scheduler (decides placement) with the Kubelet (actually
  starts containers).

## Key Takeaways

- Every operation flows through the API Server — it's the single front
  door to the cluster.
- etcd is the cluster's single source of truth; losing it (without backup)
  means losing cluster state.
