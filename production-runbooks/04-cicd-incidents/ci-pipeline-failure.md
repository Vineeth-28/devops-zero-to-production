# Incident: CI Pipeline Failure

## 1. Incident Summary
A CI/CD pipeline (GitHub Actions, Jenkins, etc.) fails, blocking builds/
deploys. The reported failure is often a cascading symptom from an earlier
stage, not the actual root cause.

## 2. Symptoms
- Pipeline run shows a failed stage (checkout, dependencies, test, build,
  deploy) with a red X
- Deploys blocked, or a broken artifact almost got deployed
- Sometimes: pipeline "passes" a later stage with a confusing error that's
  actually caused by an earlier, silently-degraded step

## 3. Impact
Blocks the team's ability to ship — severity depends on urgency (blocking
a routine change vs blocking an urgent hotfix/rollback).

## 4. Possible Causes
- Source checkout failure (auth, branch protection, submodule issues)
- Dependency installation failure (registry down, version conflict, lockfile drift)
- Test failure (real regression, or flaky/environment-dependent test)
- Build failure (compiler error, missing build tool, resource limits on the runner)
- Secret/credential missing, expired, or insufficiently scoped
- Environment variable misconfiguration between environments (works in one, not another)
- Docker build failure (see the dedicated runbook)
- Deployment stage failure (target environment unreachable, auth issue)

## 5. First 5 Minutes
1. Open the pipeline run and find the **first** failing step — not the last one
2. Check what changed: a new commit, a dependency bump, a secret rotation, a runner/image update
3. Check if it's failing for everyone or only specific branches/PRs
4. Check if it's reproducible (re-run) — flaky vs deterministic failure
5. Check recent changes to the pipeline definition itself (`.github/workflows/*.yml`, `Jenkinsfile`)

## 6. Finding the first meaningful failure, not the final cascade
CI pipelines are sequential/dependent — a failure in an early stage (e.g.
dependency install) can cause every later stage to fail too, often with a
much less clear error message ("cannot find module X" during build,
because install silently failed earlier). Always scroll to the **first**
red step in the pipeline, not the last one, and read its full log — don't
assume the final failing stage's error message is the real story.

## 7. Troubleshooting Flow
```
Pipeline failed
      |
Find the FIRST failing step (not the last)
      |
What stage is it?
      |
Checkout ---------> auth/branch/submodule issue
Dependencies ------> registry down / lockfile drift / version conflict
Tests -------------> real regression vs flaky test (re-run to check)
Build -------------> compiler error / missing tool / resource limit
Docker build ------> see docker-build-failure.md
Deploy ------------> target env auth/reachability issue
      |
Find root cause
```

## 8. Commands / Concepts

**GitHub Actions**
- Re-run the failed job with debug logging enabled (Actions → failed run →
  "Re-run jobs" → enable debug logging) — surfaces much more detail,
  especially for auth/environment issues
- Check the "Set up job" step logs for runner/environment info
- Check repository/organization Secrets are actually available to this
  workflow (some secrets are environment-scoped and won't appear in a
  workflow that doesn't declare that environment)

**Jenkins**
- Open the full console output (not just the stage view) and search for
  the first `ERROR` or non-zero exit code
- Check the Jenkinsfile for recent changes to stage definitions
- Check agent/executor health if the failure looks environment-related
  rather than code-related (e.g. "no space left on device" on the build agent)

**General**
```bash
# Reproduce a dependency install locally with the exact lockfile
npm ci        # or: pip install -r requirements.txt --no-cache-dir, etc.
```
**What it checks:** whether the failure reproduces outside CI, ruling out
a CI-environment-specific cause.
**Why we run it:** narrows "is this my code/dependencies" vs "is this the CI runner/environment".
**What to look for:** identical failure locally = code/dependency issue;
success locally = environment-specific (secrets, runner image, network) issue.

## 9. How to Interpret the Output
- Failure reproduces identically locally with the same lockfile → genuine
  code/dependency problem, not a CI infrastructure issue.
- Failure only happens in CI, not locally → suspect environment variables,
  secrets availability, or runner-specific differences (OS, tool versions).
- Test failure is intermittent across re-runs with no code change →
  flaky test (timing-dependent, external dependency, shared state) —
  still worth fixing, but not a regression in your code today.
- Error appears deep in a build stage but references a module that failed
  to install → the real failure is upstream in the dependency-install
  stage; the build error is just the cascade.

## 10. Root Cause Examples
- A dependency's registry had an outage during install
- Lockfile drifted from `package.json`/`requirements.txt` after a manual
  edit, causing a version resolution conflict only in CI's clean-install mode
- A secret used for a private registry or deployment target expired
- A flaky, timing-dependent test failed under CI's slower/shared runners
  but passes reliably locally
- The pipeline definition itself was edited and introduced a syntax or logic error

## 11. Fix / Recovery
**Immediate mitigation:**
- Re-run the pipeline if the failure is confirmed flaky/transient
- Revert the specific commit/config change that broke the pipeline if identified quickly

**Permanent fix:**
- Fix the actual code/dependency/config issue at its source
- Regenerate/commit a consistent lockfile
- Rotate and correctly scope the affected secret
- Quarantine and fix (don't just ignore) a confirmed flaky test

## 12. Verification
- Pipeline run succeeds end to end on the same commit/branch
- Re-run confirms it wasn't a one-off flake (run it more than once if flakiness was suspected)

## 13. Prevention
- Pin dependency versions and commit lockfiles; review lockfile diffs in PRs
- Add secret-expiry monitoring/rotation automation
- Track flaky tests explicitly (quarantine + follow-up ticket) instead of
  ignoring intermittent failures
- Keep pipeline definitions under the same review process as application code

## 14. Interview Explanation
"My first move with any CI failure is finding the first failing step, not
the last one, since pipelines are sequential and an early failure often
produces a confusing cascade of errors later on. From there I try to
reproduce it locally with the same lockfile/dependencies — if it
reproduces, it's a genuine code or dependency issue; if it only fails in
CI, I look at environment differences, especially secrets availability and
runner configuration, before assuming the code itself is broken."
