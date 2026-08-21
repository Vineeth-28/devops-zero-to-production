# Day 13 — Interview Questions: GitHub Integration

1. Why is a webhook generally preferred over SCM polling?
2. Walk through what happens end-to-end when a developer pushes a commit, from GitHub to a running build.
3. What credential types work with GitHub, and when would you choose each (PAT vs SSH key vs GitHub App)?
4. What is a Multibranch Pipeline, and how does it differ from creating one job per branch manually?
5. How does Jenkins report build status back to a GitHub PR, and why does that matter for branch protection rules?
6. What's the difference between building "the PR head only" vs "the PR merged with target branch"? Which would you choose and why?
7. How would you debug a webhook that isn't triggering a build?
8. What security risks come with granting a Jenkins credential broad GitHub scopes, and how do you mitigate them?

<details><summary>Answer notes</summary>

- Q1: Webhooks are push-based (near-instant, low overhead); polling adds latency and unnecessary API/Git load at scale.
- Q6: "Merged with target" simulates the actual post-merge state, catching integration issues polling the source branch alone would miss — generally the safer default for PR gating.
- Q7: Check GitHub's webhook "Recent Deliveries" for response codes, verify the payload URL and that the job has the GitHub trigger enabled, and check firewall/reachability from GitHub's IPs.
</details>
