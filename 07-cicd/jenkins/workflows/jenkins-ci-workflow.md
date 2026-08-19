# Workflow — Basic Jenkins CI

End-to-end flow for a simple continuous integration setup.

```
Developer pushes code
        │
        ▼
GitHub webhook fires ──▶ Jenkins receives POST /github-webhook/
        │
        ▼
Multibranch Pipeline scans branch, finds Jenkinsfile
        │
        ▼
┌───────────────────────────────────────────┐
│ Pipeline runs:                             │
│  1. Checkout                               │
│  2. Install dependencies                   │
│  3. Lint                                   │
│  4. Unit tests (+ junit report)            │
│  5. Build artifact                         │
│  6. Archive artifact                       │
└───────────────────────────────────────────┘
        │
        ▼
Build status posted back to GitHub commit
        │
        ▼
Notification sent (Slack/email) on failure
```

## Steps in Detail

1. **Trigger** — GitHub webhook (preferred) or Poll SCM as fallback
2. **Checkout** — `checkout scm` pulls the exact commit that triggered the build
3. **Install** — restore dependencies (`npm ci`, `pip install -r requirements.txt`, etc.)
4. **Static checks** — lint, formatting checks, fail fast before expensive steps
5. **Test** — unit tests with a machine-readable report (`junit` step consumes JUnit XML)
6. **Build** — compile/bundle the artifact
7. **Archive** — `archiveArtifacts` so the build output is retrievable from the Jenkins UI
8. **Report status** — commit status API updates GitHub PR checks
9. **Notify** — Slack/email on failure (success notifications are often skipped to reduce noise)

## Minimal Jenkinsfile
See [`jenkinsfiles/basic/Jenkinsfile`](../jenkinsfiles/basic/Jenkinsfile).
