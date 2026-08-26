# GitHub Actions — Days 16-18

Production-focused revision module for GitHub Actions: fundamentals,
advanced workflow control, and production CI/CD with Docker.

## 1. Objective

Build a working, practical understanding of GitHub Actions — from a single
job workflow up to a production pipeline with job dependencies, secrets,
artifacts, caching, and a protected deployment gate — deep enough to use on
the job and to answer interview questions without hesitation.

## 2. Topics Covered

Workflow, events/triggers, jobs, steps, runners, `runs-on`, `uses`, `run`,
YAML workflow structure, `needs`, `if`, matrix strategy, secrets,
environment variables, GitHub Environments, artifacts, caching,
permissions/least privilege, third-party Action supply-chain security,
Docker build/tag/login/push, image traceability via `github.sha`,
branch-based deployment, environment protection/approval rules, quality
gates, and CI/CD troubleshooting.

## 3. Day 16-18 Breakdown

| Day | Focus |
|---|---|
| Day 16 | GitHub Actions Fundamentals — workflow anatomy, triggers, jobs, steps, runners |
| Day 17 | Advanced Workflows — `needs`, `if`, matrix, secrets, environments, artifacts, caching, permissions |
| Day 18 | Production CI/CD — Docker build/push, image traceability, protected environments, troubleshooting, final revision |

## 4. Core Mental Model

```
Developer
  -> git push
  -> GitHub
  -> GitHub Actions
  -> Workflow
  -> Job
  -> Runner
  -> Steps
```

## 5. GitHub Actions Architecture

| Concept | Definition |
|---|---|
| Workflow | YAML file in `.github/workflows/` |
| Job | Group of steps run on the same runner |
| Step | One `uses:` Action or `run:` command |
| Runner | Machine executing the job (GitHub-hosted or self-hosted) |
| Event | What triggers the workflow |

## 6. Workflow / Job / Runner / Step

- **Workflow** — the whole automation definition (one YAML file).
- **Job** — a unit of work; jobs run in parallel unless linked by `needs`.
- **Runner** — the VM/container executing a job (`runs-on: ubuntu-latest`).
- **Step** — the smallest unit inside a job; either an Action (`uses:`) or a
  raw command (`run:`).

## 7. YAML Structure

```yaml
name: Workflow Name
on:
  push:
    branches: [main]
jobs:
  job-id:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "hello"
```

## 8. Triggers

`push`, `pull_request`, `schedule` (cron), `workflow_dispatch` (manual),
each scoped with `branches:` filters as needed.

## 9. `needs`

Declares job dependency order, turning parallel jobs into a pipeline:
`build -> test -> deploy`.

## 10. `if`

Conditional execution based on branch (`github.ref`), event context, or job
status (`success()`, `failure()`, `always()`).

## 11. Matrix

`strategy: matrix:` runs a job across every combination of listed values
(e.g. OS x language version) in parallel.

## 12. Secrets

Encrypted values at repo/environment/org scope, referenced via
`${{ secrets.NAME }}`, masked automatically in logs.

## 13. Environment Variables

`env:` blocks for non-sensitive configuration values, visible in the
workflow file.

## 14. GitHub Environments

Named deployment targets (`production`, `staging`) with protection rules:
required reviewers, wait timers, deployment branch restrictions, and
scoped secrets.

## 15. Artifacts

`upload-artifact` / `download-artifact` pass files between jobs, since each
job runs on an isolated runner with no shared filesystem.

## 16. Caching

`actions/cache` reuses dependency downloads between runs, keyed on a
lockfile hash so it auto-invalidates when dependencies change.

## 17. Permissions / Security

Explicit least-privilege `permissions:` blocks, pinned third-party Action
versions, awareness of the fork/`pull_request` secrets boundary, and OIDC
over static cloud credentials where possible.

## 18. Docker Integration

`docker/login-action` -> `docker build` -> tag with `${{ github.sha }}` ->
`docker push` to registry. SHA tagging gives every image full traceability
back to its commit.

## 19. Production CI/CD Workflow

```
Developer -> git push -> GitHub -> GitHub Actions
  -> Build -> Test -> Docker Build -> Docker Tag -> Docker Push
  -> Docker Registry -> Production Environment -> Approval -> Deploy
```
Implemented in `workflows/production-cicd.yml`, exercised in
`labs/day-18-production-cicd/`.

## 20. Troubleshooting

Covered in `troubleshooting/`: general triage, workflow/step failures,
runner issues, Docker-in-CI issues, and secrets/configuration issues.

## 21. Interview Questions

Day-by-day question sets plus a harder final mixed quiz in `interview/`.

## 22. Key Learnings

- Most workflow failures are structural (YAML, trigger, branch filter)
  before they're ever logical.
- `needs` + `if` turn a flat job list into a real pipeline with gates.
- Artifacts move files between jobs; caching speeds up repeated work within
  a job — different problems, often confused.
- Production-readiness = SHA-based traceability + environment protection +
  least-privilege permissions, not just "the pipeline goes green."

## 23. Jenkins vs GitHub Actions

| | Jenkins | GitHub Actions |
|---|---|---|
| Pipeline definition | `Jenkinsfile` (Groovy) | YAML in `.github/workflows/` |
| Infrastructure | Self-hosted server + agents | Hosted runners (or self-hosted) |
| Setup effort | Install, configure, patch, scale | Enabled by default per repo |
| Ecosystem | Plugin-based | Actions Marketplace |
| GitHub integration | Requires webhooks/plugins | Native |

## 24. Completion Status

GitHub Actions: Days 16-18 COMPLETE ✅

Next Module: Kubernetes — Days 19-28

---

## Repository Structure

```
07-cicd/github-actions/
├── README.md
├── github-actions-notes.md
├── workflows/            # production-ready workflow YAML + reference notes
├── examples/             # one concept per file (needs, if, matrix, etc.)
├── labs/                 # guided Day 16-18 hands-on exercises
├── troubleshooting/       # failure categories and fixes
├── interview/             # day-by-day Q&A + final quiz
└── pdfs/                  # printable revision documents
```

For a single-file, no-lesson-required revision pass, see
`github-actions-notes.md`.
