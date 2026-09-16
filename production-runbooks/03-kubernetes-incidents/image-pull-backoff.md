# Incident: ImagePullBackOff

## 1. Incident Summary
Kubernetes cannot pull the container image specified in the pod spec, and
is backing off retrying the pull. The pod never starts a container at
all — this happens before the application code ever runs.

## 2. Symptoms
- `kubectl get pods` shows `ErrImagePull` (first attempts) then
  `ImagePullBackOff` (after repeated failures)
- No application logs exist at all — nothing has run yet

## 3. Impact
Affected pods never start; if this happens during a rollout, new replicas
never come online while old ones (if any) may still be running and serving.

## 4. Possible Causes
- Wrong image name or typo
- Wrong/non-existent tag (e.g. referencing a tag that was never pushed, or
  was deleted)
- Private registry requiring authentication, with missing/incorrect `imagePullSecrets`
- Registry credentials expired
- Network path from the node to the registry is blocked
- Image genuinely doesn't exist (build/push step failed silently upstream)

## 5. First 5 Minutes
1. `kubectl describe pod <pod>` — read the exact pull error message
2. Confirm the image name and tag referenced in the manifest are correct
3. Try pulling the same image manually (from a node or locally) if possible
4. Check whether this is a private registry and whether `imagePullSecrets` are configured
5. Check if this started right after a CI/CD change (new image tag, registry migration)

## 6. Troubleshooting Flow
```
ImagePullBackOff
      |
kubectl describe pod (read exact error)
      |
Error mentions "not found" / "manifest unknown"?
      |
   Yes ------------------------------+
      |                              |
Wrong image name/tag                  Error mentions "unauthorized" / "authentication required"?
Verify against registry directly            |
                                          Yes -----------------------+
                                             |                        |
                                    Check imagePullSecrets      Check registry credential validity
                                    exist and are referenced     (expired token, rotated password)
                                             |
                                      Find root cause
```

## 7. Commands

```bash
kubectl describe pod <pod>
```
**What it checks:** the exact image-pull error message from the kubelet.
**Why we run it:** this is the single source of truth for why the pull failed.
**What to look for:** `Failed to pull image "...": rpc error: ... manifest
unknown` (wrong name/tag) vs `... unauthorized: authentication required`
(credentials issue) vs a network-level timeout.

```bash
kubectl get pod <pod> -o jsonpath='{.spec.containers[*].image}'
```
**What it checks:** the exact image reference Kubernetes is trying to pull.
**Why we run it:** confirms there's no typo/mismatch versus what you
intended to deploy (e.g. a templating bug producing the wrong tag).
**What to look for:** an unexpected registry, repo name, or tag.

```bash
kubectl get secret <imagePullSecret> -o yaml
```
**What it checks:** whether the referenced pull secret actually exists in the namespace.
**Why we run it:** a pod can reference a secret name that doesn't exist in
that namespace (secrets are namespace-scoped) or exists but is stale.
**What to look for:** secret missing entirely, or present but with outdated credentials.

```bash
docker pull <image>:<tag>
```
**What it checks:** whether the image can be pulled at all, independent of Kubernetes.
**Why we run it:** isolates whether the problem is the image/registry
itself or something specific to the cluster's pull configuration.
**What to look for:** same error reproduced manually (confirms registry/
image issue) vs a successful pull (points at cluster-side config,
like missing imagePullSecrets on that specific node/namespace).

## 8. How to Interpret the Output
- `manifest unknown` / `not found` → the tag doesn't exist in the
  registry — check the CI/CD pipeline actually pushed it, and check for typos.
- `unauthorized: authentication required` → registry needs auth and either
  no `imagePullSecrets` is attached, or the credentials in it are wrong/expired.
- Manual `docker pull` from your own machine succeeds, but the cluster
  still fails → the issue is specific to the cluster's network path to the
  registry, or the node lacks the pull secret (secrets don't automatically
  exist across every namespace).

## 9. Root Cause Examples
- CI/CD pushed the image to `myapp:v1.2.4` but the Deployment manifest
  still references `myapp:v1.2.3` after a templating mistake
- A private ECR/GCR/Docker Hub repo rotated its access token and the
  cluster's `imagePullSecrets` weren't updated
- The Deployment was copied to a new namespace, but the `imagePullSecret`
  wasn't recreated there (secrets don't cross namespaces automatically)
- A firewall/NetworkPolicy change blocked egress from nodes to the registry's IP range

## 10. Fix / Recovery
**Immediate mitigation:**
- Correct the image name/tag in the manifest and reapply
- Recreate/update the `imagePullSecret` with valid credentials

**Permanent fix:**
- Add CI validation that the image was actually pushed successfully before
  triggering a deploy referencing it
- Automate `imagePullSecret` rotation alongside registry credential rotation
- Ensure `imagePullSecrets` are provisioned in every namespace that needs them (or use a cluster-wide default where appropriate)

## 11. Verification
- `kubectl get pods` shows the pod transitions past `ImagePullBackOff` into `Running`
- `kubectl describe pod` shows a successful pull event
- Application starts and passes readiness as expected

## 12. Prevention
- CI pipeline verifies the image exists in the registry immediately after push, before updating any manifest to reference it
- Centralize/automate pull-secret management so rotations don't silently break clusters
- Alert on `ImagePullBackOff` state specifically — it's an unambiguous, high-signal failure

## 13. Post-Incident Checklist
- [ ] Confirmed exact error via `describe pod`
- [ ] Verified image name/tag correctness against the registry
- [ ] Verified pull secret validity/presence in the right namespace
- [ ] Fix applied and pod confirmed Running
- [ ] Root cause documented (naming, auth, or network)

## 14. Interview Explanation
"ImagePullBackOff means Kubernetes couldn't even retrieve the image — the
application hasn't run at all yet, so there's nothing to check in
application logs. `kubectl describe pod` gives the exact kubelet-level
error, which almost always falls into one of two buckets: the image name/
tag is wrong or doesn't exist, or it's a private registry and the
imagePullSecret is missing, wrong, or expired. I confirm which bucket by
reading the exact error text rather than guessing."
