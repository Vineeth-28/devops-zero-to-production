# Helm Interview Questions

Based on `../04-kubernetes/helm/` (concepts/, commands/, troubleshooting/, interview/).

---

## Q1. `helm upgrade` reports success, but the application is broken. What's the gap?

**Difficulty:** 🔴 Production

### What the interviewer is testing
The recurring theme across this whole handbook — Helm/Kubernetes "success" is a narrow technical definition, not a guarantee of app correctness.

### Expected Answer
`helm upgrade` succeeding means the rendered manifests were valid and applied to the cluster, and (with `--wait`) that the new Pods passed their readiness probes within the timeout. It says nothing about whether the application is functionally correct beyond what that probe checks — a shallow probe, a bad config value, or a broken downstream dependency can all pass a Helm upgrade while the app is genuinely broken.

### Strong Interview Answer
"Helm's success just means the templates rendered into valid Kubernetes manifests, they were applied, and — if I used `--wait` — the new Pods became Ready within the timeout window. None of that verifies real application correctness beyond whatever the readiness probe actually checks. I've seen a values.yaml typo point the app at the wrong database and still sail through `helm upgrade --wait` successfully, because the shallow health check didn't catch it. That's why I always pair a Helm rollout with real post-deploy verification — actual smoke tests or monitoring — not just trusting the CLI's exit code."

### Follow-up Questions
- How would `--wait` and `--timeout` change what "success" actually verifies?
- What would you add to catch this kind of failure before it reaches users?
- How does this connect to the readiness-probe depth issue in plain Kubernetes deployments?

### Key Points
- Helm success = manifests valid + applied (+ readiness passed, if `--wait` used) — not app correctness.
- Shallow probes and bad config values can slip through a "successful" upgrade.
- Always pair with real post-deploy verification, not just the CLI exit code.

---

## Q2. Why is `helm upgrade --install` used in CI/CD pipelines instead of separate `install`/`upgrade` calls?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Practical CI/CD pattern knowledge — idempotency in automated pipelines.

### Expected Answer
`--install` makes the command idempotent: it installs if the release doesn't exist yet, or upgrades if it does — one command works for both the first deploy and every subsequent one, without the pipeline needing to know or check which case it is.

### Strong Interview Answer
"In a pipeline I don't want conditional logic asking 'does this release already exist, so should I install or upgrade' — that's fragile and easy to get wrong. `helm upgrade --install` handles both cases in one command: if the release is new, it installs; if it already exists, it upgrades. That makes the deploy step idempotent and safe to run on every pipeline execution without special-casing the very first deploy."

### Follow-up Questions
- What would go wrong if you used plain `helm install` in a pipeline that runs on every merge?
- How does this interact with `--atomic` for safety?
- What flags would you commonly pair with `--install` in production?

### Key Points
- `--install` = idempotent, handles both first deploy and subsequent upgrades in one command.
- Removes the need for branching logic in the pipeline to check release existence.
- Standard pattern for CI/CD-driven Helm deployments.

---

## Q3. How does `helm rollback` work, and what exactly does it restore?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Understanding of Helm's revision history mechanism, not just "it undoes the last deploy."

### Expected Answer
Helm keeps a revision history for each release, storing the rendered manifests and values used at each `install`/`upgrade`. `helm rollback <release> <revision>` re-applies the manifests from that specific stored revision to the cluster — it's not re-running the old chart from source, it's reapplying what was actually rendered and deployed at that point.

### Strong Interview Answer
"Every `helm upgrade` creates a new revision, and Helm stores the fully-rendered manifests and the values used for that revision. `helm rollback <release> <revision>` takes that stored, already-rendered state and reapplies it to the cluster — it's not re-templating the chart fresh, it's restoring exactly what was live at that revision. That's important because if the chart source itself has changed since then, rollback still gives you back exactly what was actually running, not a reinterpretation of history."

### Follow-up Questions
- How do you view the revision history for a release?
- What happens to Kubernetes objects that existed in the old revision but were removed in a newer one, when you roll back?
- How far back does Helm keep revision history by default?

### Key Points
- Helm stores fully-rendered manifests per revision, not just the chart source.
- Rollback reapplies that stored rendered state exactly, not a re-template.
- `helm history <release>` shows available revisions to roll back to.

---

## Q4. How do you prevent a wrong `values.yaml` from being deployed to production?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Real deployment safety practices around environment-specific configuration.

### Expected Answer
Use environment-specific values files (`values-production.yaml`) layered on top of a base `values.yaml`, explicitly passed with `-f` at deploy time rather than relying on defaults. Use `helm template` or `helm diff` (plugin) to preview the exact rendered manifest before applying, especially in CI, and gate production deploys behind review of that diff.

