# Incident: 502 Bad Gateway

## 1. Incident Summary
The proxy/load balancer (Nginx, ALB, Kubernetes Ingress controller)
received a request, tried to forward it to an upstream, and got an
invalid or no response — so it returned 502 to the client itself.

## 2. Symptoms
- Clients/users see "502 Bad Gateway"
- Error rate dashboards spike sharply
- May correlate with a recent deploy or pod restart
- Some requests succeed while others 502 (partial upstream failure) or all
  requests fail (total upstream failure)

## 3. Impact
User-facing outage or degradation for any request path routed through the
affected proxy/upstream. Severity depends on blast radius — one route, one
service, or the whole site.

## 4. Possible Causes
- Upstream application not running (pod crashed, container exited)
- Upstream listening on the wrong port vs what the proxy/Service expects
- Application not yet ready (still starting up) while already receiving traffic
- Upstream crashed mid-request
- Kubernetes Service pointing at pods that aren't actually healthy
- Connection refused because the app bound to `127.0.0.1` instead of `0.0.0.0`
- Upstream timeout misconfiguration causing the proxy to give up early
- TLS handshake failure between proxy and upstream (mTLS setups)

## 5. First 5 Minutes
1. Confirm the incident — reproduce with `curl -v` against the affected endpoint
2. Determine blast radius — one route, one service, or everything behind this proxy?
3. Check recent changes — deploy, config change, scaling event in the last 30-60 min
4. Check upstream health — are the backend pods/instances Running and Ready?
5. Check proxy logs — Nginx/Ingress controller logs usually show the exact
   upstream connection error

## 6. Troubleshooting Flow
```
Client sees 502
      |
Check proxy/load balancer logs
      |
Does proxy show "connection refused" / "no live upstreams"?
      |
   Yes -----------------------------+
      |                             |
Check Kubernetes Service/endpoints   Check upstream app process directly
      |                             |
No endpoints? -> pods not Ready      Process down? -> check container logs
      |                             |
Check pod status (kubectl get pods) Check application startup errors
      |
Find root cause
```

## 7. Commands

```bash
curl -v https://<host>/path
```
**What it checks:** whether the request actually reaches the proxy and what response comes back.
**Why we run it:** confirms the symptom directly and shows response headers that may hint at which layer answered (proxy vs app).
**What to look for:** the exact status line and any `X-` headers indicating which component generated the 502.

```bash
kubectl get pods -o wide
```
**What it checks:** are the upstream pods Running and Ready.
**Why we run it:** a 502 at the proxy layer usually traces back to no healthy upstream.
**What to look for:** `Running` but `0/1 Ready`, `CrashLoopBackOff`, or pods missing entirely.

```bash
kubectl get svc,endpoints <service>
```
**What it checks:** whether the Service has any endpoints (i.e., matching, Ready pods).
**Why we run it:** an empty `ENDPOINTS` column means the proxy has nowhere valid to send traffic — the direct cause of a 502/503.
**What to look for:** `<none>` under endpoints.

```bash
kubectl logs <pod> --tail 200
```
**What it checks:** application-level errors around the time of the incident.
**Why we run it:** find out if the app is crashing, refusing connections, or throwing exceptions.
**What to look for:** stack traces, "address already in use", "connection refused", startup failures.

```bash
ss -tulpn | grep <port>
```
**What it checks:** whether anything is actually listening on the expected port, on the host/container in question.
**Why we run it:** a common root cause is the app listening on the wrong port or wrong interface (`127.0.0.1` vs `0.0.0.0`).
**What to look for:** no listener at all, or a listener bound only to loopback.

## 8. How to Interpret the Output
- Proxy log shows `connect() failed (111: Connection refused)` → nothing is
  listening on the target port — check the app process and port binding.
- `kubectl get endpoints` shows `<none>` → Service selector doesn't match
  any Ready pod; fix labels or readiness.
- App logs show a clean startup with no errors, but 502s persist →
  suspect port/network mismatch between Service `targetPort` and container's
  actual listening port.
- 502s correlate exactly with a deploy timestamp → almost certainly the new
  revision, check its logs and readiness probe config.

## 9. Root Cause Examples
- New deployment's container listens on port 3000, but the Service
  `targetPort` still points to 8080 from the old version
- Readiness probe passes before the app has actually finished initializing
  its DB connection pool, so traffic arrives too early
- Pod OOMKilled mid-request, proxy gets a dropped connection
- App bound to `localhost` only, unreachable from the Service network
  namespace

## 10. Fix / Recovery
**Immediate mitigation:**
- Roll back to the previous known-good revision:
  `kubectl rollout undo deployment/<name>`
- Scale up replicas if only some pods are unhealthy, to shift traffic away
  from bad ones

**Permanent fix:**
- Correct the port mismatch in the Deployment/Service manifest
- Fix the readiness probe so it doesn't pass until the app can truly serve traffic
- Fix the bind address in application config (`0.0.0.0` not `127.0.0.1`)

## 11. Verification
- `curl` the endpoint repeatedly and confirm 200s
- `kubectl get endpoints` shows populated, healthy endpoints
- Error-rate dashboard returns to baseline
- No new 502s in proxy/ingress logs over a sustained window

## 12. Prevention
- Alert on upstream error rate (502/503 count), not just overall latency
- Add/strengthen readiness probes so traffic never reaches an unready pod
- CI validation step that checks Service `targetPort` matches container `containerPort`
- Use a rolling update strategy with `maxUnavailable: 0` for critical services

## 13. Post-Incident Checklist
- [ ] Confirmed scope and duration
- [ ] Identified whether cause was deploy-related or infra-related
- [ ] Applied mitigation (rollback/scale) if needed
- [ ] Root cause documented
- [ ] Fix merged (probe, port, or config correction)
- [ ] Alert/dashboard improved to catch this class of issue earlier

## 14. Interview Explanation
"502 means the proxy successfully received the request but couldn't get a
valid response from the upstream — so the first thing I check is whether
the upstream even has a healthy target to send traffic to. In Kubernetes
that's `kubectl get endpoints` — if it's empty, I look at pod readiness
next. If endpoints exist but I still see 502s, I check the actual
listening port and app logs, since a common cause is a Service/container
port mismatch or the app crashing mid-request."
