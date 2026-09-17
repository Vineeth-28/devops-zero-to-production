# CI/CD Interview Questions

Cross-tool CI/CD thinking — end-to-end pipeline design, not tied to one specific tool. See `jenkins.md` and `github-actions.md` for tool-specific questions.

---

## Q1. What's the actual difference between CI and CD, and where does "Continuous Deployment" fit versus "Continuous Delivery"?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Precise vocabulary — CD is often used loosely, and a strong candidate distinguishes Delivery from Deployment.

### Expected Answer
CI (Continuous Integration) = frequently merging code with automated build/test on every change, catching integration problems early. Continuous Delivery = every change that passes CI is automatically packaged into a releasable, deploy-ready artifact, but a human still triggers the actual production release. Continuous Deployment = every change that passes all checks is automatically deployed to production with no manual gate at all.

### Strong Interview Answer
"CI is about integrating code frequently and automatically building/testing it, so problems are caught early instead of at a big merge later. Continuous Delivery means every change that passes CI is automatically built into a release-ready artifact — it's always deployable — but a human still decides when to actually push the button to production. Continuous Deployment goes one step further and removes that manual gate entirely — anything passing all checks goes straight to production automatically. Most teams I've seen practice Continuous Delivery rather than full Deployment, keeping a manual or approval-gated release step for production specifically."

### Follow-up Questions
- Why might a team deliberately choose Delivery over full Deployment, even with strong test coverage?
- What would you need to trust before adopting full Continuous Deployment?
- Where does a feature flag fit into enabling safer Continuous Deployment?

### Key Points
- CI = frequent integration + automated build/test.
- Continuous Delivery = always release-ready, human triggers the actual release.
- Continuous Deployment = fully automatic, no manual gate to production.

---

## Q2. Design the stages of a CI/CD pipeline for a typical containerized web application, end to end.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whole-pipeline architectural thinking — a common system-design-style CI/CD question.

### Expected Answer
Typical stages: checkout code → install dependencies/lint → run unit tests → build the Docker image → run integration tests against that image → push image to a registry with an immutable tag → deploy to a staging environment → run smoke tests → (gate, manual or automatic) → deploy to production → post-deploy verification/monitoring.

### Strong Interview Answer
"I'd lay it out as: checkout, then lint and unit tests fast to fail early and cheaply. Then build the actual Docker image, tagged immutably — usually the git SHA — and run integration tests against that built image, not just the raw code, so I'm testing what will actually ship. Push that image to a registry once it passes. Deploy to staging automatically and run smoke tests there. Then a gate — sometimes automatic if I trust the test suite fully, sometimes a manual approval — before deploying that exact same image to production. After production deploy, I don't just trust the deploy step succeeded; I watch real metrics and error rates for a window afterward as final verification."

### Follow-up Questions
- Why deploy the exact same built image to staging and production, rather than rebuilding for each?
- Where would a database migration step fit into this pipeline?
- What would make you put a manual approval gate before production vs. fully automating it?

### Key Points
- Standard flow: lint/unit test → build image (immutable tag) → integration test → push registry → staging deploy → smoke test → gate → prod deploy → post-deploy verification.
- Build once, deploy the same artifact everywhere — never rebuild per environment.
- Post-deploy monitoring is part of the pipeline's job, not an afterthought.

---

## Q3. How do you find the actual failing step when a CI/CD pipeline has a cascading failure across multiple stages?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Root-cause discipline — distinguishing the first real failure from downstream noise.

### Expected Answer
Go to the earliest failed stage first, not the last one reported or the most visually alarming one — later stages often fail only because an earlier stage produced a bad artifact or left something in a broken state. Read that first failure's actual logs in detail; downstream failures are frequently just consequences, not independent problems.

### Strong Interview Answer
"I always go to the earliest failure in the pipeline, not whichever one is most prominent or last in the log. A lot of cascading failures are really one root cause — like a build stage silently producing a broken artifact — with every downstream stage failing as a consequence, not independently. So I'd open the very first red stage, read its actual logs carefully, and only look at later stage failures once I understand whether they're genuinely separate issues or just fallout from that first one."

### Follow-up Questions
- How would you tell if a downstream failure is truly independent versus just fallout from an earlier one?
- What pipeline design choice would make it easier to isolate the true first failure?
- How would you handle a flaky test that fails intermittently and triggers false-positive cascades?

### Key Points
- Investigate the earliest failed stage first — later failures are often downstream consequences.
- Read the actual logs of that first failure rather than assuming/guessing.
- Good pipeline design (fail-fast stages, clear stage boundaries) makes root-cause isolation easier.

---

## Q4. How would you integrate Docker into a CI/CD pipeline safely — what do you specifically check for image builds and pushes?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Practical concerns around building and shipping containers through CI.

### Expected Answer
Build the image in CI using a locked-down build context (`.dockerignore` to exclude secrets), tag immutably (git SHA, never rely on `latest`), scan for vulnerabilities before pushing if feasible, push only after tests pass, and push to a registry with access controls. Use multi-stage builds to keep the final shipped image minimal and free of build-time secrets/tools.

### Strong Interview Answer
"I make sure `.dockerignore` is solid so nothing like `.env` or `.git` ends up in the build context. I tag images immutably with the git SHA — never relying on `latest` to represent what's actually deployed. The image only gets built and pushed after tests pass, not before, so a broken build never makes it into the registry. I use multi-stage builds so the final image doesn't carry build tools or any build-time secrets. And ideally there's a vulnerability scan step before push, so a known-bad base image or dependency gets caught before it ships anywhere."

### Follow-up Questions
- Where in the pipeline would you place an image vulnerability scan, and what would a failure there mean for the pipeline?
- How would you prevent a broken image from ever reaching the registry even if a later stage fails?
- What access controls would you put on who can push to the production image registry?

### Key Points
- Solid `.dockerignore`, immutable SHA tags, multi-stage builds to avoid leaking build secrets/tools.
- Build and push only after tests pass — never push an unverified image.
- Vulnerability scanning before push is a real production practice, not optional polish.

---

## Q5. What's your approach when a production deployment fails partway through the CI/CD pipeline?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Incident response instincts specifically in the CI/CD deployment context.

### Expected Answer
First determine actual production impact (is old code still serving, or is production in a broken half-deployed state?). If a rolling deployment strategy is in use, often the safe move is roll back to the last known-good image/version rather than trying to "push through" a fix. Investigate the pipeline failure separately once production is stable, using pipeline logs to find the actual root cause before re-attempting the deploy.

### Strong Interview Answer
"First priority is production stability, not fixing the pipeline. I check whether the failure left production serving the old, working version (many rolling deploy strategies fail safe this way) or in a genuinely broken half-deployed state. If it's the latter, my first move is rolling back to the last known-good image, using the same immutable tagging that makes rollback exact and fast — not trying to debug forward under pressure while users are affected. Once production is stable again, I investigate the actual pipeline failure calmly, using the pipeline's logs, and only re-attempt the deploy once I understand and fix the root cause."

### Follow-up Questions
- How would you verify production is actually serving correctly after a rollback, not just assume it?
- What pipeline design would make 'production still safe' more likely by default during a failed deploy?
- Would you always default to rollback, or are there situations you'd push forward instead?

### Key Points
- Stabilize production first, debug the pipeline second — don't fix-forward under pressure.
- Rollback to last known-good image is usually the safest first move.
- Verify actual production health post-rollback, don't just trust the rollback command's exit code.

---
