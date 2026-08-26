# Day 17 Interview Questions — Advanced GitHub Actions

**Q1. What does `needs` do?**
Declares that a job depends on one or more other jobs completing
successfully first, turning independent parallel jobs into a pipeline.

**Q2. How do you conditionally run a job or step?**
With an `if:` expression, e.g. `if: github.ref == 'refs/heads/main'` or
`if: failure()` to run only when a prior step/job failed.

**Q3. What is a matrix strategy used for?**
Running the same job across multiple configurations (OS versions, language
versions, etc.) in parallel — `strategy: matrix:` expands into one job per
combination.

**Q4. What does `fail-fast: false` do in a matrix?**
Normally, one matrix job failing cancels all the others. `fail-fast: false`
lets every matrix combination run to completion independently.

**Q5. What are GitHub Secrets?**
Encrypted values stored at the repo, environment, or organization level and
referenced via `${{ secrets.NAME }}`; GitHub automatically masks their
values in logs.

**Q6. Secrets vs environment variables — what's the difference?**
Environment variables (`env:`) are plain values visible in the workflow
file/logs. Secrets are encrypted at rest and masked in logs — always use
secrets for credentials, tokens, and keys.

**Q7. What is a GitHub Environment?**
A named deployment target (e.g. `production`) that can have protection
rules: required reviewers, wait timers, and scoped secrets.

**Q8. What are artifacts and when do you need them?**
Files produced by one job that need to be used by another job (or kept
after the run) — since each job runs on an isolated runner, artifacts are
the explicit way to pass files between them.

**Q9. What does caching optimize, and how is a cache key typically built?**
Speeds up repeated dependency installs by reusing previously downloaded
packages. Keys are usually built from a hash of the lockfile, e.g.
`${{ hashFiles('**/package-lock.json') }}`, so the cache invalidates
automatically when dependencies change.

**Q10. Why scope `permissions:` explicitly instead of using the default?**
Least privilege — the default `GITHUB_TOKEN` can be broader than a workflow
needs; explicitly setting `permissions: contents: read` (etc.) limits the
blast radius if a workflow or an Action it uses is compromised.

**Q11. What's a supply-chain risk with third-party Actions?**
Pinning to a mutable tag like `@main` (instead of a version tag or commit
SHA) means the Action's behavior can change without your knowledge — pin to
a specific version, and prefer well-maintained, widely-used Actions.
