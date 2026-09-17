# 07 — CI/CD (Jenkins & GitHub Actions)

Production-focused CI/CD module covering two tracks side by side: a
self-hosted Jenkins pipeline setup, and GitHub-native CI/CD with GitHub
Actions. Both tracks build toward the same goal — a pipeline that builds,
tests, containerizes, and deploys with the same discipline a production
team would expect.

## Structure

```
07-cicd/
├── README.md              # this file
├── jenkins/                # Jenkins track (Days 11-15)
└── github-actions/         # GitHub Actions track (Days 16-18)
```

## Jenkins track — `jenkins/`

Controller/Agent architecture → jobs & declarative pipelines → GitHub
integration & webhooks → Docker-in-pipeline builds → production
hardening (RBAC, credential scoping, backup/restore, Shared Libraries).

See [`jenkins/README.md`](jenkins/README.md) for the day-by-day
breakdown, commands, Jenkinsfiles, labs, troubleshooting, and interview
prep.

## GitHub Actions track — `github-actions/`

Workflow/job/step/runner fundamentals → `needs`/`if`/matrix builds →
secrets & environments → Docker build/push with SHA-based traceability →
protected production environments with approval gates.

See [`github-actions/README.md`](github-actions/README.md) for the full
topic breakdown, example workflows, labs, troubleshooting, and interview
prep.

## Jenkins vs GitHub Actions

| | Jenkins | GitHub Actions |
|---|---|---|
| Pipeline definition | `Jenkinsfile` (Groovy) | YAML in `.github/workflows/` |
| Infrastructure | Self-hosted server + agents | Hosted runners (or self-hosted) |
| Setup effort | Install, configure, patch, scale | Enabled by default per repo |
| Ecosystem | Plugin-based | Actions Marketplace |
| GitHub integration | Requires webhooks/plugins | Native |

Both tracks are referenced from the root [`README.md`](../README.md)
CI/CD module deep dive.
