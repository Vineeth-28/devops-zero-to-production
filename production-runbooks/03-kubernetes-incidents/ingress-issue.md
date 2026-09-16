# Incident: Ingress Issue

## 1. Incident Summary
External traffic can't reach an application through its Ingress — the
failure could be in DNS, the load balancer, the Ingress controller, the
Ingress rule itself, or the backend Service it points to.

## 2. Symptoms
- External requests fail (timeout, wrong response, TLS error, 404 from
  the Ingress controller itself, or 502/503/504 — see the relevant runbook
  for those)
- Internal cluster traffic to the same backend Service works fine (points
  at the Ingress layer specifically, not the app)

## 3. Impact
External-facing outage even if internal service-to-service traffic and
the application itself are completely healthy.

## 4. Possible Causes
- DNS not pointing at the correct load balancer/IP
- TLS certificate expired, missing, or misconfigured
- Ingress resource's backend Service name/port doesn't match the actual Service
- Ingress controller itself unhealthy or misconfigured
- Annotation misconfiguration (rewrite rules, timeout settings, auth annotations)
- Path-based routing rule doesn't match the request path as expected

## 5. Full Path
```
Internet
  |
DNS
  |
Load Balancer
  |
Ingress Controller
  |
Ingress Rule
  |
Service
  |
Pod
```
Each layer can independently fail. The key diagnostic question at every
step is: does traffic even reach this layer, and if so, does it get
forwarded correctly to the next one?

## 6. First 5 Minutes
1. Confirm DNS resolves to the expected load balancer IP/hostname: `dig <hostname>`
2. Confirm the load balancer itself is healthy (cloud console / `kubectl get svc` for LoadBalancer type)
3. Check Ingress controller pod health and logs
4. Check the Ingress resource's rules against what you expect: `kubectl describe ingress`
5. Test the backend Service directly (bypassing Ingress) to isolate whether it's an Ingress-layer problem specifically

## 7. Troubleshooting Flow
```
External request fails
      |
dig <hostname> — does DNS resolve correctly?
      |
   No -> fix DNS record
      |
   Yes
      |
Is the Load Balancer healthy? (cloud console / kubectl get svc)
      |
   No -> investigate LB/cloud provider issue
      |
   Yes
      |
kubectl get pods -n <ingress-namespace> (controller healthy?)
      |
   No -> investigate controller crash/config
      |
   Yes
      |
kubectl describe ingress <name> (rules correct? backend matches?)
      |
   Rules wrong -> fix Ingress resource
      |
   Rules look right -> test backend Service directly (bypass Ingress)
      |
   Backend fine directly -> Ingress-controller-to-Service routing issue
   Backend fails too -> see Service Not Working runbook
```

## 8. Commands

```bash
dig <hostname>
```
**What it checks:** DNS resolution for the hostname the Ingress is meant to serve.
**Why we run it:** rules out (or confirms) a DNS-layer problem before
looking anywhere else.
**What to look for:** resolves to an unexpected IP, or doesn't resolve at all.

```bash
kubectl get ingress <name> -o yaml
kubectl describe ingress <name>
```
**What it checks:** the Ingress resource's rules, backend Service/port,
TLS config, and recent events.
**Why we run it:** confirms the routing rule actually matches the
request's host/path and points at the correct Service/port.
**What to look for:** backend `serviceName`/`servicePort` not matching the
actual Service name/port; missing or wrong TLS secret reference.

```bash
kubectl get pods -n <ingress-controller-namespace>
kubectl logs -n <ingress-controller-namespace> <controller-pod>
```
**What it checks:** health of the Ingress controller itself (e.g. Nginx
ingress controller, ALB controller).
**Why we run it:** a crashing/misconfigured controller can't route
anything, regardless of how correct your Ingress resource is.
**What to look for:** controller crash-looping, or logs showing rule
reload errors or upstream connection failures.

```bash
curl -v -H "Host: <hostname>" http://<service-cluster-ip-or-podip>:<port>/
```
**What it checks:** whether the backend Service/pod responds correctly
when accessed directly, bypassing Ingress entirely.
**Why we run it:** isolates the problem to the Ingress layer specifically
if this direct request succeeds.
**What to look for:** success here + failure through the Ingress
hostname = the problem is squarely in Ingress config or the controller.

## 9. How to Interpret the Output
- DNS resolves correctly, but the load balancer's health check fails →
  problem is at the LB or the Ingress controller's readiness, not the app.
- Ingress rule references the wrong `servicePort` (e.g. 80 instead of the
  Service's actual 8080) → simple config fix.
- Direct-to-Service curl works, but through the Ingress hostname it
  doesn't → Ingress controller routing/annotation issue, isolate there.
- TLS handshake failure → check certificate validity/expiry and that the
  correct TLS secret is referenced in the Ingress resource.

## 10. Root Cause Examples
- DNS record still points at an old/decommissioned load balancer after an
  infrastructure migration
- TLS certificate expired and auto-renewal (e.g. cert-manager) silently failed
- Ingress resource references `myservice` but the actual Service was
  renamed to `myservice-v2`
- A rewrite-target annotation was misconfigured, causing requests to hit
  the wrong backend path

## 11. Fix / Recovery
**Immediate mitigation:**
- Correct the DNS record if it's stale
- Manually renew/replace the TLS certificate if expired and automation failed
- Fix the Ingress resource's Service/port reference and reapply

**Permanent fix:**
- Fix and re-verify cert-manager (or equivalent) automation for TLS renewal
- Add CI validation that Ingress backend references match actual Service names/ports
- Document DNS ownership/change process to prevent stale records after migrations

## 12. Verification
- `dig` confirms correct DNS resolution
- `curl` through the actual public hostname succeeds with expected TLS and response
- No new errors in Ingress controller logs over a sustained window

## 13. Prevention
- Alert on TLS certificate expiry well ahead of time (30/14/7 day warnings)
- Monitor Ingress controller health independently from backend application health
- CI validation of Ingress resource correctness before merge
- Document the full DNS → LB → Ingress → Service → Pod chain for the team

## 13a. Post-Incident Checklist
- [ ] DNS resolution confirmed correct
- [ ] Load balancer and Ingress controller health confirmed
- [ ] Ingress resource rules verified against actual Service/port
- [ ] TLS certificate validity confirmed
- [ ] Root cause documented and prevention item identified

## 14. Interview Explanation
"An Ingress issue could be at any of several independent layers — DNS,
load balancer, the Ingress controller, the Ingress rule itself, or the
backend Service. I work through them in order from the outside in: DNS
resolution first, then load balancer/controller health, then the actual
Ingress rule's backend reference, and finally I test the backend Service
directly to confirm whether the app itself is fine and the problem is
purely in the routing layer. That direct-vs-through-Ingress comparison is
usually the fastest way to isolate exactly where it's broken."
