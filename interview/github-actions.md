# GitHub Actions Interview Questions

Based on `../07-cicd/github-actions/` (examples/, workflows/, troubleshooting/).

---

## Q1. Explain the relationship between workflow, job, step, and runner in GitHub Actions.

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Core vocabulary — needed before any deeper Actions question makes sense.

### Expected Answer
A workflow is a YAML file (in `.github/workflows/`) triggered by events, containing one or more jobs. A job is a set of steps that run on a single runner (a fresh VM/container by default), and jobs run in parallel unless dependencies (`needs`) are declared. A step is a single action or shell command within a job. A runner is the actual machine (GitHub-hosted or self-hosted) executing the job.

### Strong Interview Answer
"A workflow is the YAML file itself, triggered by some event like a push or PR. It contains one or more jobs, and by default jobs run in parallel, each on its own fresh runner — a clean VM or container — unless I use `needs` to sequence them. Within a job, steps run sequentially on that same runner, and each step is either a shell command or a reusable action. So the nesting is: workflow triggers on an event → runs jobs (parallel by default) → each job runs steps in order on its runner."

### Follow-up Questions
- How do you make one job wait for another to complete first?
- What's the difference between a GitHub-hosted and self-hosted runner?
- Does state (like installed dependencies) persist between jobs in the same workflow?

### Key Points
- Workflow (event-triggered YAML) → Jobs (parallel by default) → Steps (sequential, per job).
- Each job gets a fresh runner by default — no shared state unless explicitly passed (artifacts/cache).
- `needs` sequences jobs that must run in order.

---

## Q2. How do `needs`, `if`, and `matrix` change how jobs run?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Practical workflow-design fluency for realistic pipelines.

### Expected Answer
`needs` creates a dependency, making a job wait for another to complete (and by default, succeed) before starting. `if` conditionally runs a job or step based on an expression (branch name, event type, previous step outcome). `matrix` runs the same job multiple times with different variable combinations (e.g. multiple Node versions or OSes) in parallel.

### Strong Interview Answer
"`needs` sequences jobs — a `deploy` job with `needs: [build, test]` won't start until both of those succeed. `if` lets me conditionally skip a job or step, like only running a deploy job `if: github.ref == 'refs/heads/main'` so PR branches don't trigger deploys. `matrix` runs the same job definition across a set of variable combinations in parallel — like testing against Node 18, 20, and 22 simultaneously without writing three separate job definitions."

### Follow-up Questions
- What happens to a `needs`-dependent job if the job it depends on fails?
- How would you run a job only on a failure of a previous step, instead of skipping it?
- How would matrix testing across 3 Node versions and 2 OSes multiply the number of runs?

### Key Points
- `needs` = job sequencing/dependency.
- `if` = conditional execution based on branch/event/prior outcome.
- `matrix` = parallel fan-out of the same job across variable combinations.

---

## Q3. How are secrets managed in GitHub Actions, and what's the risk with a workflow triggered by a fork's pull request?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Real security awareness — a well-known CI/CD attack surface.

### Expected Answer
Secrets are stored encrypted at the repo/org/environment level and injected as environment variables via `${{ secrets.NAME }}`, never exposed in logs (GitHub redacts known secret values). The risk: by default, workflows triggered by `pull_request` from a fork do NOT get access to repo secrets (a safety default), but `pull_request_target` does — misusing `pull_request_target` with an untrusted fork's code checked out can let an attacker's code run with access to secrets it shouldn't have.

### Strong Interview Answer
"Secrets are configured at the repo, environment, or org level, encrypted at rest, and referenced in workflows as `${{ secrets.NAME }}` — GitHub also scans logs and redacts known secret values automatically. The real risk is around forks: a plain `pull_request` trigger from a fork intentionally does NOT get access to repo secrets, as a safety default, because that PR's code is untrusted. The danger is `pull_request_target`, which does run with access to secrets and the base repo's context — if a workflow uses that trigger and then checks out and executes the fork's untrusted code, an attacker can get their code to run with access to secrets it was never supposed to touch. I'm very deliberate about using `pull_request_target` only when I'm not executing untrusted code from the PR itself."

