# Workflow — Complete Jenkins CI/CD (End to End)

The full picture, combining fundamentals → pipelines → GitHub → Docker → production practices.

```
┌─────────────┐     push/PR      ┌───────────────────────────┐
│   GitHub    │ ───────────────▶ │  Jenkins Multibranch Job   │
└─────────────┘   webhook        └──────────────┬─────────────┘
                                                  │
                                                  ▼
                                    ┌─────────────────────────┐
                                    │ CHECKOUT                │
                                    └────────────┬────────────┘
                                                  ▼
                                    ┌─────────────────────────┐
                                    │ BUILD (Docker agent)     │
                                    │  npm ci / make build     │
                                    └────────────┬────────────┘
                                                  ▼
                                    ┌─────────────────────────┐
                                    │ TEST                     │
                                    │  unit + lint (parallel)  │
                                    │  junit report published  │
                                    └────────────┬────────────┘
                                                  ▼
                                    ┌─────────────────────────┐
                                    │ PACKAGE                  │
                                    │  docker build & tag      │
                                    └────────────┬────────────┘
                                                  ▼
                                    ┌─────────────────────────┐
                                    │ PUSH TO REGISTRY         │
                                    └────────────┬────────────┘
                                                  ▼
                              branch == main? ────┴──── no ──▶ stop here, report status
                                     │ yes
                                     ▼
                                    ┌─────────────────────────┐
                                    │ DEPLOY STAGING            │
                                    │  (auto)                   │
                                    └────────────┬────────────┘
                                                  ▼
                                    ┌─────────────────────────┐
                                    │ MANUAL APPROVAL           │
                                    │  input step                │
                                    └────────────┬────────────┘
                                                  ▼
                                    ┌─────────────────────────┐
                                    │ DEPLOY PRODUCTION          │
                                    └────────────┬────────────┘
                                                  ▼
                                    ┌─────────────────────────┐
                                    │ NOTIFY (Slack/email)       │
                                    └─────────────────────────┘
```

## Supporting Production Practices
- **Shared Library** wraps the common stages (`vars/standardPipeline.groovy`) so every service's Jenkinsfile is a few lines
- **RBAC** restricts who can trigger production deploys or edit pipeline definitions
- **Credentials** scoped per-folder (one credential store per team/service, not one global bucket)
- **Backups** of `JENKINS_HOME` run nightly, restore tested quarterly
- **Agents** are ephemeral Docker/Kubernetes agents where possible — no snowflake build servers
- **Monitoring** via the Prometheus plugin feeds a Jenkins health dashboard; failed-build alerts go to Slack

## Related
- [jenkins-ci-workflow.md](jenkins-ci-workflow.md)
- [jenkins-github-workflow.md](jenkins-github-workflow.md)
- [jenkins-docker-workflow.md](jenkins-docker-workflow.md)
- [../troubleshooting/production-jenkins.md](../troubleshooting/production-jenkins.md)
