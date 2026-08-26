# Workflow Notes — Complete Production CI/CD

Reference notes for `production-cicd.yml`, the full pipeline used in the
Day 18 lab.

## Pipeline shape

```
build-and-test  -->  docker-build-push  -->  deploy-production
   (needs: none)      (needs: build-and-test)   (needs: docker-build-push)
```

Each arrow is a `needs:` dependency — a job only starts once every job in
its `needs:` list has succeeded.

## Why split into three jobs instead of one

- **Isolation**: a failing test stops the pipeline before any Docker image
  is even built — no wasted build/push time.
- **Parallelizable in bigger pipelines**: independent jobs (e.g. lint +
  test) can run concurrently if neither `needs` the other.
- **Clearer logs**: each job's log is scoped to one concern, making failures
  easier to diagnose than one giant job.

## Artifacts between jobs

```yaml
- uses: actions/upload-artifact@v4
  with:
    name: build-output
    path: dist/
    retention-days: 5
```
- Jobs run on separate, isolated runners — files don't automatically carry
  over. `upload-artifact` / `download-artifact` is the explicit hand-off
  mechanism between jobs (or workflow runs).

## Production environment + approval

```yaml
environment:
  name: production
  url: https://example.com
```
- Declaring `environment:` lets you attach **protection rules** in
  **Settings -> Environments**: required reviewers, wait timers, and
  deployment branch restrictions.
- The job pauses at this point until an authorized reviewer approves — this
  is the manual "quality gate" before anything reaches production.

## Traceability

- The exact same `github.sha` is used to tag the Docker image in
  `docker-build-push` and referenced again in `deploy-production`'s log
  output — one commit, one image, one deploy, fully traceable.

## Extending this pipeline

- Add a `notify` job with `if: always()` to post pipeline status to Slack
  regardless of success/failure.
- Add a rollback job that redeploys the previous known-good `github.sha` tag
  if `deploy-production` fails post-deploy health checks.
