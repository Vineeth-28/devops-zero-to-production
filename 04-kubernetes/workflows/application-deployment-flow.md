# Application Deployment Flow

## What it is
The end-to-end path from applying a manifest to Pods serving traffic.

## Flow

```text
Developer
   │
   ▼
kubectl apply -f deployment.yaml
   │
   ▼
API Server (validates, writes to etcd)
   │
   ▼
Deployment Controller creates/updates ReplicaSet
   │
   ▼
ReplicaSet Controller creates Pod objects
   │
   ▼
Scheduler assigns each Pod to a Node
   │
   ▼
Kubelet on that Node pulls the image
   │
   ▼
Container Runtime starts the container
   │
   ▼
Kubelet reports Pod status back to API Server
   │
   ▼
Readiness Probe passes
   │
   ▼
Pod added to Service EndpointSlices
   │
   ▼
Pod receives traffic
```

## Key points

- A Pod being `Running` does not mean it's receiving traffic — that only
  happens once it also passes its readiness probe and is added to
  EndpointSlices.
- `kubectl apply` returns almost immediately; the actual rollout happens
  asynchronously — always confirm with `kubectl rollout status`.

## Common mistakes

- Treating `kubectl apply` succeeding as confirmation the deploy is live
  and healthy.

## Interview questions

- At what point does a newly deployed Pod actually start receiving
  traffic?
- What's the difference between a Pod being `Running` and being `Ready`?
