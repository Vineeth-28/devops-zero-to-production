# Final Jenkins Quiz — Days 11-15 Comprehensive

## Section A: Fundamentals (Day 11)
1. Define controller, agent, and executor in one sentence each.
2. What's the risk of running production builds directly on the controller?

## Section B: Jobs & Pipelines (Day 12)
3. Compare Declarative and Scripted pipeline syntax.
4. Write a minimal Declarative pipeline with a parameter and a conditional deploy stage (pseudocode is fine).

## Section C: GitHub Integration (Day 13)
5. Explain the full webhook-to-build flow.
6. What's the difference between building a PR's head commit vs the merge result?

## Section D: Jenkins + Docker (Day 14)
7. Compare Docker-outside-of-Docker vs Docker-in-Docker.
8. What tagging strategy would you use for CI-built images, and why?

## Section E: Production Jenkins (Day 15)
9. List three components of a production hardening checklist for Jenkins.
10. How would you structure credentials and RBAC for a 5-team organization sharing one Jenkins instance?

## Scenario Question
Your Multibranch Pipeline builds are queued but never start, even though the controller shows low CPU/memory usage. Walk through your triage steps.

<details><summary>Scenario answer notes</summary>

Check (in order): 1) job's node/label restriction vs available agent labels, 2) agent connectivity (`Manage Jenkins → Nodes` — is it marked offline?), 3) executor count on matching agents (all busy?), 4) `disableConcurrentBuilds()` blocking a new build behind a stuck prior run, 5) Docker/Kubernetes cloud agent provisioning failures in the logs if using dynamic agents.
</details>

## Self-Assessment
- [ ] I can explain Jenkins architecture without notes
- [ ] I can write a Declarative pipeline with parameters, parallel stages, and post actions from scratch
- [ ] I can set up GitHub webhook + Multibranch Pipeline integration end to end
- [ ] I can build, tag, push, and deploy a Docker image from a pipeline
- [ ] I can describe a production-hardening checklist (RBAC, backups, scaling, shared libraries)
