# Final Helm Quiz

Quick-fire round — answer each in one or two sentences before checking yourself.

1. **What is Helm, in one sentence?**
   A package manager and release management tool for Kubernetes.

2. **Chart vs Release — what's the difference?**
   Chart = the reusable package. Release = a specific installed instance of that chart, with its own values and revision history.

3. **What command renders a chart to plain YAML without installing it?**
   `helm template`

4. **What command validates chart structure/syntax without rendering full output?**
   `helm lint`

5. **What's the standard CI/CD deploy command, and why?**
   `helm upgrade --install` — idempotent, works whether or not the release already exists.

6. **What does `helm rollback backend 2` actually do?**
   Re-applies revision 2's manifests as a **new** revision — it doesn't delete history.

7. **`helm rollback` vs `kubectl rollout undo` — what's the key difference?**
   `helm rollback` reverts the whole release (every resource type); `kubectl rollout undo` only reverts one Deployment.

8. **What are `.Values`, `.Release`, and `.Chart`?**
   `.Values` = merged config from values files/--set. `.Release` = info about this install (name, revision, namespace). `.Chart` = metadata from Chart.yaml.

9. **What's the difference between `--set` and `-f values-file.yaml`?**
   `--set` overrides a single value inline (good for CI-injected values like image tag); `-f` supplies a whole structured file (good for environment config).

10. **Which takes priority: values.yaml, a `-f` file, or `--set`?**
    `--set` > `-f` file > `values.yaml` defaults.

11. **What does `--atomic` do on `helm upgrade --install`?**
    Automatically rolls back to the previous revision if the upgrade fails, instead of leaving a broken partial release.

12. **How do you deploy the same chart to dev, staging, and production differently?**
    One chart, three values files (`values-dev.yaml`, `values-staging.yaml`, `values-production.yaml`), applied with `-f` at deploy time.

13. **What are Helm hooks, and name one real use case.**
    Lifecycle-tagged Jobs (`pre-install`, `post-upgrade`, etc.) — e.g. running a DB migration Job before an upgrade completes.

14. **Pod shows `ImagePullBackOff` after `helm install` — what's your first move?**
    `kubectl describe pod` to see the exact pull error, then check `helm get values` to confirm the image tag/repo that was actually deployed.

15. **Pod is `Running` but `0/1 Ready` — what's likely wrong, and where do you look?**
    Failing readiness probe — `kubectl describe pod` events will show the probe failure; check `readinessProbe.path` against the app's actual route.

16. **What's the responsibility split between Docker, Helm, and Kubernetes?**
    Docker packages the app. Helm templates/deploys the Kubernetes config. Kubernetes actually runs and manages the containers.

17. **Why doesn't Helm replace `kubectl` troubleshooting?**
    Helm only manages the packaging/release layer — once manifests are applied, all pod-level behavior (crashes, probes, resource limits) is purely Kubernetes' domain.

18. **What's the difference between `helm dependency update` and `helm dependency build`?**
    `update` re-resolves and downloads dependency versions; `build` rebuilds from the lock file — more reproducible, preferred in CI.

19. **Why avoid overusing Helm hooks?**
    They add a new failure mode — a hanging or failing hook Job can block the entire release; many teams prefer handling things like migrations as a separate CI/CD step.

20. **What should you check first when a Helm-deployed app is misbehaving: Helm or Kubernetes?**
    Helm first (`helm status`, `helm history`, `helm get manifest`) to confirm what was actually deployed — then Kubernetes (`kubectl describe`/`logs`/`events`) to see how it's actually running.
