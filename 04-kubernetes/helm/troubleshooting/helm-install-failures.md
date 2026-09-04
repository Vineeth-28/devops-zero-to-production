# Troubleshooting: Helm Install Failures

## Scenario: Bad Image Tag

```
helm install
    ↓
Pod
    ↓
ImagePullBackOff
```

**Problem:** Install "succeeds" (Helm reports the release as deployed) but pods never become ready.

**Symptoms:**
- `helm status backend` shows `STATUS: deployed`
- `kubectl get pods` shows `ImagePullBackOff` or `ErrImagePull`

**Commands:**
```bash
helm status backend
kubectl get pods
kubectl describe pod <pod-name>
```

**Investigation:** `kubectl describe pod` events will show something like
`Failed to pull image "myrepo/backend:1.0.x": not found`.

**Root Cause:** `image.tag` in values doesn't exist in the registry (typo, or image not pushed yet).

**Fix:** Correct the tag in the values file (or `--set image.tag=...`) and re-run `helm upgrade --install`.

**Verification:** `kubectl get pods` shows `Running` and `READY 1/1`.

---

## Scenario: Invalid Template (chart won't even render)

```
helm template
    ↓
Template error
```

**Problem:** `helm install`/`upgrade` fails immediately, before anything touches the cluster.

**Symptoms:**
```
Error: template: backend/templates/deployment.yaml:12:20: executing
"backend/templates/deployment.yaml" at <.Values.image.repositoy>:
nil pointer evaluating interface {}.repositoy
```

**Commands:**
```bash
helm lint ./charts/backend
helm template backend ./charts/backend -f values-production.yaml
```

**Investigation:** The error names the exact file/line — usually a typo'd values key (`repositoy` vs `repository`) or a missing value with no `default`.

**Root Cause:** Template references a values key that doesn't exist or is misspelled.

**Fix:** Correct the key name, or add a `default` / `required` guard in the template.

**Verification:** `helm template` renders clean YAML with no errors.
