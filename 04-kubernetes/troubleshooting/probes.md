# Troubleshooting: Probes

## Symptom: Pod shows `0/1 Ready` but is Running

```bash
kubectl describe pod <pod-name>
```
Look at the `Readiness` section of the probe output and recent `Events` for
probe failure messages.

## Step-by-step checks

1. **Path/port correctness** — does the readiness probe's `path`/`port`
   actually match a real endpoint in the running application?
2. **Dependencies** — if the readiness check verifies DB/downstream
   connectivity, is that dependency actually reachable from this Pod?
3. **Timing** — is `initialDelaySeconds` too short for the app's real
   startup time (without a `startupProbe` to cover it)?
4. **Manual verification** — exec into the Pod and hit the endpoint
   directly:
   ```bash
   kubectl exec -it <pod-name> -- curl localhost:<port><path>
   ```

## Symptom: Pod keeps restarting due to liveness failures

- Check whether the liveness check is too strict or checks a slow
  downstream dependency — liveness should reflect "is this process
  fundamentally broken," not "is something upstream slow right now."
- Consider whether a `startupProbe` is needed to protect a slow boot phase
  from being killed by liveness before the app has even finished starting.

## Common mistakes

- Reusing the same check/endpoint for liveness and readiness — a slow (but
  recoverable) dependency should affect readiness, not trigger a
  liveness-driven restart.
- No `startupProbe` on apps with long/variable startup time.

## Production considerations

- Probe failures are one of the most common causes of "it's Running but
  not receiving traffic" — always check readiness probe status before
  assuming a networking problem.
