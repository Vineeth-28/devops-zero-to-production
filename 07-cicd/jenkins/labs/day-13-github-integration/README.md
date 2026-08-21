# Day 13 — GitHub Integration

**Status:** ⬜ Not started

## Objectives
- Connect Jenkins to a GitHub repository securely
- Configure webhooks for push-triggered builds
- Set up a Multibranch Pipeline that auto-discovers branches and PRs
- Understand GitHub credential types (PAT vs SSH key vs GitHub App)

## Lab Steps

1. **Create GitHub credentials in Jenkins**
   - Generate a fine-scoped Personal Access Token (repo scope)
   - Add as "Username with password" or "Secret text" credential

2. **Configure a webhook**
   - GitHub repo → Settings → Webhooks → Add webhook
   - Payload URL: `http://<jenkins-host>/github-webhook/`
   - Content type: `application/json`, event: `push`

3. **Create a Multibranch Pipeline**
   - New Item → Multibranch Pipeline
   - Branch source: GitHub, point at your repo, use the PAT credential
   - Build configuration: by Jenkinsfile

4. **Test the flow**
   - Push a commit to a feature branch
   - Confirm Jenkins auto-discovers the branch and runs the Jenkinsfile
   - Open a PR and confirm PR-triggered builds work

5. **(Optional) GitHub status checks**
   - Enable commit status publishing so PRs show build pass/fail directly in GitHub

## Key Takeaways
- Webhooks are strongly preferred over polling — near-instant, lower load
- Multibranch pipelines remove the need to manually create a job per branch
- Use least-privilege tokens; rotate them periodically

## Checklist
- [ ] GitHub credentials configured in Jenkins
- [ ] Webhook delivering successfully (check GitHub's "Recent Deliveries")
- [ ] Multibranch Pipeline auto-building branches
- [ ] PR builds triggering and reporting status back to GitHub
