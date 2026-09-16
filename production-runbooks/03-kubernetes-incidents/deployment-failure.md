# Incident: Deployment Failure

## 1. Incident Summary
A Deployment rollout doesn't complete successfully — new pods fail to
become Ready, the rollout stalls, or it "completes" but the resulting
pods aren't actually healthy.

## 2. Symptoms
- `kubectl rollout status` hangs or reports the rollout isn't progressing
- New ReplicaSet's pods stuck `Pending`, `CrashLoopBackOff`, or `0/1 Ready`
- Old ReplicaSet's pods still running (good — means no full outage yet, but the deploy isn't done)
- Sometimes: rollout mechanically finishes but users see errors (see
  `01-http-errors/502-bad-gateway.md` for that variant)

## 3. Impact
Ranges from "deploy just doesn't finish, old version keeps serving fine"
(safe, annoying) to "old pods already terminated before new ones are
healthy" (real outage) depending on rollout strategy settings.

## 4. Possible Causes
- New image fails to pull (see ImagePullBackOff runbook)
- New image crashes on startup (see CrashLoopBackOff runbook)
- Readiness probe never passes for the new revision
- Resource requests for the new spec can't be scheduled (see Pod Pending runbook)
- A configuration/secret change required by the new version is missing
- `maxUnavailable`/`maxSurge` settings allow old pods to be killed before
  new ones are proven healthy

## 5. First 5 Minutes
1. `kubectl rollout status deployment/<name>` — is it progressing, stalled, or failed outright?
2. `kubectl get pods` — check new ReplicaSet's pod states
3. `kubectl describe pod <new-pod>` — get the specific failure reason
4. Check whether old pods are still serving traffic (confirms whether
   there's an active outage or just a stalled-but-safe rollout)
5. Check what actually changed in this deploy (image tag, env vars, resource requests)

## 6. Troubleshooting Flow
```
Deployment rollout not completing
      |
kubectl rollout status
      |
kubectl get pods (check new ReplicaSet pods)
      |
What state are new pods in?
      |
  Pending -----------> see Pod Pending runbook
  ImagePullBackOff ---> see ImagePullBackOff runbook
  CrashLoopBackOff ---> see CrashLoopBackOff runbook
  Running but NotReady -> check readiness probe / describe pod
      |
Find root cause
      |
Decide: fix forward, or rollback
```

## 7. Commands

```bash
kubectl rollout status deployment/<name>
```
**What it checks:** live progress of the current rollout.
**Why we run it:** immediately tells you if it's progressing, stuck, or already failed.
**What to look for:** "Waiting for deployment ... rollout to finish" stuck
for an unusually long time, or an explicit progress-deadline-exceeded error.

```bash
kubectl rollout history deployment/<name>
```
**What it checks:** revision history for the Deployment.
**Why we run it:** confirms which revision is the last known-good one to roll back to.
**What to look for:** the revision number immediately prior to the current failing one.

```bash
kubectl get pods -l app=<label>
```
**What it checks:** pod states across both old and new ReplicaSets.
**Why we run it:** tells you whether old pods are still serving (safe
stalled state) or already gone (active outage).
**What to look for:** mix of `Running` (old) and `Pending`/`CrashLoopBackOff` (new).

```bash
kubectl describe deployment <name>
```
**What it checks:** Deployment-level conditions and recent events.
**Why we run it:** often surfaces a summarized reason like "ReplicaSet has
timed out progressing" alongside more specific pod-level detail.
**What to look for:** `Conditions: ... ReplicaFailure`, `ProgressDeadlineExceeded`.

```bash
kubectl rollout undo deployment/<name>
```
**What it checks:** N/A — this is a remediation action.
**Why we run it:** fastest safe path back to a known-good state when the
new revision is confirmed broken.
**What to look for:** confirm `rollout status` afterward shows the
rollback completing successfully.
**⚠️ Use once you've confirmed the previous revision was actually healthy
— rolling back to another broken revision doesn't help.**

## 8. How to Interpret the Output
- Old pods still `Running`, new pods stuck → safe but stalled state; you
  have time to investigate without an active outage.
- Old pods already terminated, new pods unhealthy → active outage; prioritize rollback immediately.
- `ProgressDeadlineExceeded` condition → Kubernetes itself has flagged the
  rollout as failed based on the configured deadline, worth checking
  regardless of what pod states look like moment-to-moment.

## 9. Root Cause Examples
- New image has a startup bug (see CrashLoopBackOff)
- A new required ConfigMap/Secret key wasn't created before the deploy
- `maxUnavailable: 100%` (or similar aggressive setting) let all old pods
  terminate before any new pod proved healthy
- Readiness probe path changed in code but not updated in the manifest

## 10. Fix / Recovery
**Immediate mitigation:**
- Roll back if the previous revision was healthy: `kubectl rollout undo
  deployment/<name>`
- If old pods are still available and the issue is isolated to new ones,
  you may have time to fix forward instead — assess blast radius first

**Permanent fix:**
- Fix the actual root cause identified in the linked runbook
  (image, probe, config, resources)
- Set safer rollout parameters (`maxUnavailable: 0`, adequate
  `progressDeadlineSeconds`) so future bad rollouts fail safe

## 11. Verification
- `kubectl rollout status` reports success
- All pods in the new ReplicaSet `Running`/`Ready`
- Application-level checks (curl, dashboards) confirm real health, not
  just pod state

## 12. Prevention
- Use `maxUnavailable: 0` for user-facing services so a bad rollout never
  removes working capacity
- Add smoke tests as a required CI/CD gate before promoting a new image
- Keep readiness probes strict/accurate so Kubernetes itself catches bad
  rollouts before they take traffic
- Practice rollback as a routine, low-drama operation, not a last resort

## 13. Post-Incident Checklist
- [ ] Confirmed whether old pods were still serving during the incident
- [ ] Root cause identified via the specific pod-state runbook
- [ ] Rolled back or fixed forward, with rollout status confirmed successful
- [ ] Rollout strategy reviewed for safety (`maxUnavailable`, probes)
- [ ] Documented and linked to the underlying incident type

## 14. Interview Explanation
"Deployment failure is really a category — the actual root cause is
whatever is stopping the new pods from becoming Ready, which could be an
image pull issue, a crash, a scheduling issue, or a bad probe. My first
move is always checking whether old pods are still serving traffic, since
that tells me if this is an active outage or just a stalled-but-safe
rollout. Then I drill into the new ReplicaSet's pod state to identify
which specific failure mode I'm dealing with, and decide between rolling
back immediately or fixing forward based on blast radius."
