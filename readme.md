# 🚀 DevOps Zero to Production

## Production-First DevOps Roadmap

> A structured, hands-on journey to becoming a production-ready DevOps Engineer.

This repository documents my journey of learning DevOps through hands-on labs, production troubleshooting, infrastructure automation, and real-world engineering scenarios.

This is **not** a collection of tutorials or random notes.

It is a production-focused engineering handbook built by learning, practicing, troubleshooting, documenting, and revising every topic from first principles.

---

# 🎯 Mission

The goal is to transform DevOps knowledge into real engineering ability.

Instead of memorizing commands, the focus is on understanding how systems work, identifying root causes, debugging production incidents, and building reliable infrastructure.

By the end of this roadmap, I aim to confidently:

- ✅ Debug production incidents
- ✅ Understand Linux systems
- ✅ Master Git collaboration workflows
- ✅ Build CI/CD pipelines
- ✅ Deploy containerized applications
- ✅ Manage Kubernetes clusters
- ✅ Automate cloud infrastructure
- ✅ Monitor production workloads
- ✅ Think like a DevOps Engineer

---

# 📈 Roadmap Progress

| Module | Status |
|---------|--------|
| 🐧 Linux | ✅ Completed |
| 🔥 Git & GitHub | 🟡 In Progress (Day 08/09) |
| 🐳 Docker | 🟡 In Progress (Day 04/10) |
| ☸️ Kubernetes | ⏳ Planned |
| ☁️ AWS | ⏳ Planned |
| 🌍 Terraform | ⏳ Planned |
| ⚙️ Ansible | ⏳ Planned |
| 🚀 CI/CD | ⏳ Planned |
| 📊 Monitoring | ⏳ Planned |
| 📦 Projects | ⏳ Planned |

---

# 📅 Current Progress

```text
Linux                 ████████████████████ 100%

Git & GitHub          █████████████████░░░ 89%

Docker                ████████░░░░░░░░░░░░ 40%

Kubernetes            ░░░░░░░░░░░░░░░░░░░░

Terraform             ░░░░░░░░░░░░░░░░░░░░

Ansible               ░░░░░░░░░░░░░░░░░░░░

CI/CD                 ░░░░░░░░░░░░░░░░░░░░

Monitoring            ░░░░░░░░░░░░░░░░░░░░
```

---

# 📚 Learning Methodology

Every module follows the same engineering workflow:

- 📖 Concept Revision
- 💻 Hands-on Practice
- 🎯 Interview Questions
- 🚨 Production Scenarios
- 🔍 Root Cause Analysis (RCA)
- 📝 Documentation
- 📄 Revision PDFs
- ✅ GitHub Commit

The objective is to retain knowledge through repetition and practical implementation rather than passive learning.

---

# 🛠 Technologies Covered

## 🐧 Linux ✅

- Process Management
- Services (systemd)
- Networking
- Logs
- Permissions
- Users & Groups
- SSH
- Storage
- Performance Monitoring
- Production Troubleshooting

---

## 🔥 Git & GitHub 🟡

### ✅ Completed

#### Git Fundamentals

- Git
- Version Control
- Git vs GitHub
- Working Directory
- Staging Area
- Local Repository
- Remote Repository

#### Git Internals

- Git Object Database
- Blob Objects
- Tree Objects
- Commit Objects
- SHA-1
- HEAD
- Detached HEAD

#### Git Branching

- Git Branches
- Branch Pointers
- git switch
- git checkout
- Branch Deletion
- Git Flow
- GitHub Flow
- Trunk-Based Development

#### Git Merge

- Git Merge
- Fast-Forward Merge
- Three-Way Merge
- Merge Base
- Merge Commit
- Merge Conflicts
- Conflict Resolution
- ORT Merge Strategy
- Pull Request Workflow
- Merge Best Practices

#### Git Rebase, Reset & Reflog

- Git Rebase
- Merge vs Rebase
- Linear History
- Interactive Rebase (Squash, Reword, Edit, Drop)
- Git Reset (Soft, Mixed, Hard)
- Git Reflog
- Commit Recovery
- Production Rebase Workflow

#### GitHub Workflow & Collaboration

- Remote Repositories (origin vs upstream)
- git clone, git remote, git fetch, git pull, git push
- Remote Tracking Branches
- Fast-Forward vs Non-Fast-Forward Push
- GitHub Flow
- Pull Requests & Code Reviews
- Branch Protection Rules
- Multi-Developer Collaboration

