# Incident: Pod CrashLoopBackOff

## 1. Incident Summary
Kubernetes is repeatedly trying to start a container that keeps exiting.
After enough failures, Kubernetes backs off the restart interval and
reports the pod as `CrashLoopBackOff`. This is a **state**, not a root
cause — the actual reason can be almost anything.

## 2. Symptoms
- `kubectl get pods` shows `CrashLoopBackOff`
- Restart count climbing
- Service backed by this pod may be degraded/unavailable if all replicas
  are affected

## 3. Impact
Depends on how many replicas are affected and whether other healthy
replicas can absorb traffic. Total outage if all replicas of a Deployment
are crash-looping.

## 4. Possible Causes
- Application crashes immediately on startup (bad config, missing
  environment variable, unhandled exception)
- Missing or misconfigured secret/configmap the app depends on at startup
- Liveness probe killing the container before/during legitimate slow startup
- A required dependency (database, downstream service) not yet reachable,
  and the app doesn't retry gracefully — it exits instead
- Non-zero exit code from an intentional application check (e.g. failed migration)

## 5. First 5 Minutes
1. Confirm scope: how many pods/replicas affected
2. Get the exit code and reason: `kubectl describe pod`
3. Get logs from the **current failing attempt** and, critically, the
   **previous** one: `kubectl logs --previous`
4. Check recent changes — did this start right after a deploy or config change?
5. Check if a dependency (DB, downstream API) is also unhealthy at the same time

## 6. Troubleshooting Flow
```
CrashLoopBackOff
      |
kubectl describe pod (check exit code + events)
      |
kubectl logs --previous (see why the LAST attempt crashed)
      |
Clear application error in logs? ------------------+
      |                                             |
   Yes                                              No — need more context
      |                                             |
Fix the underlying cause                     Check env vars / secrets / configmap
(bad config, missing dependency, bug)         Check liveness probe settings
                                               Check dependency health
                                                     |
                                              Find root cause
```

## 7. Commands

```bash
kubectl get pods
```
**What it checks:** which pods are in CrashLoopBackOff and their restart count.
**Why we run it:** confirms scope and how long this has been happening.
**What to look for:** restart count still climbing (active issue) vs stable (resolved but not yet cleared).

```bash
kubectl describe pod <pod>
```
**What it checks:** last termination state, exit code, and recent events.
**Why we run it:** the exit code and event history are the fastest route
to a hypothesis — e.g. exit code 1 (app error) vs 137 (SIGKILL, often OOM)
vs 143 (SIGTERM).
**What to look for:** `Last State: Terminated, Reason: Error, Exit Code: 1`
(or similar), and any probe-failure events.

```bash
kubectl logs <pod>
kubectl logs <pod> --previous
```
**What it checks:** stdout/stderr from the current and previous container attempt.
**Why we run it:** `--previous` is essential — by the time you look,
Kubernetes may already be on a new (also-failing) attempt whose logs are
too short to be useful; the previous attempt's logs usually show the
actual crash.
**What to look for:** stack traces, "connection refused", missing
environment variable errors, explicit application error messages.

```bash
kubectl get pod <pod> -o yaml | less
```
**What it checks:** full pod spec including env vars, volume mounts, probe config.
**Why we run it:** confirms whether a required env var/secret/configmap is
actually present and correctly referenced.
**What to look for:** missing or misnamed `envFrom`/`valueFrom` references.

## 8. How to Interpret the Output
- Exit code `1` (or another app-specific non-zero code) with a clear stack
  trace in `--previous` logs → application-level bug or bad config; fix the code/config.
- Exit code `137` → the container was killed (often OOM, sometimes
  externally) — cross-check with the Memory Issue runbook.
- No error in application logs at all, but repeated restarts → suspect the
  liveness probe itself is misconfigured (too strict timing, wrong path)
  and killing a healthy-but-slow-starting container.
- Logs show a clear "cannot connect to database" on every attempt →
  dependency issue, not an application bug per se.

## 9. Root Cause Examples
- A required environment variable was renamed in code but not updated in the Deployment manifest
- Liveness probe's `initialDelaySeconds` too short for a slow-starting JVM app
- Database migration step in the startup sequence failing due to a schema conflict
- A ConfigMap was updated but pods weren't restarted to pick up the new mount content, causing a mismatch the app can't handle

## 10. Fix / Recovery
**Immediate mitigation:**
- If the previous revision was stable, roll back:
  `kubectl rollout undo deployment/<name>`
- If it's a probe misconfiguration, adjust `initialDelaySeconds`/`timeoutSeconds` and reapply

**Permanent fix:**
- Correct the underlying application/config bug identified in logs
- Fix probe timing to match actual, realistic startup behavior
- Add graceful retry/backoff in the application for dependencies that may
  not be ready yet, instead of crashing immediately

## 11. Verification
- `kubectl get pods` shows `Running` and `Ready` with restart count stable
- Application logs show a clean, successful startup sequence
- Downstream service/endpoint traffic recovers to baseline

## 12. Prevention
- CI validation that required env vars/secrets are present before deploy
- Set realistic liveness probe timing based on measured startup time, not guesses
- Add startup/graceful-retry logic for dependency connections
- Alert on restart-count rate, not just absolute CrashLoopBackOff state, to catch this earlier

## 13. Post-Incident Checklist
- [ ] Confirmed exit code and root cause from `--previous` logs
- [ ] Ruled out probe misconfiguration vs genuine application bug
- [ ] Applied rollback or fix
- [ ] Verified stable `Running`/`Ready` state
- [ ] Root cause documented, prevention item identified

## 14. Interview Explanation
"CrashLoopBackOff tells me the container keeps exiting and Kubernetes is
backing off restarts — it doesn't tell me why. The first thing I always do
is `kubectl describe pod` for the exit code and events, then `kubectl
logs --previous`, because by the time I look, the current attempt's logs
might be too short. The exit code narrows it down fast — 137 points at
OOM, an app-specific code with a stack trace points at a bug or bad
config, and if the logs are completely clean I start suspecting the
liveness probe itself is killing an otherwise-healthy, slow-starting
container."
