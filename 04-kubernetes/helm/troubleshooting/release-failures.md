# Troubleshooting: Release-Level Failures

## Release Stuck in `pending-upgrade` / `pending-install`

**Symptoms:**
```
helm status backend
STATUS: pending-upgrade
```
Any new `helm upgrade` fails with: `Error: UPGRADE FAILED: another operation (install/upgrade/rollback) is in progress`.

**Cause:** A previous `helm upgrade`/`install` was interrupted (network issue, CI runner killed, manual Ctrl+C) and never finished tracking state.

**Fix:**
```bash
helm history backend          # confirm the stuck revision
helm rollback backend <last-good-revision>
# or, if no good revision exists:
helm status backend --show-resources
```
Then retry the upgrade. As a last resort in dev/test, `helm delete backend --no-hooks` and reinstall (never do this to a production release without understanding what's live).

## Release Shows `failed` But Resources Are Actually Running

**Cause:** A hook (e.g. a `pre-upgrade` migration Job) failed after the main resources were already applied.

**Fix:**
```bash
kubectl get jobs
kubectl logs job/<hook-job-name>
```
Fix the underlying issue (e.g. bad migration), then re-run the upgrade — Helm will re-attempt the hook.

## Two Releases Fighting Over the Same Resources

**Symptoms:** `Error: rendered manifests contain a resource that already exists... Unable to continue with install`

**Cause:** A resource (e.g. a ConfigMap) was created outside Helm (via raw `kubectl apply`) with the same name Helm is trying to manage, or two charts/releases both try to own the same object name.

**Fix:** Either adopt the resource into Helm (`helm adopt` isn't a real command — instead, add the required Helm annotations/labels manually, or delete and let Helm recreate it), or rename one of the conflicting resources.
