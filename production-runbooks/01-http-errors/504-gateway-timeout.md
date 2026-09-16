# Incident: 504 Gateway Timeout

## 1. Incident Summary
The proxy/load balancer forwarded the request to a live upstream, but the
upstream didn't respond within the configured timeout — so the proxy gave
up and returned 504. Unlike 502/503, the upstream is reachable; it's just
too slow.

## 2. Symptoms
- Requests hang for the full timeout duration, then fail with 504
- Latency dashboards show elevated p95/p99 before the 504s appear
- Often isolated to specific endpoints (the slow ones) rather than the
  whole service

## 3. Impact
Degraded user experience or partial outage for slow endpoints/operations.
Often narrower in blast radius than 502/503 since it's usually
request-shape-dependent (e.g. only large-payload or DB-heavy requests).

## 4. Possible Causes
- Application itself is slow (inefficient code path, N+1 queries)
- Downstream dependency (database, third-party API) is slow or hanging
- Network problem causing latency between proxy and upstream, or upstream
  and its dependency
- Connection pool exhaustion causing requests to queue before being served
- Load balancer/proxy timeout set too aggressively for a legitimately
  slow-but-valid operation
- Kubernetes networking issue (CNI, DNS latency) adding overhead

## 5. First 5 Minutes
1. Confirm — which endpoints/routes are timing out, and since when?
2. Check p95/p99 latency on the affected service — is it the app, or the
   whole path?
3. Check recent changes — deploy, config, dependency version bump
4. Check the downstream dependency's own health/latency (DB, external API)
5. Check whether this is a proxy-configured timeout that's simply too
   short for a valid slow operation, vs an actual regression

## 6. Troubleshooting Flow
```
504 Gateway Timeout
      |
Check upstream latency (app metrics / logs)
      |
Is the app itself slow?
      |
   Yes ----------------------------+
      |                            |
Check dependency latency            No -> check network path
(DB queries, external API calls)    proxy <-> upstream, upstream <-> dependency
      |                            |
Slow query / slow API? -> found it  Network latency/packet loss? -> found it
      |
Find root cause
```

## 7. Distinguishing app-slow vs network-problem vs dependency-problem
- **Application slow**: app's own request-duration metric (measured
  inside the app) is high — confirms the time is spent in application code.
- **Network problem**: app's own request-duration metric looks normal, but
  the proxy's measured latency to the app is much higher — time is being
  lost in transit, not in the app.
- **Dependency problem**: app's request-duration is high specifically for
  requests that call the slow dependency; requests that don't touch it are fast.

## 8. Commands

```bash
curl -o /dev/null -s -w 'time_total: %{time_total}\n' <url>
```
**What it checks:** end-to-end request time from the client's perspective.
**Why we run it:** confirms and quantifies the symptom directly.
**What to look for:** time approaching or exceeding the proxy's configured timeout.

```bash
kubectl logs <pod> --tail 200
```
**What it checks:** application-level timing/errors around the timeout window.
**Why we run it:** the app may log its own slow-query or slow-dependency-call warnings.
**What to look for:** slow query logs, timeout exceptions calling a downstream service.

```bash
kubectl top pod
```
**What it checks:** current CPU/memory usage per pod.
**Why we run it:** resource saturation (CPU throttling especially) can
manifest as slow responses rather than outright failures.
**What to look for:** CPU usage pinned at its limit, indicating throttling.

```bash
# Check the proxy/ingress's configured timeout
kubectl describe ingress <name>
```
**What it checks:** annotations like `nginx.ingress.kubernetes.io/proxy-read-timeout`.
**Why we run it:** rules out "timeout is just set too short" before assuming a regression.
**What to look for:** a timeout value shorter than the operation's legitimate expected duration.

## 9. How to Interpret the Output
- App's internal request-duration metric matches the 504 timeout window
  closely → the app (or its dependency) is genuinely slow.
- App's internal metric is fast, but the proxy still reports 504 → suspect
  network path or proxy misconfiguration, not the app.
- CPU pinned at the pod's limit during the incident → throttling is adding
  latency; scale up or raise limits.

## 10. Root Cause Examples
- A new feature added an unindexed database query that's slow under
  production data volume
- A downstream third-party API started responding slowly, and calls to it
  aren't wrapped in an aggressive-enough client-side timeout
- CPU limits set too low for the workload, causing CFS throttling and
  added latency under load
- Ingress `proxy-read-timeout` set to the platform default (60s) while a
  legitimate report-generation endpoint needs 90s

## 11. Fix / Recovery
**Immediate mitigation:**
- If a specific dependency is slow, consider a circuit breaker/fallback if
  one exists, or scale that dependency
- Increase proxy timeout temporarily if the operation is legitimately slow
  and correctness matters more than speed (only as a stopgap)
- Scale up replicas if throttling/saturation is the cause

**Permanent fix:**
- Fix the slow query (add an index, batch N+1 calls)
- Add/adjust client-side timeouts and retries around flaky dependencies
- Right-size CPU requests/limits based on real usage data
- Set endpoint-appropriate timeouts rather than one global value for every route

## 12. Verification
- p95/p99 latency returns to baseline
- 504 count drops to zero in proxy/ingress logs
- Confirm no CPU throttling metric spikes during a follow-up load window

## 13. Prevention
- Alert on p95/p99 latency, not just error rate — timeouts are a latency
  problem before they're an error-count problem
- Add dependency-call timeouts and circuit breakers so one slow dependency
  can't hang the whole request
- Capacity-test new features against production-scale data before rollout
- Review CPU limits against actual usage regularly

## 14. Interview Explanation
"504 means the proxy reached the upstream fine but the upstream didn't
respond in time — so my first move is figuring out whether the app itself
is slow, a downstream dependency is slow, or it's a network/timeout
configuration issue. I compare the app's own internally measured request
duration against the proxy's timeout: if they match, the app or its
dependency is genuinely slow; if the app looks fast internally but the
proxy still times out, I look at the network path or the timeout
configuration itself."
