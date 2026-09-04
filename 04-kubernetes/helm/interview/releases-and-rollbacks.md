# Interview: Releases & Rollbacks

### `helm install` vs `helm upgrade`?
**Expected answer:** `install` creates a brand-new release (fails if it already exists). `upgrade` applies a new revision to an existing release (fails if it doesn't exist yet).
**Key points:** Neither is idempotent alone — that's what `--install` flag solves.
**Common mistake:** Using `helm install` repeatedly in a pipeline — it fails on the second run.

### Why use `helm upgrade --install`?
**Expected answer:** It's idempotent — installs if the release doesn't exist, upgrades if it does. Ideal for CI/CD, where the pipeline shouldn't need to know if this is the first deploy.
**Key points:** Standard command in every real-world deployment pipeline.
**Common mistake:** Not realizing this is effectively the only command most teams use for deploys (plain `install`/`upgrade` are mostly used manually/locally).

### How does Helm rollback work?
**Expected answer:** `helm rollback <release> <revision>` re-applies the manifests from a previous revision, creating a **new** revision with that content — it doesn't delete history.
**Key points:** Full release rollback (all resources the chart manages), not just one Deployment.
**Common mistake:** Thinking rollback deletes/rewrites history — `helm history` will show the rollback as a new entry, not a jump backward.

### `helm rollback` vs `kubectl rollout undo`?
**Expected answer:** `helm rollback` reverts the entire release (every resource type the chart manages) using Helm's own revision tracking. `kubectl rollout undo` only reverts a single Deployment's pod template using Kubernetes' ReplicaSet history.
**Key points:** If you deployed via Helm, use `helm rollback` — it keeps ConfigMaps/Secrets/Services consistent with the Deployment.
**Common mistake:** Using `kubectl rollout undo` on a Helm-managed Deployment — it can revert the Deployment while ConfigMap/Secret stay on the new (possibly incompatible) version.

### How do you troubleshoot a failed Helm deployment?
**Expected answer:** Start at the release layer (`helm status`, `helm history`, `helm get values/manifest`), then move to the Kubernetes layer (`kubectl get pods`, `describe`, `logs`, `get events`) once you've confirmed what was actually deployed.
**Key points:** Helm ≠ Kubernetes troubleshooting — they're sequential layers, not substitutes.
**Common mistake:** Jumping straight to `kubectl logs` without first confirming (via `helm get manifest`) that what's live actually matches what was intended.