#### Git Revert

- Git Revert vs Git Reset
- Internal Working of Git Revert
- Reverting Latest / Specific / Multiple Commits
- git revert --no-commit
- Reverting Merge Commits (git revert -m 1)
- Production Rollback Workflow

#### ✅ Day 08 – Git Cherry-pick

- What is Git Cherry-pick?
- Cherry-pick vs Merge
- Cherry-pick vs Rebase
- Cherry-pick vs Revert
- Internal Working of Cherry-pick
- Cherry-pick Single Commit
- Cherry-pick Multiple Commits
- Cherry-pick Commit Range
- `git cherry-pick --no-commit`
- `git cherry-pick --continue`
- `git cherry-pick --abort`
- Production Hotfix Workflow
- Best Practices

### ⏳ Upcoming

- Production Git Challenge

---

## 🐳 Docker 🟡

### ✅ Completed

#### Day 01 – Docker Fundamentals

- What is Docker?
- Containers vs Virtual Machines
- Docker Architecture (Client, Daemon, Registry)
- Docker Images vs Containers
- Docker Installation
- Docker CLI Basics

#### Day 02 – Docker Images & Dockerfile

- Docker Images
- Dockerfile & Dockerfile Instructions
- Image Layers
- UnionFS
- Build Cache
- Docker Build Best Practices

#### Day 03 – Docker Volumes & Bind Mounts

- Container Writable Layer
- Why Container Data is Lost
- Persistent Storage
- Docker Volumes
- Creating Volumes
- Mounting Volumes
- Volume Lifecycle
- Sharing Volumes Between Containers
- Docker Volume vs Bind Mount
- Production Use Cases
- Development Use Cases

**Commands Practiced (Day 03):**

- `docker volume create`
- `docker volume ls`
- `docker volume inspect`
- `docker volume rm`
- `docker run -v`
- `docker rm`
- `docker exec`

**Practical Lab (Day 03):**

- Created Docker Volume
- Mounted Volume into Nginx Container
- Modified index.html
- Verified Changes in Browser
- Deleted Container
- Recreated Container
- Verified Persistent Data
- Compared Docker Volumes with Bind Mounts

**Key Learnings (Day 03):**

- Containers are ephemeral.
- Writable layers are deleted with containers.
- Docker Volumes persist independently.
- Multiple containers can share a single volume.
- Docker Volumes are ideal for databases.
- Bind Mounts are best suited for local development.

#### ✅ Day 04 – Docker Networking

- Docker Networks
- Bridge Network
- Host Network
- None Network
- Custom Bridge Network
- Docker DNS
- Container Communication
- Multiple Networks
- Port Mapping
- Host Port vs Container Port
- Docker Network Commands
- Production Networking

**Commands Practiced (Day 04):**

- `docker network ls`
- `docker network inspect`
- `docker network create`
- `docker network connect`
- `docker network disconnect`
- `docker run --network`
- `docker run -p`

**Key Learnings (Day 04):**

- Containers on the default bridge network can't resolve each other by name — only custom bridge networks get Docker DNS.
- Custom Bridge Networks enable automatic service discovery between containers via container name.
- Host Network removes network isolation, binding the container directly to the host's network stack.
- None Network disables networking entirely for a container.
- Port Mapping (`-p host:container`) exposes a container's internal port to the host.
- `localhost` inside one container does not refer to another container — container-to-container communication requires the Docker network, not localhost.

### ⏳ Upcoming

- Docker Compose
- Multi-stage Builds
- Container Debugging
- Production Docker Challenge

---

## ☸️ Kubernetes

- Pods
- Deployments
- ReplicaSets
- Services
- ConfigMaps
- Secrets
- Ingress
- Helm
- Production Troubleshooting

---

## ☁️ Cloud & Infrastructure

- AWS
- EC2
- IAM
- VPC
- Load Balancer
- Auto Scaling
- Terraform
- Ansible

---

## 🚀 CI/CD

- Jenkins
- GitHub Actions
- Build Pipelines
- Automated Deployment
- Rollback Strategy

---

## 📊 Monitoring & Observability

- Prometheus
- Grafana
- Node Exporter
- Alerting
- Incident Response

---

# 📂 Repository Structure

```text
devops-zero-to-production/

├── 01-linux/
├── 02-git-github/
├── 03-docker/
├── 04-kubernetes/
├── 05-terraform/
├── 06-ansible/
├── 07-cicd/
├── 08-monitoring/
├── 09-projects/
│
├── interview/
├── pdf-notes/
├── production-runbooks/
│
└── README.md
```

