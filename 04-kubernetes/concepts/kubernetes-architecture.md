# Kubernetes Architecture

## What it is
Kubernetes is a container orchestration platform: it schedules, runs, heals,
and scales containerized applications across a cluster of machines.

## Why we use it
Running containers manually doesn't scale — you need something to decide
*where* containers run, restart them when they crash, and route traffic to
them. Kubernetes does that automatically.

## How it works

A **Cluster** is made of a **Control Plane** (the brain) and one or more
**Worker Nodes** (where your Pods actually run).

### Control Plane components

| Component | Role |
|---|---|
| API Server | The front door — every `kubectl` command and internal component talks through it |
| etcd | Distributed key-value store; the cluster's single source of truth |
| Scheduler | Decides which node a new Pod should run on |
| Controller Manager | Runs control loops that keep actual state matching desired state |

### Worker Node components

| Component | Role |
|---|---|
| Kubelet | Agent on each node; talks to the API Server and manages containers on that node |
| Kube Proxy | Maintains network rules so Services can route traffic to Pods |
| Container Runtime | Actually runs containers (e.g. containerd) |

## Diagram

```text
Developer
   │
   ▼
kubectl
   │
   ▼
API Server
   │
   ▼
Control Plane
   │
   ▼
Scheduler
   │
   ▼
Worker Node
   │
   ▼
Kubelet
   │
   ▼
Container Runtime
   │
   ▼
Pod
```

## Example

Running `kubectl apply -f deployment.yaml`:
1. `kubectl` sends the request to the API Server.
2. The API Server validates it and writes the desired state to etcd.
3. The Scheduler notices unscheduled Pods and assigns them to a node.
4. The Kubelet on that node sees the assignment and tells the container
   runtime to start the containers.

## Common mistakes

- Thinking `kubectl` talks directly to nodes — it only ever talks to the API
  Server.
- Assuming the Scheduler starts containers — it only *decides placement*;
  the Kubelet actually starts them.

## Production considerations

- Control Plane is usually run with multiple replicas (HA) in production —
  losing the API Server or etcd is cluster-wide impact.
- etcd backups are critical — it is the entire state of the cluster.

## Interview questions

- What does the API Server do, and why is it the only thing `kubectl`
  talks to?
- What's the difference between the Scheduler's job and the Kubelet's job?
- Why is etcd so important to back up?
