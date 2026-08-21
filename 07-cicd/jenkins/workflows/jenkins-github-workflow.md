# Workflow — Jenkins + GitHub Integration

```
GitHub Repo
   │
   ├── push to feature branch ──▶ webhook ──▶ Jenkins Multibranch Pipeline
   │                                                  │
   │                                                  ▼
   │                                        auto-creates branch job,
   │                                        runs Jenkinsfile
   │
   ├── open Pull Request ──▶ webhook (pull_request event) ──▶ Jenkins
   │                                                  │
   │                                                  ▼
   │                                        PR job runs, merges PR
   │                                        head into target branch
   │                                        for the test build
   │
   └── PR build result ──▶ commit status API ──▶ shown as ✅/❌ check on PR
```

## Setup Checklist

1. Create a scoped GitHub PAT (repo + admin:repo_hook if managing webhooks via Jenkins) or use a GitHub App for org-wide, higher-rate-limit integration
2. Add the credential in Jenkins (`Manage Jenkins → Credentials`)
3. Create a Multibranch Pipeline pointed at the GitHub org/repo
4. Confirm webhook delivery in GitHub → Settings → Webhooks → Recent Deliveries
5. Enable "GitHub Commit Status" so build results appear directly on commits/PRs
6. (Optional) Require the Jenkins check to pass before merge — GitHub branch protection rules

## PR Build Strategies

| Strategy | What gets built |
|---|---|
| Merging the PR with current target branch base | Simulates the post-merge result (recommended default) |
| The current PR revision only | Tests source branch in isolation |

## Common Patterns
- Run full test suite on PRs; run additional deploy stages only on `main`/`release` branches (`when { branch 'main' }`)
- Use GitHub Environments + Jenkins `input` step for manual approval gates on production deploys