### 02-git-github/ additions for Day 08

```text
commands/
    cherry-pick.md

troubleshooting/
    cherry-pick-recovery.md

workflows/
    cherry-pick-workflow.md

pdfs/
    Day-08-Cherry-pick.pdf
```

### 03-docker/ additions for Day 03

```text
commands/
    docker-volumes.md

troubleshooting/
    docker-volumes.md

workflows/
    docker-volume-workflow.md

pdfs/
    Day-03-Docker-Volumes.pdf
```

### 03-docker/ additions for Day 04

```text
commands/
    docker-networking.md

troubleshooting/
    docker-networking.md

workflows/
    docker-network-workflow.md

pdfs/
    Day-04-Docker-Networking.pdf
```

---

# 🚨 Production Scenarios

## ✅ Completed

### Linux

- Production Troubleshooting
- Service Failure Investigation
- High CPU Investigation
- High Memory Investigation
- Permission Issues
- SSH Login Failures
- Disk Full Investigation
- Log Analysis
- Root Cause Analysis
- End-to-End Production Challenge

### Git

- Detached HEAD Investigation
- Branch Pointer Inspection
- Branch Storage Investigation
- Branch Switching
- Branch Deletion
- HEAD Movement
- Fast-Forward Merge
- Three-Way Merge
- Merge Conflict Resolution
- Pull Request Workflow
- Code Review Workflow
- Interactive Rebase before PR
- Squashing Commits
- Cleaning Commit History
- Git Rebase Recovery
- Git Reset Recovery
- Git Reflog Recovery
- Recover Deleted Branch
- Safe Force Push
- Configure GitHub Remote
- Clone Existing Repository
- Add Remote Repository
- Push First Project
- Track Remote Branches
- Fetch Remote Changes
- Pull Latest Changes
- Push Local Changes
- Resolve Remote Merge Conflicts
- Handle Non-Fast-Forward Push
- Collaborate with Multiple Developers
- Pull Request Review Workflow
- Branch Protection Workflow
- Rollback Failed Deployment
- Rollback Production Bug
- Undo Faulty Feature
- Rollback Merge Commit
- Emergency Production Rollback
- Multiple Commit Rollback
- Cherry-pick Hotfix
- Backport Production Fix
- Cherry-pick Multiple Commits
- Cherry-pick Commit Range
- Cherry-pick Conflict Resolution
- Selective Feature Migration

### Docker

- Container Data Loss Investigation (Ephemeral Writable Layer)
- Persistent Storage Verification with Docker Volumes
- Bind Mount vs Volume Comparison
- Sharing a Volume Across Multiple Containers
- Container-to-Container Communication Failure (Default Bridge vs Custom Bridge)
- Docker DNS Resolution Investigation
- Port Mapping / Exposed Port Troubleshooting

---

## ⏳ Upcoming

- Docker Compose Multi-Container Issues
- Kubernetes CrashLoopBackOff
- ImagePullBackOff
- Jenkins Pipeline Failures
- AWS Infrastructure Issues
- Terraform State Problems

---

# 📖 Repository Philosophy

The goal is not to memorize commands.

The goal is to understand systems well enough to answer questions like:

- Why did the application fail?
- Why is CPU usage high?
- Why is memory increasing?
- Why is the deployment failing?
- Why is Kubernetes restarting the pod?

Every production issue should be investigated before applying a fix.

---

# 🧠 Engineering Mindset

❌ Memorize Commands

✅ Understand Systems

---

❌ Restart Services Immediately

✅ Investigate First

---

❌ Guess the Problem

✅ Collect Evidence

---

❌ Fix Symptoms

✅ Find the Root Cause

---

# 🔍 Production Investigation Workflow

```text
Incident
      │
      ▼
Investigate
      │
      ▼
Collect Evidence
      │
      ▼
Find Root Cause
      │
      ▼
Apply Fix
      │
      ▼
Verify
      │
      ▼
Prevent Recurrence
```

---

# 🍒 Git Cherry-pick Architecture

```text
Selected Commit
      │
      ▼
Read Commit
      │
      ▼
Generate Patch
      │
      ▼
Apply Patch
      │
      ▼
Create NEW Commit
      │
      ▼
Move HEAD Forward
```

---

# 🩹 Production Hotfix Workflow

