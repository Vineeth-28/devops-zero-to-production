# Services & Networking

## What it is
A Service is a stable network endpoint (fixed name/IP) in front of a set of
Pods, selected by labels.

## Why we use it
Pod IPs are not stable — Pods get replaced constantly (rollouts, crashes,
rescheduling). A Service gives clients something durable to talk to.

## How it works

- The Service `selector` matches Pod `labels`.
- Kubernetes DNS gives every Service a resolvable name
  (`<service-name>.<namespace>.svc.cluster.local`, or just `<service-name>`
  within the same namespace) — this is why `DB_HOST=mysql` works: `mysql`
  resolves to the Service's ClusterIP, which load-balances across the
  matching Pods.
- **EndpointSlices** track which Pod IPs are currently healthy and should
  receive traffic for a given Service.

## Request flow

```text
Client
   │
   ▼
Service
   │
   ▼
EndpointSlice
   │
   ▼
Pod
   │
   ▼
Container
```

## Service types

| Type | Use case |
|---|---|
| ClusterIP | Default; internal-only access |
| NodePort | Exposes a static port on every node (dev/testing) |
| LoadBalancer | Provisions an external cloud load balancer |
| ExternalName | Maps a Service name to an external DNS name (no proxying) |

## Ports explained

- `port`: the Service's own port, what clients connect to.
- `targetPort`: the container's actual listening port.
- `nodePort`: the static port opened on every node (NodePort/LoadBalancer
  types only).

## Common mistakes

- Selector doesn't match Pod labels — Service has zero endpoints and
  silently routes nowhere.
- Confusing `port` and `targetPort`, causing connection refused errors.

## Production considerations

- ClusterIP + Ingress is the standard production pattern for HTTP traffic;
  LoadBalancer per-Service gets expensive at scale (one cloud LB each).

## Interview questions

- Why doesn't Kubernetes just use Pod IPs directly?
- Explain the four Service types and when you'd use each.
- Why does `DB_HOST=mysql` work as a hostname inside the cluster?
