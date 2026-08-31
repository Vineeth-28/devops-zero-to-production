# Troubleshooting: Networking

## Symptom: Pod-to-Pod / Pod-to-Service communication failing

```bash
kubectl run debug --image=busybox -it --rm -- /bin/sh
# inside the debug pod:
nslookup <service-name>
wget -O- http://<service-name>:<port>/health
```

## Step-by-step checks

1. **DNS resolution** — does `<service-name>` resolve at all?
   - If not: check the Service actually exists in the same namespace you're
     testing from, or use the fully qualified name
     `<service>.<namespace>.svc.cluster.local`.
2. **Endpoints** — does the Service have healthy endpoints?
   ```bash
   kubectl get endpointslices -l kubernetes.io/service-name=<name>
   ```
3. **NetworkPolicy** — is a NetworkPolicy blocking traffic between these
   Pods/namespaces?
   ```bash
   kubectl get networkpolicy -A
   ```
4. **Port mismatch** — confirm `targetPort` matches what the container
   actually listens on.
5. **Node-level networking** — check CNI plugin health / node conditions if
   the problem is cluster-wide rather than one Service.

## Common mistakes

- Assuming `localhost` works between containers in *different* Pods — it
  only works between containers *within the same Pod*.
- Testing from outside the cluster when the failure is actually
  internal-only (Pod-to-Pod) — always test from inside first with a debug
  Pod.

## Production considerations

- NetworkPolicies default to "allow all" unless policies are defined —
  once you add your first NetworkPolicy in a namespace, traffic not
  explicitly allowed is denied, which can silently break existing traffic.