```text
Production Bug
      │
      ▼
Create Hotfix
      │
      ▼
Commit
      │
      ▼
git cherry-pick
      │
      ▼
Release Branch
      │
      ▼
Deploy
```

---

# 💾 Docker Volume Persistence Architecture

```text
Container Writable Layer
      │
      ▼
Container Deleted
      │
      ▼
Writable Layer Lost
      │
      ▼
Docker Volume (Separate from Container)
      │
      ▼
Data Survives Container Deletion
      │
      ▼
New Container Mounts Same Volume
      │
      ▼
Data Restored
```

---

# 🌐 Docker Networking Architecture

```text
Browser

localhost:8080
      │
      ▼
Host Port 8080
      │
      ▼
Docker Network
      │
      ▼
Container Port 80
      │
      ▼
Nginx
```

```text
Developer
     │
     ▼
Docker Client
     │
     ▼
Docker Engine
     │
     ▼
Docker Daemon
     │
 ┌───┴────────────┐
 ▼                ▼
Images       Containers
                 │
      ┌──────────┴──────────┐
      ▼                     ▼
Volumes              Networks
                 │
                 ▼
            Docker DNS
```

---

# 📊 Git Learning Progress

## ✅ Completed

- Git Fundamentals
- Git Internals
- Git Branching
- Merge & Merge Conflicts
- Rebase, Reset & Reflog
- GitHub Workflow & Collaboration
- Git Revert
- Git Cherry-pick

## ⏳ Remaining

- Production Git Challenge

---

# 📊 Docker Learning Progress

## ✅ Completed

- Docker Fundamentals
- Docker Images & Dockerfile
- Docker Volumes & Bind Mounts
- Docker Networking

## ⏳ Remaining

- Docker Compose
- Multi-stage Builds
- Container Debugging
- Production Docker Challenge

---

# 🧰 Commands Practiced — Git Cherry-pick

```md
## Git Cherry-pick

- `git cherry-pick <commit_hash>`
- `git cherry-pick commit1 commit2`
- `git cherry-pick A^..D`
- `git cherry-pick --no-commit <commit_hash>`
- `git cherry-pick --continue`
- `git cherry-pick --abort`
- `git cherry-pick --skip`
- `git show <commit_hash>`
```

---

# 🧰 Commands Practiced — Docker Volumes

```md
## Docker Volumes

- `docker volume create`
- `docker volume ls`
- `docker volume inspect`
- `docker volume rm`
- `docker run -v`
- `docker rm`
- `docker exec`
```

---

# 🧰 Commands Practiced — Docker Networking

```md
## Docker Networking

- `docker network ls`
- `docker network inspect`
- `docker network create`
- `docker network connect`
- `docker network disconnect`
- `docker run --network`
- `docker run -p`
```

---

# 🧠 Core Concepts — Git Cherry-pick

```text
Git Cherry-pick
Patch
Patch Application
Commit Copy
Hotfix Branch
Backport
Cherry-pick Workflow
Selective Commit Transfer
```

---

# 🧠 Core Concepts — Docker Volumes

```text
Container Writable Layer
Ephemeral Storage
Persistent Storage
Docker Volumes
Volume Lifecycle
Bind Mounts
Shared Volumes
Volume vs Bind Mount
```

---

# 🧠 Core Concepts — Docker Networking

```text
Docker Networks
Docker DNS
Bridge Network
Custom Bridge Network
Host Network
None Network
Port Mapping
Container Communication
```

---

# 🗝 Key Learnings — Git Cherry-pick

- Git Cherry-pick copies commits instead of moving them.
- Cherry-pick creates new commit hashes.
- Original commits remain unchanged.
- Cherry-pick is ideal for hotfixes and backports.
- Cherry-pick may produce merge conflicts.
- `--no-commit` stages changes without creating a commit.
- `--continue` resumes an interrupted Cherry-pick.
- `--abort` cancels an in-progress Cherry-pick.

---

# 🗝 Key Learnings — Docker Volumes & Bind Mounts

- Containers are ephemeral.
- Writable layers are deleted with containers.
- Docker Volumes persist independently.
- Multiple containers can share a single volume.
- Docker Volumes are ideal for databases.
- Bind Mounts are best suited for local development.

---

# 🗝 Key Learnings — Docker Networking

