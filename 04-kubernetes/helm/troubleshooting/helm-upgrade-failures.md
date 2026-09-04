# Troubleshooting: Helm Upgrade Failures

## Scenario: Bad Environment Variable

```
helm upgrade
    ↓
Pod
    ↓
CrashLoopBackOff
```

**Problem:** Upgrade applies successfully, but the new pods crash on startup.

**Symptoms:**
- `helm history backend` shows the new revision as `deployed`
- `kubectl get pods` shows `CrashLoopBackOff`, restart count climbing

**Commands:**
```bash
helm get values backend
kubectl logs <pod-name>
kubectl describe pod <pod-name>
```

**Investigation:** `kubectl logs` shows the app crashing on boot — e.g. `Error: DATABASE_URL is not defined`.

**Root Cause:** A required env var was removed or misconfigured in the new `values-production.yaml` (via ConfigMap/Secret).

**Fix:**
```bash
helm rollback backend <previous-revision>
```
Then fix the values file and re-deploy properly.

**Verification:** `kubectl logs` shows clean startup, `kubectl get pods` shows `Running 1/1`.

---

## Scenario: Bad Readiness Probe

```
Pod Running
but
0/1 Ready
```

**Problem:** Pod is `Running` but never becomes `Ready` — so the Service never routes traffic to it, and (in a rolling upgrade) old pods never get terminated.

**Symptoms:**
- `kubectl get pods` shows `1/1 Running` under STATUS but `0/1` under READY
- Deployment rollout hangs (`kubectl rollout status` never completes)

**Commands:**
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

**Investigation:** `describe pod` events show repeated `Readiness probe failed: HTTP probe failed with statuscode: 404`.

**Root Cause:** `readinessProbe.path` in values doesn't match an actual route in the app (e.g. app exposes `/health` but chart is configured with `/ready`).

**Fix:** Correct `readinessProbe.path` in values (or fix the app's route) and `helm upgrade --install` again.

**Verification:** `kubectl get pods` shows `READY 1/1`; rollout completes.
