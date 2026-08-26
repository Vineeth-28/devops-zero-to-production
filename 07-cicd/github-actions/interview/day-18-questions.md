# Day 18 Interview Questions — Production GitHub Actions

**Q1. Walk through a production CI/CD pipeline end-to-end.**
Developer pushes -> GitHub Actions triggers -> build -> test -> Docker
build -> Docker tag (with commit SHA) -> Docker push to registry ->
production environment gate -> manual approval -> deploy.

**Q2. Why tag Docker images with `github.sha` instead of only `latest`?**
Traceability — `latest` is a floating pointer, so you can't tell which
commit produced a running container. The SHA tag ties every image to an
exact, immutable commit.

**Q3. How do you gate a production deploy behind manual approval?**
Declare `environment: production` on the deploy job, then add a required
reviewer rule to that environment under repo Settings -> Environments. The
job pauses until approved.

**Q4. The checkout step fails — what do you check first?**
Whether `actions/checkout` is even present, the `ref` value if one was
supplied, `fetch-depth` if history is needed, and whether submodules need
`with: submodules: true`.

**Q5. Docker push fails with "access denied" — likely causes?**
Login succeeded but the account lacks push rights to that
repository/namespace, or the image name/tag doesn't match a repo the
credentials can push to.

**Q6. A secret appears to be empty when used — how do you debug it?**
Confirm the secret name matches exactly (case-sensitive), confirm it's
defined at the right scope (repo vs environment vs org), and confirm the
job declares the right `environment:` if the secret is environment-scoped.

**Q7. What's the difference between a build failure and a runner failure?**
A build failure is your code/tests/Dockerfile — the job started fine, but a
step's command failed. A runner failure means the job never got a machine
to run on (queued forever, label mismatch, self-hosted runner offline).

**Q8. How would you design branch-based deployment (e.g. develop -> staging,
main -> production)?**
Use `if:` conditions keyed on `github.ref` per deploy job, or use two
separate environments with different `deployment branch policies`, each
job pointing at its own environment.

**Q9. What's a quality gate, and name two examples in a CI/CD pipeline.**
An automated or manual checkpoint a change must pass before proceeding.
Examples: tests must pass before Docker build runs (`needs:`), and a human
must approve before a production deploy proceeds (environment protection
rule).

**Q10. How do you keep production credentials out of the repository
entirely?**
Store them as GitHub Secrets (repo/environment/org-scoped) or, better,
use OIDC federation to assume a short-lived cloud role at runtime instead
of storing any static credential at all.