- Containers on the default bridge network can't resolve each other by name — only custom bridge networks get Docker DNS.
- Custom Bridge Networks enable automatic service discovery between containers via container name.
- Host Network removes network isolation, binding the container directly to the host's network stack.
- None Network disables networking entirely for a container.
- Port Mapping (`-p host:container`) exposes a container's internal port to the host.
- `localhost` inside one container does not refer to another container — container-to-container communication requires the Docker network, not localhost.

---

# 🎤 Interview Questions — Git Cherry-pick

```md
## Git Cherry-pick

- What is Git Cherry-pick?
- Cherry-pick vs Merge?
- Cherry-pick vs Rebase?
- Cherry-pick vs Revert?
- Why does Cherry-pick create a new commit?
- What happens internally during Cherry-pick?
- What is `git cherry-pick --no-commit`?
- What does `git cherry-pick --continue` do?
- What does `git cherry-pick --abort` do?
- Can Cherry-pick create merge conflicts?
- Production use cases of Cherry-pick?
```

---

# 🎤 Interview Questions — Docker Volumes

```md
## Docker Volumes & Bind Mounts

- Why is data lost when a container is deleted?
- What is a Docker Volume?
- How is a Volume different from a Bind Mount?
- Where are Docker Volumes stored on disk?
- Can multiple containers share the same Volume?
- When would you use a Bind Mount over a Volume in production?
- How do you back up data stored in a Docker Volume?
- What happens to a Volume when its container is removed?
```

---

# 🎤 Interview Questions — Docker Networking

```md
## Docker Networking

- What is Docker Networking?
- Bridge vs Host Network?
- Docker DNS?
- How do containers communicate?
- Why use Custom Networks?
- Explain Port Mapping.
- Why doesn't localhost work between containers?
- Explain Docker Architecture.
```

---

# 🗺 Git Revision Cheat Sheet

```text
Git Rebase
   │
   ▼
Reset
   │
   ▼
Reflog
   │
   ▼
Revert
   │
   ▼
Cherry-pick
   │
   ▼
Production Git Challenge
```

---

# 🗺 Docker Revision Cheat Sheet

```text
Docker Fundamentals
   │
   ▼
Docker Images & Dockerfile
   │
   ▼
Docker Volumes & Bind Mounts
   │
   ▼
Docker Networks
   │
   ▼
Docker Compose
   │
   ▼
Multi-stage Builds
   │
   ▼
Production Docker Challenge
```

---

# 🎯 Final Objective

Become confident handling:

- Linux Production Servers
- Git Collaboration
- Dockerized Applications
- Kubernetes Clusters
- AWS Infrastructure
- Infrastructure as Code
- CI/CD Pipelines
- Monitoring & Alerting
- Production Incidents
- DevOps Interviews

Git Cherry-pick enables selective commit transfer between branches, making it an essential tool for production hotfixes, release backports, and maintaining stable release branches without merging unrelated changes.

Docker Volumes decouple data from the container lifecycle, making them essential for running stateful workloads like databases reliably in production.

Docker Networking enables secure, isolated, and discoverable communication between containers, forming the backbone of any multi-container production application.

> **Learning DevOps tools is easy.**

> **Operating production systems with confidence is engineering.**

---

# ✅ Current Status

- ✅ Linux Module Completed
- 🟡 Git Module In Progress (Day 08 of 09)
- ✅ Day 01 – Git Fundamentals
- ✅ Day 02 – Git Internals
- ✅ Day 03 – Branches
- ✅ Day 04 – Merge
- ✅ Day 05 – Rebase, Reset & Reflog
- ✅ Day 06 – GitHub Workflow & Collaboration
- ✅ Day 07 – Git Revert
- ✅ Day 08 – Git Cherry-pick
- ⏳ Day 09 – Production Git Challenge
- 🟡 Docker Module In Progress (Day 04 of 10)
- ✅ Day 01 – Docker Fundamentals
- ✅ Day 02 – Docker Images & Dockerfile
- ✅ Day 03 – Docker Volumes & Bind Mounts
- ✅ Day 04 – Docker Networking
- ⏳ Day 05 – Docker Compose

Building one production-ready skill at a time.

---

# ⭐ Long-Term Goal

By the end of this roadmap, this repository will contain:

- Complete revision notes
- Hands-on labs
- Production runbooks
- Interview preparation
- Revision PDFs
- Real-world troubleshooting scenarios
- End-to-end DevOps projects

The objective is to build a portfolio that demonstrates practical engineering skills rather than simply completed courses.

---

> **Learn → Understand → Practice → Explain → Apply**

🚀 **DevOps Zero to Production**
