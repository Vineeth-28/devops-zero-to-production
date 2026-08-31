# Service Commands

## What it is
Commands to create and inspect Services — the stable network identity in
front of a set of Pods.

## Why we use it
Pod IPs change constantly; Services give a fixed way to reach them.

## Commands

```bash
kubectl apply -f service.yaml
kubectl get svc
kubectl get svc -o wide
kubectl describe svc <name>

kubectl get endpointslices
kubectl get endpointslices -l kubernetes.io/service-name=<service-name>

kubectl expose deployment <name> --port=80 --target-port=3000 --type=ClusterIP
```

## Example

```bash
kubectl describe svc backend
```
Shows the Service's selector, ports, and endpoints — the first place to
check when "the Service isn't working."

## Common mistakes

- Selector in the Service doesn't match the Pod's labels — Service has zero
  endpoints and silently sends nothing anywhere.
- Confusing `port` (the Service's own port) with `targetPort` (the
  container's port).

## Production considerations

- An empty `Endpoints`/`EndpointSlices` list is one of the most common
  "my app is unreachable" root causes — always check it first.

## Interview questions

- How do you find out which Pods a Service is actually routing to?
- What happens if a Service's selector doesn't match any Pod labels?
- Difference between `port`, `targetPort`, and `nodePort`?
