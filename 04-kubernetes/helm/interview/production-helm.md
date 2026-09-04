# Interview: Production Helm

### How does Helm fit into CI/CD?
**Expected answer:** After tests pass and a Docker image is built/pushed, the pipeline runs `helm upgrade --install` with environment-specific values and the new image tag, deploying via the Kubernetes API.
**Key points:** Helm is the last templating/deploy step, not the build step.
**Common mistake:** Conflating "building" the app (Docker's job) with "deploying" it (Helm's job).

### How do you manage dev/staging/production configuration?
**Expected answer:** One chart, multiple values files (`values-dev.yaml`, `values-staging.yaml`, `values-production.yaml`), each overriding only what differs from the shared `values.yaml` defaults.
**Key points:** Avoids duplicating the whole chart per environment.
**Common mistake:** Maintaining separate charts per environment instead of one chart with layered values — defeats Helm's main advantage.

### What are Helm dependencies?
**Expected answer:** Other charts a chart relies on (declared in `Chart.yaml`), managed via `helm dependency update`/`build`, downloaded into `charts/`.
**Key points:** Common for bundling Redis/Postgres alongside an app chart.
**Common mistake:** Not knowing the difference between `dependency update` (re-resolves versions) and `dependency build` (uses the lock file — more reproducible, preferred in CI).

### What are Helm hooks?
**Expected answer:** Annotated Kubernetes resources (usually Jobs) that run at specific lifecycle points — `pre-install`, `post-install`, `pre-upgrade`, `post-upgrade`, `pre-delete`, `post-delete`.
**Key points:** Common use: DB migrations before an upgrade.
**Common mistake:** Overusing hooks for things better handled as separate CI/CD steps — hooks add a new failure mode (a hanging/failing hook Job can block the whole release).

### How does Helm work with Docker and Kubernetes?
**Expected answer:** Docker packages the application into an image. Helm templates the Kubernetes configuration that references that image. Kubernetes actually runs and manages the containers.
**Key points:** Three distinct layers — build, configure/deploy, run.
**Common mistake:** Saying Helm "deploys the app" in a way that implies it also runs it — it only produces and applies the manifests; Kubernetes does the running.

### What does `helm upgrade --install --atomic` do, and why use it in production?
**Expected answer:** If the upgrade fails, Helm automatically rolls back to the previous working revision instead of leaving the release half-applied.
**Key points:** Prevents partial, broken production deploys from lingering.
**Common mistake:** Not knowing this flag exists — assuming failed upgrades need manual rollback every time.
