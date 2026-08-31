# Ingress

## What it is
Ingress is an API object that manages external HTTP/HTTPS access to
Services inside the cluster, including host- and path-based routing.

## Why we use it
Without Ingress, exposing multiple HTTP services externally means either
one LoadBalancer Service per app (expensive, one external IP each) or
NodePort (clunky). Ingress lets one entry point route to many Services
based on hostname/path.

## How it works

- An **Ingress resource** declares the routing rules (host/path ->
  Service).
- An **Ingress Controller** (e.g. nginx-ingress, deployed separately) is
  what actually implements those rules — the Ingress object does nothing
  on its own without a controller watching it.

## Diagram

```text
Internet
   │
   ▼
Ingress
   │
   ▼
Service
   │
   ▼
Pod
```

## Example

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: backend-ingress
spec:
  ingressClassName: nginx
  rules:
    - host: api.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: backend
                port:
                  number: 80
```

## Host routing vs Path routing

- **Host routing**: different domains (`api.example.com`,
  `admin.example.com`) route to different Services.
- **Path routing**: different paths on the *same* domain
  (`example.com/api`, `example.com/admin`) route to different Services.

## Common mistakes

- Creating an Ingress resource with no Ingress Controller installed —
  nothing happens; the rules are never actually enforced.
- Forgetting `pathType` or getting `Prefix` vs `Exact` wrong, causing
  routes to not match as expected.

## Production considerations

- TLS termination is usually configured at the Ingress layer
  (`tls:` block + cert-manager) rather than in each backend application.

## Interview questions

- What's the difference between an Ingress resource and an Ingress
  Controller?
- Host-based vs path-based routing — when would you use each?
- Why is Ingress generally preferred over one LoadBalancer Service per app?
