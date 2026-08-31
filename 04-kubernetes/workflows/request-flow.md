# Request Flow (Client to Container)

## What it is
The path an external or internal request takes to reach a running
container.

## External request flow (via Ingress)

```text
Internet
   │
   ▼
Ingress Controller
   │
   ▼
Ingress Rules (host/path match)
   │
   ▼
Service
   │
   ▼
EndpointSlice (only Ready Pods)
   │
   ▼
Pod
   │
   ▼
Container
```

## Internal request flow (Pod to Pod, e.g. backend to database)

```text
Client Pod
   │
   ▼
Service DNS name (e.g. "mysql")
   │
   ▼
Kubernetes DNS resolves to Service ClusterIP
   │
   ▼
kube-proxy routing rules
   │
   ▼
EndpointSlice (only Ready Pods)
   │
   ▼
Target Pod
   │
   ▼
Container
```

## Key points

- A Service never proxies to a Pod that hasn't passed its readiness probe —
  this is exactly what keeps traffic away from a Pod mid-crash or mid-boot.
- DNS resolution to a ClusterIP is transparent to the application — this is
  why `DB_HOST=mysql` "just works."

## Common mistakes

- Assuming a request failure is a networking problem before checking
  whether the target Pod is even Ready.

## Interview questions

- Trace a request from the internet to a container, naming every hop.
- Why would a healthy-looking Pod never receive traffic?