### Strong Interview Answer
"I keep a base `values.yaml` with sane defaults and separate override files per environment, like `values-production.yaml`, explicitly passed with `-f` — I never rely on the base file alone reaching production correctly by accident. In CI, before an actual `helm upgrade` runs against production, I run `helm template` with the exact same values files to render the manifest and, ideally, diff it against what's currently live using the `helm diff` plugin — that surfaces exactly what's about to change, which is a much stronger safety check than trusting the values file is correct by inspection alone."

### Follow-up Questions
- What's the risk of relying on Helm's default values.yaml reaching every environment?
- How would `helm diff` change your confidence before a production deploy?
- How would you structure values files for three environments — dev, staging, production?

### Key Points
- Explicit environment-specific values files (`-f values-production.yaml`), never implicit defaults for prod.
- `helm template`/`helm diff` to preview exact rendered output before applying.
- Gate production deploys on reviewing that diff, not just trusting the values file.

---

## Q5. Explain Helm's chart structure — what do `Chart.yaml`, `values.yaml`, and `templates/` each do?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Baseline Helm literacy.

### Expected Answer
`Chart.yaml` holds chart metadata (name, version, app version, dependencies). `values.yaml` holds default configuration values that templates reference. `templates/` contains Kubernetes manifest templates using Go templating, referencing `.Values` (from values.yaml), `.Release` (release-specific info like name/namespace), and `.Chart` (chart metadata) to render final manifests.

### Strong Interview Answer
"`Chart.yaml` is metadata about the chart itself — name, version, any chart dependencies. `values.yaml` holds the default configuration that gets substituted into the templates — replica count, image tag, resource limits, whatever's meant to be configurable. `templates/` is where the actual Kubernetes YAML lives, but as Go templates, referencing `.Values` for values.yaml data, `.Release` for things like the release name and namespace, and `.Chart` for the chart's own metadata. Helm combines all three at install/upgrade time to produce the final, real Kubernetes manifests that get applied."

### Follow-up Questions
- What's the difference between `.Chart.Version` and `.Chart.AppVersion`?
- How would you override a single value without editing values.yaml, from the command line?
- What goes in a `_helpers.tpl` file?

### Key Points
- `Chart.yaml` = metadata, `values.yaml` = configurable defaults, `templates/` = Go-templated manifests.
- `.Values`, `.Release`, `.Chart` are the main built-in objects templates reference.
- `--set key=value` overrides values.yaml at the CLI without editing the file.

---

## Q6. What does Helm actually give you over just running `kubectl apply` on a folder of YAML files?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Value proposition understanding — can you articulate why Helm exists, not just how to use it.

### Expected Answer
Templating (parameterize manifests instead of duplicating near-identical YAML per environment), release management (tracked revision history, easy rollback), packaging/versioning (charts as distributable, versioned units, including dependencies/subcharts), and lifecycle hooks (running jobs before/after install/upgrade, like migrations).

### Strong Interview Answer
"Raw `kubectl apply` has no concept of a 'release' — no history, no built-in rollback, no templating, so you either duplicate YAML per environment or hand-roll your own templating. Helm gives me parameterized templates so one chart works across dev/staging/production with different values, tracked revision history so I can `helm rollback` cleanly, versioned packaging so a chart is a distributable unit with its own dependencies, and hooks so I can run something like a database migration Job at a specific point in the upgrade lifecycle — none of that exists with plain `kubectl apply`."

### Follow-up Questions
- What would you lose if you rolled back a raw `kubectl apply` change vs a Helm release?
- When might you deliberately choose plain manifests over a Helm chart?
- How do subcharts help with a multi-service application?

### Key Points
- Helm adds: templating, release/revision tracking with rollback, versioned packaging, lifecycle hooks.
- Plain `kubectl apply` has no release concept — no history, no built-in rollback.
- Value grows with complexity — small single-manifest apps may not need it.

---

## Q7. What are Helm hooks, with a real example like a database migration?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Understanding of lifecycle hooks and a practical use case — a very common interview scenario.

### Expected Answer
Hooks let you run Kubernetes resources (usually Jobs) at specific points in a release's lifecycle — `pre-install`, `pre-upgrade`, `post-install`, `post-upgrade`, etc. A common use: a `pre-upgrade` hook running a Job that applies database migrations before the new application Pods (which expect the new schema) are rolled out.

### Strong Interview Answer
"Hooks let you attach a Kubernetes resource, usually a Job, to a specific point in the release lifecycle — annotate it `helm.sh/hook: pre-upgrade` and Helm runs it before the main upgrade proceeds. The classic example is database migrations: I'd have a `pre-upgrade` hook Job that runs the migration, and Helm won't proceed to roll out the new application Pods until that Job completes successfully. That way the schema is already updated before Pods expecting the new schema start receiving traffic, instead of a race where new Pods might start hitting an old, unmigrated database."

### Follow-up Questions
- What happens if a `pre-upgrade` hook Job fails?
- What's the difference between `pre-upgrade` and `pre-install` hooks?
- How would you clean up completed hook Jobs so they don't accumulate?

