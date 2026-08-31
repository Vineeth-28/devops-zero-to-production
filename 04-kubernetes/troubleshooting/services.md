# Troubleshooting: Services

## Service Not Working — flow

```text
Service
   │
   ▼
Selector
   │
   ▼
Pod labels
   │
   ▼
Ready endpoints
   │
   ▼
Ports
   │
   ▼
Application
```

## Commands

```bash
kubectl get svc
kubectl describe svc <name>
kubectl get pods --show-labels
kubectl get endpointslices
kubectl get endpointslices -l kubernetes.io/service-name=<service-name>
```

## Step-by-step checks

1. **Selector vs labels** — does the Service's `selector` actually match
   the labels on the Pods you expect it to route to?
   ```bash
   kubectl get pods --show-labels
   kubectl describe svc <name> | grep Selector
   ```
2. **Endpoints exist** — if `endpointslices` is empty, the selector matched
   nothing, or no matching Pod is Ready.
   ```bash
   kubectl get endpointslices -l kubernetes.io/service-name=<name>
   ```
3. **Readiness** — a Pod with a failing readiness probe is excluded from
   endpoints even if it matches the selector.
4. **Ports** — confirm `port`/`targetPort` on the Service actually match
   the container's listening port.
5. **Application itself** — once endpoints and ports are confirmed correct,
   test the app directly:
   ```bash
   kubectl exec -it <pod-name> -- curl localhost:<targetPort>/health
   ```

## Common mistakes

- Debugging DNS/networking first when the actual issue is a selector/label
  mismatch — always check endpoints before anything else.
- Confusing "Service has endpoints" with "application is healthy" — these
  are two separate checks.

## Production considerations

- An empty EndpointSlices list is one of the single most common root
  causes of "my app is unreachable" — check it early, every time.
