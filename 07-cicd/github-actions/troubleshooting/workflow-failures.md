# Workflow / Step Failures

## Checkout failures (`actions/checkout@v4`)

| Cause | Fix |
|---|---|
| Wrong `ref` supplied | Remove `with: ref:` unless you specifically need a non-default branch/tag |
| Shallow clone missing history (`git log` empty) | Add `with: fetch-depth: 0` |
| Private submodules not cloned | Add `with: submodules: true` and a token with submodule access |
| Permission denied writing to workspace | Check the job doesn't run as a non-root user without workspace access |

## Build failures

- **Dependency install fails**: lockfile out of sync with `package.json` /
  `requirements.txt`. Run the install command locally with the same lockfile
  to reproduce.
- **Wrong runtime version**: pin `node-version` / `python-version` explicitly
  instead of relying on the runner's default.
- **Environment variable missing**: build script expects a var that's only
  set locally — add it under `env:` in the workflow.

## Test failures

- **Flaky tests only on CI**: usually timing or missing test isolation —
  reproduce locally with the same seed/order, not just "it works on my
  machine."
- **Tests need services** (DB, Redis, etc.): use `services:` in the job to
  spin up containers the tests can connect to.
- **Different OS behavior**: a matrix job on `windows-latest` can fail on
  path separators or line endings that pass on `ubuntu-latest`.

## General debugging steps

1. Reproduce the exact command locally (`npm ci && npm test`, not just
   `npm test`).
2. Add a temporary `run: env` step to confirm environment variables.
3. Use `actions/upload-artifact` to save logs/screenshots on failure for
   inspection.
4. Add `if: failure()` steps to print extra diagnostics only when something
   already broke.
