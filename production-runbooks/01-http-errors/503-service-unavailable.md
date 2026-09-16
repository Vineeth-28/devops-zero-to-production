# Incident: 503 Service Unavailable

## 1. Incident Summary
The proxy/load balancer has no healthy upstream to send traffic to at
all — as opposed to 502, where an upstream exists but returned garbage.
503 typically means zero available/healthy backends.

## 2. Symptoms
- All (or nearly all) requests to a route fail with 503
- Kubernetes Service shows no endpoints, or all endpoints are NotReady
- Often follows a bad deploy where every new pod fails readiness

## 3. Impact
Full or near-full outage for the affected route/service — worse than a
partial 502 situation since typically *no* traffic is getting through.

## 4. Possible Causes
- Kubernetes Service selector matches zero Ready pods
- Readiness probe failing on every replica
- Deployment rollout stuck (new pods failing, old pods already terminated)
- All backend instances behind a load balancer marked unhealthy by its
  health check
- Autoscaler scaled to zero unexpectedly
- Dependency (DB, cache) unavailable, causing every replica's readiness
  probe to fail simultaneously

## 5. First 5 Minutes
1. Confirm — is this affecting all traffic to the route, or intermittent?
2. Check pod count and status: `kubectl get pods`
3. Check Service endpoints: `kubectl get endpoints <service>`
4. Check recent rollout: `kubectl rollout status deployment/<name>`
5. Check whether a shared dependency (DB/cache) is also down — a
   single dependency outage can take down every replica's readiness at once

## 6. Troubleshooting Flow
```
503 from proxy/LB
      |
kubectl get endpoints <service>
      |
Empty? ---------------------------+
      |                           |
   Yes                            No (endpoints exist)
      |                           |
kubectl get pods                  Check LB/ingress health-check config
      |                           |
All NotReady? -> check probes     Health check hitting wrong path/port?
      |                           |
kubectl describe pod              Fix health check config
      |
Readiness probe failing why?
      |
Check app logs / dependency health
      |
Find root cause
```

## 7. Commands

```bash
kubectl get pods
```
**What it checks:** how many replicas exist and their Ready state.
**Why we run it:** 503 with no endpoints usually traces back to zero Ready pods.
**What to look for:** `0/1 Ready` across the board, or pod count of 0.

```bash
kubectl get svc <service>
kubectl get endpoints <service>
```
**What it checks:** Service configuration and its resolved endpoint list.
**Why we run it:** an empty endpoint list is the direct, mechanical cause
of 503 at the Service level.
**What to look for:** `ENDPOINTS: <none>`.

```bash
kubectl describe pod <pod>
```
**What it checks:** events, including readiness/liveness probe failures with reasons.
**Why we run it:** tells you exactly why a pod isn't Ready, not just that it isn't.
**What to look for:** `Readiness probe failed: HTTP probe failed with statuscode: 500`
or connection-refused style messages.

```bash
kubectl logs <pod>
```
**What it checks:** application-level errors that might explain a failing readiness check.
**Why we run it:** the probe failing is a symptom; the app logs usually
show the actual dependency or startup error.
**What to look for:** DB connection errors, unhandled exceptions on startup.

## 8. How to Interpret the Output
- Every pod shows `0/1 Ready` with the same probe failure reason →
  systemic issue (bad deploy or shared dependency down), not a single flaky pod.
- Endpoints list is empty but pods show `1/1 Ready` → check Service
  selector/labels — a labeling mismatch, not a pod health problem.
- LB-level 503 with Kubernetes endpoints looking fine → check the LB's own
  health-check path/port configuration, which may differ from the
  readiness probe's.

## 9. Root Cause Examples
- New deployment's readiness probe checks a `/health` endpoint the new
  version renamed to `/healthz` — every new pod fails Ready forever
- Shared database went down, so every replica's DB-dependent readiness
  check fails simultaneously
- HPA/manual scale-down set replicas to 0 during a maintenance change and
  wasn't reverted
- Service `selector` label doesn't match the Deployment's pod template
  labels after a manifest refactor

## 10. Fix / Recovery
**Immediate mitigation:**
- Roll back to the previous Deployment revision if the issue started with a deploy:
  `kubectl rollout undo deployment/<name>`
- Scale replicas back up if scaled to 0
- If the dependency is down, focus mitigation there — fixing the app won't help

**Permanent fix:**
- Correct the readiness probe path/port to match the actual application
- Fix Service selector/label mismatch
- Add dependency-failure handling so the app degrades gracefully instead
  of failing readiness entirely (where appropriate)

## 11. Verification
- `kubectl get endpoints` shows a non-empty, healthy list
- `curl` against the route returns 200s consistently
- Error-rate/availability dashboard recovers to baseline

## 12. Prevention
- Alert on `endpoint count == 0` for critical Services, not just error rate
- CI check that validates readiness probe paths exist and return 200 before merge
- Avoid single points of failure for shared dependencies used by readiness checks
- Use `maxUnavailable: 0` / `maxSurge` sensibly so a bad rollout can't take
  every replica down at once

## 13. Post-Incident Checklist
- [ ] Confirmed all replicas affected vs partial
- [ ] Identified whether cause was deploy, scaling, or dependency
- [ ] Endpoints restored and verified
- [ ] Root cause documented
- [ ] Probe/selector/scaling fix merged
- [ ] Alerting added for zero-endpoint condition

## 14. Interview Explanation
"503 usually means there's no healthy upstream at all, which in
Kubernetes I check with `kubectl get endpoints` — an empty list is the
direct cause. From there I check whether pods exist and are Ready; if not,
`describe pod` tells me why the readiness probe is failing, which usually
traces back to either a bad deploy (wrong probe path, broken startup) or a
shared dependency being down and taking every replica's readiness with
it."
