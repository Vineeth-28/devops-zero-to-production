# Day 24 — Services, Networking & DNS Lab

## Objective
Understand how Services solve the "Pod IPs are unstable" problem, and how
Kubernetes DNS and EndpointSlices work together.

## Concepts

- Service types: ClusterIP, NodePort, LoadBalancer, ExternalName
- Labels/selectors, EndpointSlices
- Kubernetes DNS and why `DB_HOST=mysql` works

## Commands Practiced

```bash
kubectl apply -f ../../manifests/service-clusterip.yaml
kubectl apply -f ../../manifests/service-nodeport.yaml
kubectl get svc
kubectl describe svc backend
kubectl get endpointslices
kubectl get pods --show-labels
kubectl run debug --image=busybox -it --rm -- /bin/sh
```

## Hands-on Tasks

1. Apply the Deployment and ClusterIP Service from `manifests/`. Confirm
   `kubectl get endpointslices` shows the Pod IPs.
2. Deliberately edit the Service's selector to something that matches no
   Pods, re-apply, and confirm endpoints becomes empty. Revert it.
3. From inside a debug Pod (`kubectl run debug --image=busybox -it --rm
   -- /bin/sh`), `nslookup backend` and `wget -O- http://backend/health`
   to prove DNS + Service routing works from inside the cluster network.
4. Apply the NodePort Service and access it via `<node-ip>:<nodePort>`
   (or via `minikube service` if using Minikube).
5. Scale the Deployment down to 0 replicas and watch endpoints go empty —
   then scale back up and watch them repopulate.

## Expected Outcome

You can explain and demonstrate the full `Client -> Service ->
EndpointSlice -> Pod -> Container` flow, and confidently debug "Service
not working" using selector/labels/endpoints checks.

## Interview Questions

- Why doesn't Kubernetes just use Pod IPs directly?
- Explain the four Service types and when you'd use each.
- Why does `DB_HOST=mysql` work as a hostname inside the cluster?

## Common Mistakes

- Selector/label mismatch causing silently empty endpoints.
- Confusing `port` and `targetPort`.

## Key Takeaways

- A Service with zero endpoints is the single most common root cause of
  "my app is unreachable" inside the cluster — always check it first.