### Follow-up Questions
- Why would GitHub Actions deliberately withhold secrets from a fork's pull_request workflow by default?
- What's the safe pattern if you do need to run something against fork PR code with limited, scoped access?
- How would you scope a secret to only a specific environment rather than the whole repo?

### Key Points
- Secrets injected via `${{ secrets.NAME }}`, encrypted at rest, redacted from logs automatically.
- `pull_request` from forks withholds secrets by default — a deliberate safety boundary.
- `pull_request_target` + executing untrusted fork code is a real, known attack surface — use carefully.

---

## Q4. How does caching work in GitHub Actions, and how does it differ from artifacts?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you know these solve different problems — build speed vs. passing outputs between jobs.

### Expected Answer
Cache (`actions/cache`) speeds up repeated jobs by reusing dependencies (e.g. `node_modules`, package manager cache) across workflow runs, keyed by a hash (often of the lockfile) — it's a performance optimization, not guaranteed to exist. Artifacts (`actions/upload-artifact`/`download-artifact`) explicitly pass files (build outputs, test reports) between jobs within the same workflow run, or make them downloadable after the run — used for actual data transfer, not just speed.

### Strong Interview Answer
"Cache and artifacts solve different problems even though both involve storing files. Cache is a performance optimization — I cache something like `node_modules` keyed off a hash of the lockfile, so subsequent runs skip a slow `npm install` if the lockfile hasn't changed. It's best-effort; the cache can be evicted or miss, and the workflow needs to work correctly even on a cache miss. Artifacts are for explicitly passing real data between jobs or preserving output after the run — like a `build` job uploading a compiled binary as an artifact, and a `deploy` job downloading it. Artifacts are the mechanism for actual data transfer; cache is purely about speed."

### Follow-up Questions
- What would you use as a cache key to correctly invalidate when dependencies change?
- How long do artifacts persist by default, and how would you download one after a workflow finishes?
- What happens to a workflow if a cache is unexpectedly missing — should it fail or fall back gracefully?

### Key Points
- Cache = performance optimization (best-effort, keyed, can miss) for repeated dependency installs.
- Artifacts = explicit data transfer between jobs / preserved outputs after the run.
- A workflow must function correctly on a cache miss — never depend on cache for correctness.

---

## Q5. A workflow that worked yesterday suddenly fails today with no code changes. What would you investigate?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Awareness that CI environments aren't fully static — external dependencies drift.

### Expected Answer
Check for: an upstream dependency version bump (unpinned package versions, a floating base Docker image tag), a change to a third-party GitHub Action being used (if not pinned to a specific SHA/version), a GitHub-hosted runner image update changing pre-installed tool versions, or an expired/rotated secret or credential. Read the actual failure logs for the new error rather than assuming it's identical to before.

### Strong Interview Answer
"If nothing in the repo changed, the environment around the workflow probably did. I'd check whether dependencies are pinned — an unpinned package version or a `:latest` base image could have shipped a breaking update overnight. I'd also check any third-party Actions the workflow uses — if they're referenced by a mutable tag like `@v2` instead of a pinned SHA, the action's own behavior could have changed under me. GitHub also periodically updates the pre-installed tool versions on hosted runners, which can break something that implicitly relied on a specific version. And I'd check if any secret or credential expired or rotated. First step either way is reading the actual new error message carefully rather than assuming it's the same failure as some past incident."

### Follow-up Questions
- How would you pin a third-party Action to a specific commit SHA instead of a tag?
- Why might GitHub-hosted runner image updates specifically be hard to predict or control?
- How would you catch a dependency version bump like this before it reaches a real pipeline failure?

### Key Points
- No code change + new failure → suspect environment drift, not application logic.
- Check: unpinned dependencies, mutable base images, unpinned third-party Actions, runner image updates, expired credentials.
- Pin dependencies and Actions to specific versions/SHAs to reduce this class of surprise failure.

---
