# Interview Questions — Networking

**Q1. Why do we need Services if Pods already have IP addresses?**
Expected answer points:
- Pod IPs are not stable — Pods are recreated constantly (crashes,
  rollouts, rescheduling).
- A Service gives a fixed name/IP that stays constant regardless of which
  Pods are currently backing it.

**Q2. Explain the four Service types.**
Expected answer points:
- ClusterIP — default, internal-only.
- NodePort — static port on every node, mostly dev/testing.
- LoadBalancer — provisions an external cloud load balancer.
- ExternalName — DNS alias to an external name, no proxying involved.

**Q3. Walk through the request flow from Client to Container.**
Expected answer points:
- Client -> Service -> EndpointSlice -> Pod -> Container.
- Service uses `selector` matching Pod `labels` to determine membership.
- EndpointSlices track only the currently *Ready* Pods.

**Q4. Why does `DB_HOST=mysql` work as a hostname inside Kubernetes?**
Expected answer points:
- Kubernetes DNS automatically resolves a Service name to its ClusterIP
  within the same namespace.
- No manual DNS configuration is needed — this is built into cluster DNS
  (e.g. CoreDNS).

**Q5. `port` vs `targetPort` vs `nodePort` — what's the difference?**
Expected answer points:
- `port`: the Service's own port that clients connect to.
- `targetPort`: the container's actual listening port.
- `nodePort`: static port opened on every node (NodePort/LoadBalancer
  types only).

**Q6. A Service seems to be "not working" — what's your troubleshooting
order?**
Expected answer points:
- Check selector vs Pod labels match.
- Check EndpointSlices aren't empty.
- Check readiness — a matching-but-not-Ready Pod is excluded from
  endpoints.
- Check ports (`port`/`targetPort`) match the container.
- Only then investigate the application itself.
