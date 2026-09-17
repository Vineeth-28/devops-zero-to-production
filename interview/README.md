# Interview Preparation

A complete DevOps interview-question bank built directly from the content of this repository. Every question is grounded in what's actually documented in `../01-linux/` through `../08-monitoring/` and `../production-runbooks/` — this isn't generic trivia, it's the same material this repo teaches, in interview form.

Each question follows the same format:

- **Difficulty** — 🟢 Easy / 🟡 Medium / 🔴 Production
- **What the interviewer is testing** — the underlying skill, not just the surface question
- **Expected Answer** — the technically correct explanation
- **Strong Interview Answer** — a natural, spoken 30-60 second answer you can actually say out loud
- **Follow-up Questions** — what a good interviewer asks next
- **Key Points** — the 3 things to hit if you say nothing else

## How to use this folder

- **Drilling a specific topic before an interview:** open that topic's file directly and go question by question, answering out loud before reading the model answer.
- **Final check before an interview:** use `final-devops-interview.md` as a timed, closed-book mock — 6 rounds plus a full incident scenario, questions-first so you can't peek at the answer by accident.
- **Fast refresh (15-30 min), not drilling:** use each module's `quick-revision.md` (e.g. `../01-linux/quick-revision.md`) instead of this folder — this folder is for depth and practice, quick-revision is for a fast recall pass.
- **Production troubleshooting specifically:** pair `production-troubleshooting.md` here (interview framing) with `../production-runbooks/` (the actual runbooks) — the runbooks are what you'd do live; this file is how you'd explain it in an interview.

## Files in this folder

| File | Topic | Covers |
|---|---|---|
| `linux.md` | Linux | CPU/disk/memory troubleshooting, SSH, systemd, permissions, inode exhaustion |
| `git-github.md` | Git & GitHub | merge/rebase, reset/revert, cherry-pick, reflog recovery, PR workflow, secret leaks |
| `docker.md` | Docker | images vs containers, networking/DNS, multi-stage builds, health checks, `.dockerignore`, tagging |
| `kubernetes.md` | Kubernetes | Pod lifecycle, CrashLoopBackOff/Pending/ImagePullBackOff, probes, Services/Ingress, rollouts, resource limits |
| `helm.md` | Helm | chart structure, upgrade/rollback mechanics, hooks, dependencies, CI/CD patterns |
| `terraform.md` | Terraform | state, remote backends/locking, modules, drift, import, lifecycle, Terraform vs Ansible |
| `ansible.md` | Ansible | inventory/playbook/play/task/module, idempotency, handlers, roles, Vault, UNREACHABLE vs FAILED |
| `jenkins.md` | Jenkins | Controller/Agent architecture, Declarative vs Scripted, Shared Libraries, RBAC, vs GitHub Actions |
| `github-actions.md` | GitHub Actions | workflow/job/step/runner, `needs`/`if`/`matrix`, secrets & fork PR risk, caching vs artifacts |
| `cicd.md` | CI/CD (cross-tool) | CI vs Delivery vs Deployment, pipeline design, cascading failure debugging, Docker-in-CI safety |
| `monitoring.md` | Monitoring | Prometheus pull model, metric types, PromQL (rate/histogram_quantile/error rate), Grafana vs Prometheus, Alertmanager |
| `production-troubleshooting.md` | Production Troubleshooting & Incident Response | the master framework, production layers, 502/503/504, blast radius, 5 Whys, postmortems, severity levels |
| `final-devops-interview.md` | Final Mock Interview | 6 timed rounds (Fundamentals, Practical, Troubleshooting, Production Scenarios, Architecture, Rapid Fire) + 1 full incident scenario |

## Cross-technology comparisons

These recur constantly in real interviews and are woven into the topic files above rather than isolated in their own file, since each comparison is best understood next to the tool it's comparing:

- Terraform vs Ansible → `terraform.md` Q8
- Docker image vs container → `docker.md` Q1
- Service vs Ingress → `kubernetes.md` Q12
- Readiness vs liveness → `kubernetes.md` Q7
- Jenkins vs GitHub Actions → `jenkins.md` Q6
- Merge vs rebase, reset vs revert → `git-github.md` Q3, Q12
- Prometheus vs Grafana, Alertmanager's role → `monitoring.md` Q7, Q8
- CI vs Continuous Delivery vs Continuous Deployment → `cicd.md` Q1
- Volumes vs bind mounts → `docker.md` Q10
- df vs du, command vs shell → `linux.md` Q2, `ansible.md` Q7

`final-devops-interview.md` Round 1 also drills all of these as rapid-fire one-liners in a single pass.

## Revision order recommendation

If preparing for an interview with limited time, this is the order that builds on itself:

1. `linux.md` + `git-github.md` — foundational, everything else assumes these
2. `docker.md` → `kubernetes.md` → `helm.md` — the containerization stack, in dependency order
3. `terraform.md` → `ansible.md` — infrastructure provisioning and configuration
4. `jenkins.md` / `github-actions.md` → `cicd.md` — CI/CD tools, then cross-tool pipeline thinking
5. `monitoring.md` — observability, ties the whole stack together
6. `production-troubleshooting.md` — the synthesis layer; hardest to do well without the above
7. `final-devops-interview.md` — timed, closed-book self-test once everything above feels solid
