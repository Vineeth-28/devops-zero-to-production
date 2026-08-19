# Jenkins — Pipeline Failure Troubleshooting

## "No such DSL method" errors
- Usually means a plugin providing that step isn't installed, or the pipeline isn't wrapped correctly
- Check `Manage Jenkins → Pipeline Syntax` snippet generator to confirm correct syntax for the installed plugin version

## Pipeline hangs indefinitely
- Missing `timeout()` wrapper → add `options { timeout(time: 30, unit: 'MINUTES') }`
- A step is waiting on user input (`input` step) — check for a pending approval in the UI
- An agent never came online — check `Manage Jenkins → Nodes`

## "Script not permitted to use ... " (sandbox errors)
- Groovy sandbox blocks certain methods by default
- `Manage Jenkins → In-process Script Approval` → approve the specific signature
- Prefer using built-in pipeline steps over raw Groovy/Java calls to avoid this entirely

## Environment variable not found / empty
- `environment {}` block variables aren't available until the block is entered — check stage scoping
- Credentials binding variables only exist inside the `withCredentials` closure
- Use `sh 'printenv'` temporarily to debug (never log actual secret values)

## Stage skipped unexpectedly
- Check `when` conditions carefully — `branch` matches the SCM branch name exactly (case-sensitive)
- `changeRequest()` only evaluates true on PR builds, not regular branch builds

## Declarative pipeline fails at "Validating Jenkinsfile"
- Syntax error in the Jenkinsfile — Declarative pipelines are validated before any stage runs
- Use `Pipeline Syntax → Declarative Directive Generator` or lint via:
```bash
curl -X POST -F "jenkinsfile=<Jenkinsfile" http://localhost:8080/pipeline-model-converter/validate
```

## Flaky / intermittent failures
- Wrap unreliable steps: `retry(3) { sh './flaky.sh' }`
- Check for shared workspace contamination between builds — use `cleanWs()` in `post { always {} }`
