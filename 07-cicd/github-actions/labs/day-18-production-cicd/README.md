# Day 18 — Production GitHub Actions Lab

## Objective
Assemble a full production-style CI/CD pipeline: build, test, Docker build,
Docker push, and a protected production deploy.

## Mental Model
```
Developer
  -> git push
  -> GitHub
  -> GitHub Actions
  -> Build
  -> Test
  -> Docker Build
  -> Docker Tag
  -> Docker Push
  -> Docker Registry
  -> Production Environment
  -> Approval
  -> Deploy
```

## Tasks

1. **Set up registry credentials**
   Add `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` as repository secrets.
   Never commit real credentials into the workflow file itself.

2. **Run the production pipeline**
   Copy `../../workflows/production-cicd.yml` into `.github/workflows/`.
   Push to `main` and follow the three jobs: `build-and-test` ->
   `docker-build-push` -> `deploy-production`.

3. **Create a protected environment**
   In **Settings -> Environments**, create an environment named
   `production`, and add a required reviewer. Re-run the workflow and
   confirm it pauses at `deploy-production` awaiting approval.

4. **Verify image traceability**
   Confirm the pushed image is tagged with `${{ github.sha }}` and that you
   can match a running container back to the exact commit that built it.

5. **Simulate common failures**
   - Break the checkout step (typo the `uses:` version) -> observe failure.
   - Break a test on purpose -> confirm `docker-build-push` never runs.
   - Use a wrong secret name -> confirm the Docker login step fails cleanly.
   - Use an invalid Dockerfile path -> confirm the build step fails with a
     clear error.

6. **Write the incident notes**
   For each simulated failure, note: what broke, what the log said, and how
   you'd fix it. This feeds `../../troubleshooting/`.

## Success Criteria
- [ ] Full pipeline runs green end-to-end on a real change
- [ ] Production deploy requires manual approval
- [ ] Every production image can be traced back to a commit SHA
- [ ] You've intentionally broken and diagnosed at least 3 failure types
