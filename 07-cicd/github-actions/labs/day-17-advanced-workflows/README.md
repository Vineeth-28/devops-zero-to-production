# Day 17 — Advanced GitHub Actions Lab

## Objective
Practice job dependencies, conditional execution, matrix builds, secrets,
artifacts, and caching in real workflows.

## Mental Model
```
Workflow -> Jobs -> Runners -> Steps

needs    -> controls job dependency
if       -> controls conditional execution
matrix   -> runs multiple configurations
secrets  -> sensitive values
artifacts-> build outputs
cache    -> performance optimization
```

## Tasks

1. **Job dependencies**
   Use `../../examples/job-dependencies.yml`. Confirm in the Actions UI that
   `test` only starts after `build` finishes, and `deploy` only after `test`.

2. **Conditional execution**
   Use `../../examples/conditions.yml`. Push to `develop` and confirm only
   `deploy-staging` runs. Push to `main` and confirm only `deploy-production`
   runs.

3. **Matrix strategy**
   Use `../../examples/matrix-strategy.yml`. Count how many jobs the matrix
   produces (os x node-version) and explain `fail-fast: false`.

4. **Secrets**
   In your repo: **Settings -> Secrets and variables -> Actions**, add a
   secret named `API_TOKEN` with a dummy value. Run
   `../../examples/secrets.yml` and confirm the value never appears in logs.

5. **Artifacts**
   Run `../../examples/artifacts.yml`. Download the `dist-files` artifact
   from the Actions run summary and confirm it contains `app.txt`.

6. **Caching**
   Run `../../examples/caching.yml` twice. Compare the run time and the
   "Cache restored from key" log line between the first (cache miss) and
   second (cache hit) run.

7. **Permissions**
   Add a `permissions:` block scoped to only what each workflow needs
   (`contents: read`, `packages: write`, etc.) instead of relying on defaults.

## Success Criteria
- [ ] Can explain `needs` and draw the resulting job graph
- [ ] Can explain when an `if:` condition evaluates to true/false
- [ ] Can explain what a matrix expands into
- [ ] Secrets never appear in plaintext in logs
- [ ] Artifacts successfully passed between jobs
- [ ] Cache hit confirmed on a second run
