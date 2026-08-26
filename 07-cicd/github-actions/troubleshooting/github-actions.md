# GitHub Actions — General Troubleshooting

Quick index of failure categories. See the dedicated files in this folder
for deep dives on each area.

| Symptom | Likely Cause | See |
|---|---|---|
| Workflow doesn't trigger at all | Wrong path, wrong branch filter, wrong event name | this file |
| Job fails immediately | Bad YAML syntax, invalid `runs-on` | this file |
| Checkout step fails | Wrong ref, missing permissions, LFS not enabled | workflow-failures.md |
| Build/test step fails | Missing dependency, wrong Node/Python version, flaky test | workflow-failures.md |
| Job stuck "Queued" | No available runner, label mismatch, org concurrency limits | runner-issues.md |
| Docker build/push fails | Bad Dockerfile path, login failure, missing platform | docker-issues.md |
| Secret is empty in logs | Wrong secret name, secret not defined at repo/org level | secrets-issues.md |

## First checks for any failing workflow

1. **Confirm the trigger fired** — check the Actions tab; if there's no run
   at all, the `on:` block or branch filter is the problem, not the job.
2. **Validate YAML** — indentation errors are the #1 cause of a workflow
   silently not running. Use a YAML linter or `yamllint` locally.
3. **Read the first failing step, not the last log line** — GitHub Actions
   logs are sequential; scroll to the first red step, not the summary.
4. **Check `runs-on`** — a typo like `ubuntu-lastest` fails to schedule the
   job at all.
5. **Re-run with debug logging** — set repository secret
   `ACTIONS_STEP_DEBUG=true` to get verbose logs on the next run.

## Workflow doesn't trigger

- Workflow file isn't in `.github/workflows/` (must be exactly this path).
- `on:` event doesn't match what actually happened (e.g. `pull_request`
  workflow won't run on a direct push).
- `branches:` filter excludes the branch you pushed to.
- File has a `.yml`/`.yaml` extension typo or invalid top-level YAML.
- Workflow was disabled manually in the Actions tab.

## Job fails immediately (red X in seconds)

- YAML syntax error — GitHub reports "Invalid workflow file" instead of
  running any steps.
- `runs-on` references a label with no available runner.
- `needs:` references a job name that doesn't exist (typo).
