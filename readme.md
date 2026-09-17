<div align="center">

# 🚀 DevOps Zero to Production

### A Production-First DevOps Engineering Roadmap

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)

*Not a course completion tracker. A production-engineering handbook, built by learning,*
*practicing, breaking, troubleshooting, and documenting every layer of the stack.*

</div>

---

## 📌 About This Repository

This repository is a hands-on, production-focused DevOps engineering
handbook — built module by module, from Linux fundamentals up through
Infrastructure as Code and Configuration Management.

It is **not** a collection of tutorial notes. Every module follows the
same discipline: understand the concept, build it hands-on, break it on
purpose, troubleshoot it like an incident, document the reasoning, and
revise it until it's interview-ready.

<div align="center">

**Learn → Understand → Practice → Explain → Apply**

</div>

---

## 📖 Table of Contents

- [Mission](#-mission)
- [Skills & Progress at a Glance](#-skills--progress-at-a-glance)
- [Learning Methodology](#-learning-methodology)
- [Repository Structure](#-repository-structure)
- [Module Deep Dives](#-module-deep-dives)
  - [🐧 Linux](#-linux)
  - [🔥 Git & GitHub](#-git--github)
  - [🐳 Docker](#-docker)
  - [🚀 CI/CD — Jenkins & GitHub Actions](#-cicd--jenkins--github-actions)
  - [☸️ Kubernetes](#️-kubernetes)
  - [⎈ Helm](#-helm)
  - [🌍 Terraform](#-terraform)
  - [⚙️ Ansible](#️-ansible)
- [🚨 Production Runbooks](#-production-runbooks)
- [🎯 Interview Preparation](#-interview-preparation)
- [Engineering Mindset](#-engineering-mindset)
- [Production Investigation Workflow](#-production-investigation-workflow)
- [What's Next](#-whats-next)
- [Long-Term Goal](#-long-term-goal)

---

## 🎯 Mission

Turn DevOps knowledge into real engineering ability — not memorized
commands. By the end of this roadmap, I aim to confidently:

| | |
|---|---|
| ✅ | Debug production incidents |
| ✅ | Understand Linux systems deeply |
| ✅ | Master Git collaboration workflows |
| ✅ | Build CI/CD pipelines end-to-end |
| ✅ | Deploy and operate containerized applications |
| ✅ | Manage Kubernetes clusters in production |
| ✅ | Package and release applications with Helm |
| ✅ | Provision cloud infrastructure with Terraform |
| ✅ | Configure and manage systems with Ansible |
| ⏳ | Monitor production workloads (Prometheus/Grafana) |

---

## 📊 Skills & Progress at a Glance

<div align="center">

| Module | Status | Core Skills |
|---|:---:|---|
| 🐧 **Linux** | ✅ Complete | Process mgmt, systemd, networking, logs, permissions, SSH, storage, perf & incident troubleshooting |
| 🔥 **Git & GitHub** | 🟡 89% (Day 8/9) | Internals, branching, merge/rebase, revert, cherry-pick, PR & collaboration workflows |
| 🐳 **Docker** | ✅ Complete | Images, volumes, networking, Compose, multi-stage builds, registries, security, production labs |
| 🚀 **CI/CD** | ✅ Complete | Jenkins (pipelines, RBAC, Shared Libraries) + GitHub Actions (matrix, environments, secrets) |
| ☸️ **Kubernetes** | ✅ Complete | Architecture, workloads, Services/DNS, storage, probes, production incident triage |
| ⎈ **Helm** | ✅ Complete | Charts, releases, rollbacks, dependencies, hooks, CI/CD packaging |
| 🌍 **Terraform** | ✅ Complete | State, modules, remote backends, AWS provisioning, CI/CD-gated applies |
| ⚙️ **Ansible** | ✅ Complete | Inventory, modules, idempotency, playbooks, roles, Vault, CI/CD integration |
| 🚨 **Production Runbooks** | ✅ Complete | 18 incident runbooks + master troubleshooting framework + layers model |
| 🎯 **Interview Preparation** | ✅ Complete | Full question bank across every module + a timed mock interview with an incident scenario |
| ☁️ **AWS** | ⏳ Planned | Deep-dive infrastructure module |
| 📊 **Monitoring** | ⏳ Planned | Prometheus, Grafana, alerting |
| 📦 **Projects** | ⏳ Planned | End-to-end capstone builds |

</div>

---

## 📚 Learning Methodology

Every module follows the same engineering workflow:

```
📖 Concept Revision  →  💻 Hands-on Practice  →  🚨 Production Scenarios
       ↓                                                    ↓
🔍 Root Cause Analysis  ←──────────────────  🎯 Interview Questions
       ↓
📝 Documentation  →  ✅ Committed to This Repo
```

The objective is retention through repetition and practical
implementation — not passive reading.

---

## 🗂 Repository Structure

```text
devops-zero-to-production/

├── 01-linux/
├── 02-git-github/
├── 03-docker/
├── 04-kubernetes/          (includes helm/)
├── 05-terraform/
├── 06-ansible/
├── 07-cicd/                (jenkins/ + github-actions/)
├── 08-monitoring/
├── 09-projects/
│
├── interview/              (per-module question bank + final mock interview)
├── pdf-notes/
├── production-runbooks/    (18 incident runbooks + master framework)
│
└── README.md
```

<details>
<summary><strong>📁 Expand full per-module folder layouts</strong></summary>

**`07-cicd/`**
```text
07-cicd/
├── jenkins/          (commands, jenkinsfiles, labs, troubleshooting, workflows, interview)
└── github-actions/   (workflows, examples, labs, troubleshooting, interview)
```

**`04-kubernetes/`**
```text
04-kubernetes/
├── commands/  manifests/  concepts/  troubleshooting/  workflows/  labs/  interview/
└── helm/  (commands, concepts, charts/backend, labs, troubleshooting, workflows, interview)
```

**`05-terraform/`**
```text
05-terraform/
├── commands/  concepts/
├── aws/       (provider.tf, variables.tf, outputs.tf, main.tf, networking/, compute/, storage/)
├── modules/   (vpc/, ec2/, security-group/)
├── labs/      (day-29-fundamentals, day-30-state, day-31-production)
└── troubleshooting/  workflows/  interview/
```

**`06-ansible/`**
```text
06-ansible/
├── commands/       (ansible-basics, inventory, ad-hoc-commands, playbook-commands)
├── playbooks/      (site.yml, webserver.yml, deploy.yml)
├── roles/          templates/
├── troubleshooting/  workflows/  interview/
```

**`production-runbooks/`** (flat, one file per incident type)
```text
production-runbooks/
├── README.md                          (master framework + layers model + index)
├── 502-bad-gateway.md
├── 503-service-unavailable.md
├── 504-gateway-timeout.md
├── high-cpu.md
├── memory-issue.md
├── disk-full.md
├── pod-crashloopbackoff.md
├── pod-pending.md
├── image-pull-backoff.md
├── deployment-failure.md
├── service-not-working.md
├── ingress-issue.md
├── ci-pipeline-failure.md
├── docker-build-failure.md
├── terraform-failure.md
├── ansible-unreachable.md
├── database-connection.md
└── incident-response.md             (severity, lifecycle, RCA, postmortem template)
```

**`interview/`** (question bank, one file per module + a final mock)
```text
interview/
├── README.md                        (hub index + cross-technology map + revision order)
├── linux.md
├── git-github.md
├── docker.md
├── kubernetes.md
├── helm.md
├── terraform.md
├── ansible.md
├── jenkins.md
├── github-actions.md
├── cicd.md
├── monitoring.md
├── production-troubleshooting.md
└── final-devops-interview.md        (6 timed rounds + a full incident scenario)
```

</details>

---

## 🛠 Module Deep Dives

### 🐧 Linux

Process management, systemd services, networking, logs, permissions,
users & groups, SSH, storage, performance monitoring — and production
troubleshooting for all of it. **Complete.**

---

### 🔥 Git & GitHub

Fundamentals → internals (objects, SHA-1, HEAD) → branching → merge →
rebase/reset/reflog → GitHub collaboration workflows → revert →
cherry-pick. One day remaining: the **Production Git Challenge**.

<details>
<summary><strong>🍒 Cherry-pick architecture (sample diagram from this module)</strong></summary>

```text
Selected Commit → Read Commit → Generate Patch → Apply Patch
      → Create NEW Commit → Move HEAD Forward
```

</details>

<details>
<summary><strong>🗝 Key production learnings</strong></summary>

- Cherry-pick copies commits (new hashes) — it never moves the originals.
- `--no-commit` stages without committing; `--continue`/`--abort` manage an interrupted cherry-pick.
- Cherry-pick and rebase can both cause conflicts, but for different structural reasons — worth being able to explain the difference cold in an interview.

</details>

---

### 🐳 Docker

Fundamentals → Images/Dockerfile → Volumes & Bind Mounts → Networking →
Compose → Production Docker (multi-stage builds, health checks, resource
limits) → Registry (Docker Hub, ECR) → Security → a full **Node.js +
MySQL production lab** → final interview challenge. **Complete.**

```text
Developer → Dockerfile → Multi-stage Build → Optimized Image
    → Registry → Production Server → Running Container
```

<details>
<summary><strong>🗝 Key production learnings</strong></summary>

- Containers are ephemeral — the writable layer dies with the container; Volumes persist independently and are the right tool for databases.
- Custom bridge networks get Docker DNS (service-name resolution); the default bridge doesn't.
- Multi-stage builds separate build tooling from the runtime image — smaller, safer, faster to ship.
- `depends_on` controls startup *order*, not readiness — `service_healthy` + health checks close that gap.
- Relying on the `latest` tag in production is a silent-change risk; semantic version tags are what make rollbacks reliable.

</details>

---

### 🚀 CI/CD — Jenkins & GitHub Actions

**Jenkins track:** architecture (Controller/Agent) → jobs & declarative
pipelines → GitHub integration & webhooks → Docker-in-pipeline builds →
production hardening (RBAC, credential scoping, backup/restore, Shared
Libraries).

**GitHub Actions track:** workflow/job/step/runner fundamentals →
`needs`/`if`/matrix builds → secrets & environments → Docker build/push
→ protected production environments with approval gates.

**Complete — both tracks.**

```text
Developer → GitHub → CI (Jenkins / GH Actions) → Build → Test
    → Docker Build/Push → Registry → Production Deployment
```

<details>
<summary><strong>🗝 Key production learnings</strong></summary>

- Webhooks beat SCM polling for both speed and load — poll only as a fallback.
- Docker-outside-of-Docker (socket mount) vs Docker-in-Docker is a real security trade-off, not just a config choice.
- Tag images with a traceable identifier (`github.sha` / build number) — never ship on `latest` alone, or rollback loses precision.
- Scope credentials and `permissions:` to least privilege by default — a pipeline that *can* touch everything eventually *will*.

</details>

---

### ☸️ Kubernetes

Architecture (API Server, etcd, Scheduler, Kubelet) → Pods/Deployments/
ReplicaSets & self-healing → Services/DNS/EndpointSlices → Storage,
ConfigMaps, Secrets & health probes → a master production troubleshooting
flow covering `CrashLoopBackOff`, `OOMKilled`, `ImagePullBackOff`, and
broken Services end-to-end. **Complete.**

```text
kubectl → API Server → Scheduler → Worker Node → Kubelet
    → Container Runtime → Pod
```

<details>
<summary><strong>🗝 Key production learnings</strong></summary>

- The API Server is the *only* thing kubectl talks to — the Scheduler decides placement, the Kubelet on the assigned node actually starts containers.
- EndpointSlices only ever include Pods that are currently *Ready* — a Running-but-not-Ready Pod is silently excluded from traffic.
- A Kubernetes Secret is base64-**encoded**, not encrypted, by default — real security needs etcd encryption at rest or an external secrets manager.
- Liveness failing restarts the container; Readiness failing only pulls it from Service endpoints — conflating the two causes worse incidents, not fewer.
- Root causes are often several layers from the visible symptom — trace the whole chain (`get pods` → `describe` → `logs` → `events` → Service → PVC → Nodes) instead of fixing the first abnormal-looking thing.

</details>

---

### ⎈ Helm

Once raw manifest count grows, hand-maintaining YAML doesn't scale. Helm
packages Kubernetes manifests into versioned, parameterized Charts —
covering Chart structure, `.Values`/`.Release`/`.Chart`, install/upgrade/
rollback, dependencies, hooks, and CI/CD packaging. **Complete.**

```text
Kubernetes → Many YAML manifests → Helm → Chart + Values + Templates
    → Rendered manifests → Kubernetes API → Resources
```

<details>
<summary><strong>🗝 Key production learnings</strong></summary>

- `helm upgrade --install` is the idempotent pattern CI/CD pipelines should use — installs if missing, upgrades if present.
- Every `install`/`upgrade` creates a new numbered revision; `helm rollback <release> <n>` reverts to any prior one instantly.
- A "successful" `helm upgrade` only confirms the manifests were *applied* — it does not confirm the workload is *healthy*. That's still a Kubernetes-level check.

</details>

---

### 🌍 Terraform

Infrastructure as Code — the reconciliation loop (`plan` diffs code ⇄
state ⇄ real infrastructure), state management and drift, modules, remote
backends with locking, AWS provisioning end-to-end, and Terraform + CI/CD
with gated applies. **Complete.** Full module handbook: `05-terraform/README.md`.

```text
Terraform Code → terraform init → terraform plan
    → Review → terraform apply → Infrastructure
```

<details>
<summary><strong>🗝 Key production learnings</strong></summary>

- State is not a copy of infrastructure — it's the mapping between config and real resources, plus metadata `plan` needs to compute a diff.
- A backend controls *where* state lives; a provider controls *how* resources are created — commonly confused, cleanly separate.
- Remote state + locking is what makes Terraform safe for more than one person or CI job to run concurrently.
- `prevent_destroy` is a deliberate safety rail for critical resources — not a blanket default.
- A reviewed `terraform plan` before every production `apply` is the same discipline as code review: the plan output *is* the diff about to hit real infrastructure.

</details>

---

### ⚙️ Ansible

Configuration management — the layer directly after Terraform: agentless
architecture, inventory & host patterns, modules & idempotency, playbooks/
variables/conditions/loops/handlers, Jinja2 templates, roles, Ansible
Vault, and a 17-scenario production troubleshooting handbook. **Complete.**
Full module handbook: `06-ansible/README.md`.

```text
Control Node → Inventory → SSH / WinRM → Managed Nodes
```

```text
Terraform → AWS → EC2 provisioned → Ansible
    → Install Docker → Configure Nginx → Deploy App → Services Running
```

<details>
<summary><strong>🗝 Key production learnings</strong></summary>

- Agentless means no persistent daemon on managed nodes — everything runs over SSH/WinRM on demand, then disconnects.
- `command`/`shell` are **not** idempotent by default — they always report `changed` unless you add `changed_when`; prefer a dedicated module whenever one exists.
- Handlers fire only on a `changed` notify, and only once per play regardless of how many tasks notify them — a silent no-op is almost always a typo'd handler name.
- Terraform and Ansible split cleanly by layer: Terraform provisions and owns state; Ansible configures and re-checks idempotently on every run with no persistent state file of its own.
- Ansible Vault encrypts secrets so they're safe in Git — but the vault password itself belongs in a CI secret manager, never in the repo.

</details>

---

## 🚨 Production Runbooks

Incident-response runbooks for `production-runbooks/` — meant to be
opened *during* an incident, not read once and forgotten. **Complete —
18 runbooks** covering HTTP errors, Linux resource incidents, the full
set of common Kubernetes failure states, CI/CD and Docker build
failures, Terraform failures, Ansible `UNREACHABLE`, and database
connection failures — plus a general Incident Response runbook covering
severity levels, the incident lifecycle, root cause analysis, and a
postmortem template.

Every runbook follows the same shape: Incident Summary → Symptoms →
Impact → Possible Causes → First 5 Minutes → Troubleshooting Flow →
Commands (each with what it checks / why we run it / what to look for)
→ Root Cause Examples → Immediate Mitigation → Permanent Fix →
Verification → Prevention → Post-Incident Checklist → Interview
Explanation.

**Master troubleshooting framework** (documented in
`production-runbooks/README.md`):

```text
Incident → Confirm Symptom → Determine Impact/Blast Radius
    → Check Recent Changes → Identify Affected Layer
    → Collect Evidence (Metrics + Logs + Events) → Investigate
    → Root Cause → Mitigate → Verify Recovery
    → Prevent Recurrence → Document / Postmortem
```

**Production layers model** — troubleshoot by walking the layers
systematically instead of randomly changing things:

```text
User/Request → DNS/Network → Load Balancer/Ingress → Service
    → Kubernetes → Container → Application → Database/External Dependency
```

<details>
<summary><strong>🗝 Key production learnings</strong></summary>

- 502 vs 503 vs 504 are three different failure points: an invalid
  response from upstream, no healthy upstream at all, and an upstream
  that's reachable but too slow, respectively.
- `CrashLoopBackOff` is a *state*, not a root cause — always check the
  exit code and `kubectl logs --previous` before forming a hypothesis.
- "Pod is Running" doesn't mean "Service can route to it" — Endpoints
  only ever include pods that are both label-matched *and* Ready.
- Don't blame the database first — most "database is down" incidents
  resolve to DNS, network, or a security-group rule sitting between the
  app and a perfectly healthy database.
- Finding the *first* failing step in a CI pipeline (not the last
  cascading error) is almost always the fastest path to root cause.

</details>

---

## 🎯 Interview Preparation

A complete interview question bank in `interview/` — one file per
module, built directly from what's actually documented in this repo,
not generic trivia. **Complete — 13 topic files plus a timed final mock
interview.**

Every question follows the same shape: Difficulty → What the interviewer
is testing → Expected Answer → a natural, spoken Strong Interview Answer
→ Follow-up Questions → Key Points to hit if nothing else lands.

```text
interview/
├── linux.md · git-github.md · docker.md · kubernetes.md · helm.md
├── terraform.md · ansible.md · jenkins.md · github-actions.md · cicd.md
├── monitoring.md · production-troubleshooting.md
└── final-devops-interview.md   (6 timed rounds + a full incident scenario)
```

The final mock interview closes with a single large production incident
— a checkout service throwing 502s minutes after a deploy — worked
through as a real interview would run it: first actions, blast radius,
hypothesis, evidence, mitigation decision, and postmortem action item.

See [`interview/README.md`](./interview) for the full topic index, the
cross-technology comparison map (merge vs rebase, Terraform vs Ansible,
readiness vs liveness, and more), and a recommended revision order.

---

## 🧠 Engineering Mindset

| ❌ Instinct | ✅ Discipline |
|---|---|
| Memorize commands | Understand systems |
| Restart services immediately | Investigate first |
| Guess the problem | Collect evidence |
| Fix symptoms | Find the root cause |

---

## 🔍 Production Investigation Workflow

```text
Incident → Investigate → Collect Evidence → Find Root Cause
    → Apply Fix → Verify → Prevent Recurrence
```

Applied consistently across every module — this is the same loop whether
it's a crashing Pod, a failed Terraform apply, a Jenkins pipeline
failure, or an `UNREACHABLE` Ansible run. The full incident-response
version of this loop, with commands and interview framing for each
scenario, lives in [`production-runbooks/`](./production-runbooks).

---

## 🎯 What's Next

- ☁️ **AWS Infrastructure Deep Dive**
- 📊 **Monitoring & Alerting** (Prometheus, Grafana)
- 📦 **End-to-end capstone projects**
- 🔥 **Production Git Challenge** (final Git module day)

---

## ⭐ Long-Term Goal

By the end of this roadmap, this repository will contain complete
revision notes, hands-on labs, production runbooks, interview
preparation, and real-world troubleshooting scenarios across the entire
DevOps stack — a portfolio that demonstrates practical engineering
ability, not just completed courses.

<div align="center">

---

**Learn → Understand → Practice → Explain → Apply**

🚀 **DevOps Zero to Production**

</div>