### Key Points
- Hooks run resources (usually Jobs) at defined lifecycle points via annotation.
- `pre-upgrade` for migrations ensures schema is ready before new Pods roll out.
- A failed hook by default blocks the release from proceeding — a safety mechanism.

---

## Q8. An `helm upgrade` fails partway through. What's the recovery process?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Knowledge of the `--atomic` flag and how to recover from a half-applied state without it.

### Expected Answer
Without `--atomic`, a failed upgrade can leave the release in a partially-applied, broken state (`helm status` shows `failed`), requiring manual rollback (`helm rollback`) to the last good revision. With `--atomic`, Helm automatically rolls back to the previous successful revision if the upgrade fails, avoiding the manual step and the window of partial breakage.

### Strong Interview Answer
"If I didn't use `--atomic`, a failed upgrade can leave the release stuck half-applied — `helm status` will show it as failed, and I'd need to manually run `helm rollback <release> <last-good-revision>` to get back to a known-good state. Going forward I use `--atomic` in production deploys specifically to avoid this: if the upgrade fails for any reason, Helm automatically rolls back to the previous successful revision on its own, so there's no manual recovery step and no extended window where the cluster is in a half-upgraded, broken state."

### Follow-up Questions
- What's the tradeoff of using `--atomic` — is there any downside?
- How would you find out exactly what caused the upgrade to fail?
- Does `--atomic` protect against a bad state that passed all checks but is still functionally wrong?

### Key Points
- Without `--atomic`, a failed upgrade can leave the release half-applied — needs manual `helm rollback`.
- `--atomic` auto-rolls-back on failure, closing that manual-recovery window.
- `--atomic` guards against failed applies, not against a "successful" but functionally wrong deploy.

---

## Q9. What are Helm dependencies/subcharts, and when would you use them?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Understanding chart composition for multi-service applications.

### Expected Answer
A chart can declare dependencies on other charts (subcharts) in `Chart.yaml`, letting you compose a multi-component application (e.g. an app chart depending on a Redis or Postgres subchart) as a single installable unit. Subcharts have their own values, but the parent chart can override them under a matching key in the parent's `values.yaml`.

### Strong Interview Answer
"If my application needs, say, Redis alongside it, I can declare Redis as a dependency in `Chart.yaml` rather than managing it as a totally separate release. Helm pulls in that subchart, and I can override its values from my parent chart's `values.yaml` under a key matching the subchart's name — so one `helm install` brings up the whole stack as a single coherent release, with one set of revision history and one rollback point covering everything together."

### Follow-up Questions
- How would you override a specific value in a subchart from the parent's values.yaml?
- What's the tradeoff of bundling a database as a subchart vs managing it as a separate release?
- How do you update a subchart to a newer version?

### Key Points
- Dependencies/subcharts let you compose multi-component apps as one chart.
- Parent `values.yaml` can override subchart values under the subchart's name key.
- Tradeoff: one release/rollback unit vs. losing independent lifecycle control over each component.

---

## Q10. What's the recurring theme across all of this — Kubernetes, Helm, CI/CD — around "successful" vs "healthy"?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Whether you can synthesize across topics — a strong signal of real production maturity, and a great closing/summary question.

### Expected Answer
Across the stack, "success" from a tool's perspective (kubectl apply succeeded, rollout completed, helm upgrade returned 0, CI pipeline is green) is a narrow, mechanical definition — the manifest was valid, the process didn't error, a shallow probe passed. None of these actually verify the application is behaving correctly for real users. Genuine confidence requires pairing tool-level success with real functional verification — monitoring, smoke tests, deep health checks — at every layer.

### Strong Interview Answer
"It's the same gap everywhere I've run into it: a tool's definition of 'success' is mechanical, not functional. `kubectl apply` succeeding means the manifest was valid. A rollout succeeding means Pods passed whatever probe was configured. `helm upgrade` succeeding means the same, plus the chart rendered correctly. A green CI pipeline means the steps it defined didn't error. None of those, on their own, prove the application is actually working correctly for a real user — that requires the probes, tests, and monitoring behind each of those checks to be genuinely meaningful, not shallow. So my mental model across the whole stack is: treat every green checkmark as 'the mechanism worked,' and separately verify 'the outcome is correct' with real functional checks — that's the gap that causes almost every 'but it said it succeeded' incident."

### Follow-up Questions
- Give one concrete example from Kubernetes and one from CI/CD where this gap caused a real incident.
- How would you design a deployment pipeline to close this gap as much as possible?
- Is there a cost to making every health check "deep" — what's the tradeoff?

### Key Points
- "Success" at the tool level is mechanical (valid manifest, no error, shallow probe passed) — not a functional guarantee.
- This gap recurs across Kubernetes readiness, Helm upgrades, and CI/CD green pipelines.
- Real confidence needs functional verification (deep health checks, smoke tests, monitoring) layered on top.

---
