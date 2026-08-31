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
| 🐳 Docker | ✅ Completed |
| 🚀 CI/CD | ✅ Jenkins + GitHub Actions Completed |
| ☸️ Kubernetes | ✅ Completed |
| ☁️ AWS | ⏳ Planned |
| 🌍 Terraform | ⏳ Planned |
| ⚙️ Ansible | ⏳ Planned |
| 📊 Monitoring | ⏳ Planned |
| 📦 Projects | ⏳ Planned |

---

# 📅 Current Progress

```text
Linux                 ████████████████████ 100%
Git & GitHub          █████████████████░░░ 89%
Docker                ████████████████████ 100%
CI/CD (Jenkins + GA)  ████████████████████ 100%
Kubernetes            ████████████████████ 100%
Terraform             ░░░░░░░░░░░░░░░░░░░░
Ansible               ░░░░░░░░░░░░░░░░░░░░
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

#### Day 08 – Git Cherry-pick

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

## 🐳 Docker ✅

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

#### Day 04 – Docker Networking

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

#### Day 05 – Docker Compose

- What is Docker Compose?
- Why Docker Compose?
- docker-compose.yml
- Services
- Build vs Image
- Container Name
- Ports
- Environment Variables
- Volumes
- Networks
- depends_on
- Multi-container Applications
- Production Workflow

**Commands Practiced (Day 05):**

- `docker compose up`
- `docker compose up -d`
- `docker compose down`
- `docker compose ps`
- `docker compose logs`
- `docker compose exec`
- `docker compose restart`
- `docker compose stop`
- `docker compose start`
- `docker compose build`
- `docker compose pull`

#### Day 06 – Production Docker

- Development vs Production Docker
- Image Optimization
- Multi-stage Builds
- `.dockerignore`
- Docker Layer Caching
- Lightweight Base Images (Alpine)
- Health Checks
- Restart Policies
- Resource Limits
- Production Security Best Practices
- Production Docker Workflow
- Optimized Dockerfiles
- Build Context Optimization
- Production Deployment
- Docker Performance Optimization

**Commands Practiced (Day 06):**

- `docker images`
- `docker history`
- `docker stats`
- `docker logs`
- `docker inspect`
- `docker system df`
- `docker system prune`
- `docker image prune`
- `docker container prune`
- `docker volume prune`

#### Day 07 – Docker Registry

- What is a Docker Registry?
- Docker Hub
- Public vs Private Registries
- Image Repositories
- Image Tagging
- Image Versioning
- Semantic Versioning
- Docker Login
- Docker Logout
- Docker Build
- Docker Tag
- Docker Push
- Docker Pull
- Docker Registry Workflow
- AWS Elastic Container Registry (ECR)
- Azure Container Registry (ACR)
- Google Artifact Registry
- Harbor Registry
- Production Image Distribution
- Registry Best Practices

**Commands Practiced (Day 07):**

- `docker login`
- `docker logout`
- `docker build`
- `docker tag`
- `docker push`
- `docker pull`
- `docker images`
- `docker image inspect`
- `docker history`
- `docker rmi`

#### Day 08 – Docker Security

- Container Isolation Boundaries
- Non-root Containers
- Least Privilege Principle
- Image Vulnerability Scanning
- Trusted Base Images
- Secrets Management
- Read-only Filesystems
- Docker Security Best Practices

#### Day 09 – Production Docker Lab

- Production Node.js + MySQL Docker Compose Application
- Production Dockerfile
- Node.js Docker Image
- Docker Compose (multi-service)
- Docker Networking (service-name DNS)
- Environment Variables (`.env`, `.env.example`)
- `.gitignore` for secrets
- MySQL Persistent Volumes
- Database Persistence
- MySQL Health Checks
- `depends_on` + `service_healthy`
- Restart Policies
- Container Troubleshooting
- Database Authentication Troubleshooting

**Commands Practiced (Day 09):**

- `docker build`
- `docker run`
- `docker compose up`
- `docker compose down`
- `docker compose ps`
- `docker compose logs`
- `docker compose exec`
- `docker volume ls`

#### Day 10 – Final Docker Challenge & Interview Revision

- Docker Compose Architecture (end-to-end review)
- Production Dockerfiles (review)
- Docker Networking & DNS (review)
- Docker Volumes (review)
- Health Checks & `depends_on` (review)
- Environment Variables & Secrets Management
- Non-root Containers
- Docker Registry, Image Tagging & Production Rollback
- Container Troubleshooting (review)
- Multi-stage Docker Builds (review)

**Commands Practiced (Day 10):**

- `docker login`
- `docker tag backend:v1.4 <user>/backend:v1.4`
- `docker push <user>/backend:v1.4`

**🐳 Docker Module Complete. ✅**

---

## 🚀 CI/CD ✅

### Jenkins — Production Focused Revision

Hands-on labs covering CI/CD concepts, Jenkins architecture, jobs, builds, pipelines, Jenkinsfiles, troubleshooting, and real-world production workflows — focused on understanding how Jenkins fits into a production CI/CD system.

#### Day 11 – Jenkins Fundamentals

- What is Jenkins?
- Why Jenkins?
- Problems with Manual Software Delivery
- Continuous Integration (CI)
- Continuous Delivery (CD)
- Continuous Deployment
- Jenkins Automation Server
- Jenkins Architecture
- Jenkins Controller
- Jenkins Agents
- Jenkins Jobs
- Jenkins Builds
- Jenkins Pipelines
- Jenkinsfile
- Pipeline as Code
- Basic Production CI/CD Workflow
- Jenkins Interview Fundamentals

**Commands Practiced (Day 11):**

```bash
sudo systemctl status jenkins
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl restart jenkins
sudo journalctl -u jenkins
sudo journalctl -u jenkins -f
java -version
git clone <repository>
git checkout <branch>
git pull
docker build -t backend:v1 .
docker tag backend:v1 vineet/backend:v1
docker push vineet/backend:v1
```

#### Day 12 – Jenkins Jobs & Pipelines

- Freestyle Project vs Pipeline Job
- Declarative Pipeline vs Scripted Pipeline
- Pipeline Stages & Steps
- `pipeline { agent stages post }` block structure
- Pipeline Parameters (`choice`, `booleanParam`)
- Environment Variables in Pipelines
- `when` Conditions (branch, expression, environment)
- Parallel Stages
- `post { success failure always }` Actions
- Build History & Console Output
- Archiving Artifacts
- `junit` Test Reports
- Retry & Timeout Wrappers
- Jenkins Shared Libraries (introduced)

**Commands Practiced (Day 12):**

```bash
# CLI job operations
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token create-job my-job < config.xml
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token build my-job -p ENV=staging
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token console my-job

# Declarative pipeline validation
curl -X POST -F "jenkinsfile=<Jenkinsfile" http://localhost:8080/pipeline-model-converter/validate

# REST API build trigger
curl -X POST "http://localhost:8080/job/my-job/buildWithParameters?ENV=staging" --user user:api-token
```

#### Day 13 – Jenkinsfile & GitHub Integration

- GitHub Credentials in Jenkins (PAT, SSH key, GitHub App)
- GitHub Webhooks
- `github-webhook/` Payload URL
- Multibranch Pipeline
- Branch Auto-discovery
- Pull Request Builds
- Merge vs Source-only PR Build Strategy
- GitHub Commit Status / Checks
- Branch Protection Rules
- Poll SCM vs Webhook Triggers

**Commands Practiced (Day 13):**

```bash
# Test SCM connectivity from an agent
git ls-remote https://github.com/org/repo.git
ssh -T git@github.com

# Webhook payload URL (configured in GitHub repo settings)
http://<jenkins-host>/github-webhook/

# Credential-scoped clone inside a pipeline
sshagent(['github-ssh-key']) { sh 'git clone git@github.com:org/repo.git' }
```

#### Day 14 – Jenkins + Docker

- Docker Pipeline Plugin
- Docker Agents (`agent { docker { image '...' } }`)
- Docker-outside-of-Docker (socket mounting) vs Docker-in-Docker (DinD)
- Building & Tagging Images in a Pipeline
- Pushing Images to a Registry
- Registry Authentication via Jenkins Credentials
- Image Tagging Strategy (build number + `latest`)
- Image Vulnerability Scanning (introduced)
- Deploy Stage (stop/remove/run container)
- Docker Disk Space Management

**Commands Practiced (Day 14):**

```bash
# Docker socket permissions for the Jenkins user
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# Registry login/push inside a pipeline (via withCredentials)
echo $REGISTRY_CREDS_PSW | docker login -u $REGISTRY_CREDS_USR --password-stdin
docker build -t $IMAGE_NAME:$IMAGE_TAG .
docker push $IMAGE_NAME:$IMAGE_TAG

# Disk cleanup
docker system df
docker system prune -af --volumes
```

#### Day 15 – Production Jenkins CI/CD & Interview Revision

- Role-based Authorization Strategy (RBAC)
- Credential Scoping (folder-level vs Global)
- CSRF Protection & Reverse Proxy / TLS Setup
- Backup & Restore (`JENKINS_HOME`, `thinBackup`)
- Disaster Recovery Drills
- Static vs Dynamic (Docker/Kubernetes) Agents
- Jenkins Shared Libraries (`vars/` step reuse across teams)
- Monitoring (Prometheus plugin) & Failure Notifications
- Groovy Sandbox & Script Approval
- Full Pipeline Failure Troubleshooting (agent, git, credentials, Docker, deployment)
- Jenkins vs GitHub Actions

**Commands Practiced (Day 15):**

```bash
# Backup / restore
sudo tar -czf jenkins-backup-$(date +%F).tar.gz -C /var/lib/jenkins .
sudo tar -xzf jenkins-backup-<date>.tar.gz -C /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins

# Config reload without full restart
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token reload-configuration
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token safe-restart

# Recover from a locked-out security config
sudo sed -i 's/<useSecurity>true<\/useSecurity>/<useSecurity>false<\/useSecurity>/' /var/lib/jenkins/config.xml
```

**🚀 Jenkins Module Complete. ✅**

---

### GitHub Actions — Production Focused Revision

Hands-on labs covering GitHub Actions fundamentals, advanced workflow control (dependencies, conditions, matrix builds), and production CI/CD with Docker — built as a native, cloud-hosted alternative to the Jenkins track above.

#### Day 16 – GitHub Actions Fundamentals

- What is GitHub Actions?
- Why GitHub Actions?
- Workflow, Events/Triggers, Jobs, Steps, Runner
- `runs-on`, `uses`, `run`
- YAML Workflow Structure
- `.github/workflows/`
- Basic CI Workflow
- Jenkins vs GitHub Actions

#### Day 17 – Advanced GitHub Actions

- `needs` (Job Dependencies)
- `if` Conditions
- Matrix Strategy
- GitHub Secrets
- Environment Variables
- GitHub Environments
- Artifacts
- Caching
- Permissions & Least Privilege
- Third-party Actions & Supply-chain Security
- Passing Artifacts Between Jobs

#### Day 18 – Production GitHub Actions

- GitHub Actions + Docker (Build, Tag, Login, Push, Registry)
- `github.sha` & Image Traceability
- Branch-based Deployment
- Production Environments & Environment Protection
- Approval / Protection Rules
- Quality Gates
- CI/CD Troubleshooting (Checkout, Build, Test, Docker, Runner, Secret/Configuration Failures)
- Complete Production CI/CD Workflow
- Final GitHub Actions Interview Revision

**🚀 GitHub Actions Module Complete. ✅**

**🚀 CI/CD Module: Jenkins + GitHub Actions Complete. ✅**

---

## ☸️ Kubernetes ✅

### Kubernetes — Production Focused Revision

Hands-on labs covering Kubernetes architecture, workloads, networking,
storage, configuration, health checks, scheduling, and production
troubleshooting — continuing the CI/CD module's Git → Build → Docker →
Registry pipeline into how those images actually run in a cluster.

#### Day 22 – Kubernetes Architecture

- Kubernetes, Cluster, Control Plane, Worker Nodes
- API Server, etcd, Scheduler, Controller Manager
- Kubelet, Kube Proxy, Container Runtime

  nodes directly, only to the API Server.
- The Scheduler only decides *placement*; the Kubelet on the assigned node
  is what actually starts the containers via the container runtime.
- etcd is the cluster's single source of truth — losing it without a
  tested backup means losing cluster state entirely.

#### Day 23 – Pods, Deployments & ReplicaSets

- Pod vs Container, Pod lifecycle & states
- Multi-container Pods
- Deployment, ReplicaSet, desired state, self-healing
- Rolling updates, rollback, rollout history/status

  gives self-healing and rolling updates that a standalone Pod doesn't
  have.
- A container restarting inside a Pod (`CrashLoopBackOff`) is a different
  event from a Pod being recreated by its controller.
- A rolling update creates a *new* ReplicaSet and shifts replicas from old
  to new only as new Pods pass readiness — a broken rollout stalls safely
  instead of taking the app down.

#### Day 24 – Services, Networking & DNS

- Why Pods need Services (unstable Pod IPs)
- Service discovery, Kubernetes DNS, Labels & Selectors, EndpointSlices
- Service types: ClusterIP, NodePort, LoadBalancer, ExternalName
- `port`, `targetPort`, `nodePort`

  membership — a mismatch silently produces zero endpoints.
- EndpointSlices only ever include Pods that are currently *Ready* — a
  Running-but-not-Ready Pod is excluded from traffic automatically.
- `DB_HOST=mysql` works because Kubernetes DNS resolves a Service name to
  its ClusterIP within the same namespace — no manual DNS setup required.

#### Day 25 – Storage, ConfigMaps, Secrets & Health Checks

- Ephemeral vs persistent storage, Volumes, PV, PVC, StorageClass, dynamic
  provisioning
- ConfigMaps vs Secrets, `env` vs `envFrom`
- Liveness, Readiness, and Startup Probes
- CPU/memory `requests` vs `limits`, OOMKilled

  underlying PV) is a separate object with its own lifecycle.
- A Kubernetes Secret is base64-**encoded**, not encrypted, by default —
  real security needs etcd encryption at rest or an external secrets
  manager.
- Liveness failing restarts the container; Readiness failing only removes
  the Pod from Service endpoints — mixing these two up causes very
  different (and sometimes worse) incidents.
- Exceeding a memory `limit` triggers OOMKilled; exceeding a CPU `limit`
  only throttles — the two behave very differently when hit.

#### Day 26 – Kubernetes Troubleshooting

- Pod Pending, CrashLoopBackOff, ImagePullBackOff, OOMKilled, 0/1 Ready
- Service Not Working (selector → labels → endpoints → ports)
- PVC Pending, Node problems (`NotReady`, `DiskPressure`, `MemoryPressure`)
- Master production incident troubleshooting flow

  often explain why a Pod never got far enough to produce a useful log
  line.
- The master flow (`get pods` → `describe pod` → `logs` → `logs
  --previous` → `get events` → check Service → EndpointSlices → ConfigMaps/
  Secrets → PVC → Nodes) works because it's ordered from cheapest, most
  informative checks first.
- Root causes are often several layers away from the visible symptom (e.g.
  a crashing backend caused by an unrelated database PVC that never
  bound) — trace the whole chain instead of fixing only the first
  abnormal-looking thing.

**☸️ Kubernetes Module Complete. ✅**

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

### 07-cicd/ structure (Jenkins + GitHub Actions)

```text
07-cicd/
├── README.md
│
├── jenkins/
│   ├── README.md
│   ├── jenkins-notes.md
│   ├── commands/
│   ├── jenkinsfiles/
│   ├── labs/
│   ├── troubleshooting/
│   ├── workflows/
│   ├── interview/
│   └── pdfs/
│
└── github-actions/
    ├── README.md
    ├── github-actions-notes.md
    ├── workflows/
    ├── examples/
    ├── labs/
    ├── troubleshooting/
    ├── interview/
    └── pdfs/
```

### 04-kubernetes/ structure

```text
04-kubernetes/
├── README.md
├── commands/
├── manifests/
├── concepts/
├── troubleshooting/
├── workflows/
├── labs/
└── interview/
```

### 02-git-github/ additions for Day 08

```text
commands/
troubleshooting/
workflows/
pdfs/
```

### 03-docker/ additions for Day 03

```text
commands/
troubleshooting/
workflows/
pdfs/
```

### 03-docker/ additions for Day 04

```text
commands/
troubleshooting/
workflows/
pdfs/
```

### 03-docker/ additions for Day 05

```text
commands/
troubleshooting/
workflows/
pdfs/
```

### 03-docker/ additions for Day 06

```text
commands/
troubleshooting/
workflows/
pdfs/
```

### 03-docker/ additions for Day 07

```text
commands/
troubleshooting/
workflows/
pdfs/
```

### 03-docker/ additions for Day 08–10

```text
pdfs/
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
- Multi-container Application Setup with Docker Compose
- Service Communication via Compose-created Network
- Environment Variable Configuration Across Services
- Persistent Storage in a Multi-container Compose Stack
- depends_on Startup Order Behavior
- Production Node.js Deployment
- Multi-stage Docker Builds
- Optimizing Large Docker Images
- CI/CD Docker Pipelines
- Docker Image Security
- Docker Performance Optimization
- Production Container Deployment
- Resource Management
- High Availability Containers
- Store Docker Images
- Share Images Across Teams
- CI/CD Image Distribution
- Versioned Application Releases
- Production Rollbacks
- Private Enterprise Registries
- Cloud Container Registries
- Production Deployments (Registry-based)
- Production Node.js + MySQL Compose Stack with Health Checks and `service_healthy`
- Database Authentication Failure Troubleshooting (simulated)
- Secrets Management via `.env` / `.gitignore` vs Hardcoded `ENV`
- Non-root Container Users
- Production Rollback via Versioned Image Tags
- Full Registry Workflow Applied End-to-End (build → tag → login → push → pull → run)

### CI/CD (Jenkins)

- Understand Jenkins as an automation server
- Explain CI/CD
- Explain Jenkins architecture
- Explain Controller vs Agent
- Explain Job vs Build
- Explain Pipeline
- Explain Jenkinsfile
- Explain the basic production CI/CD workflow
- Freestyle vs Pipeline Jobs, build parameters, conditional stages
- Multibranch Pipelines & GitHub webhook-triggered builds
- PR build strategy (merge vs source-only) and commit status checks
- Docker agents, image build/tag/push, registry authentication
- Docker socket mounting vs Docker-in-Docker trade-offs
- RBAC, credential scoping, and production backup/restore
- Shared Libraries for cross-team pipeline reuse
- End-to-end pipeline failure triage (agent, git, credentials, Docker, deployment)

### CI/CD (GitHub Actions)

- Explain GitHub Actions workflow/job/step/runner architecture
- Explain triggers and event-based automation
- Job dependencies (`needs`) and conditional execution (`if`)
- Matrix strategy across multiple configurations
- Secrets, environment variables, and GitHub Environments
- Passing build output between jobs via artifacts
- Speeding up installs with dependency caching
- Least-privilege permissions and third-party Action supply-chain security
- Docker build/tag/login/push inside a workflow
- Image traceability via `github.sha`
- Protected production environments with required-reviewer approval
- End-to-end CI/CD troubleshooting (checkout, build, test, Docker, runner, secrets)

### Kubernetes

- Explain Control Plane vs Worker Node architecture end-to-end
- Trace a request from `kubectl apply` to a running container
- Pod vs Deployment/ReplicaSet, self-healing, rolling updates and rollback
- Service discovery via labels/selectors, EndpointSlices, and Kubernetes DNS
- ConfigMap vs Secret injection (`env` vs `envFrom`), and why base64 isn't encryption
- PV/PVC/StorageClass and why deleting a Pod doesn't delete persistent data
- Liveness vs Readiness vs Startup probes and their production impact
- Requests vs Limits, scheduling, and OOMKilled root-causing
- Ingress host/path routing vs Ingress Controller responsibilities
- Horizontal Pod Autoscaler behavior and its dependency on requests
- Pod Pending / CrashLoopBackOff / ImagePullBackOff / OOMKilled / 0/1 Ready triage
- Service-not-working troubleshooting (selector → labels → endpoints → ports)
- PVC Pending and Node-level (`NotReady`, `DiskPressure`) troubleshooting
- Master production incident flow, tracing root cause across multiple layers

---

## ⏳ Upcoming

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
- Why did the Jenkins pipeline fail at this stage?

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

# 🏭 Docker Compose Architecture

```text
docker-compose.yml
        │
        ▼
Docker Compose
        │
 ┌──────┴──────────────┐
 ▼                     ▼
Backend             MySQL
        │
        ▼
Docker Network
        │
        ▼
Docker Volume
```

---

# 🏗 Production Docker Workflow

```text
Developer
      │
      ▼
Dockerfile
      │
      ▼
Multi-stage Build
      │
      ▼
Optimized Docker Image
      │
      ▼
Docker Registry
      │
      ▼
Production Server
      │
      ▼
Running Container
```

---

# 🏗 Docker Registry Workflow

```text
Developer
      │
      ▼
Write Code
      │
      ▼
docker build
      │
      ▼
Docker Image
      │
      ▼
docker tag
      │
      ▼
docker login
      │
      ▼
docker push
      │
      ▼
Docker Registry
      │
      ▼
Production Server
      │
      ▼
docker pull
      │
      ▼
docker run
```

---

# 🏗 Day 09 – Production Docker Lab Architecture

```text
                 Browser
                    │
                    ▼
             Node.js Backend
                 :3000
                    │
             Docker Network
                    │
                    ▼
                MySQL :3306
                    │
                    ▼
              mysql-data Volume
```

---

# 🏗 Day 10 – Final Challenge Production Architecture

```text
                 Docker Compose
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
          Backend              MySQL
          :3000                :3306
             │                   │
             └── Docker Network ─┘
                                 │
                                 ▼
                           mysql-data
                              Volume
```

---

# 🏗 Jenkins Architecture

```text
                 GitHub
                    │
                    │ Code
                    ▼
           Jenkins Controller
                 🧠
                    │
             Schedules Work
                    │
                    ▼
              Jenkins Agent
                 💪
                    │
          ┌─────────┼─────────┐
          ▼         ▼         ▼
       Checkout   Build      Test
                              │
                              ▼
                         Docker Build
                              │
                              ▼
                           Registry
                              │
                              ▼
                          Production
```

### Controller

```text
Controller = 🧠 Brain / Coordinator
```

The Controller manages and coordinates Jenkins jobs and schedules work.

### Agent

```text
Agent = 💪 Worker
```

The Agent executes the actual build, test, and deployment work assigned by Jenkins.

---

# 🔄 Jenkins CI Workflow

```text
Developer
    │
    ▼
Write Code
    │
    ▼
git push
    │
    ▼
GitHub
    │
    ▼
Jenkins Trigger
    │
    ▼
Jenkins Controller
    │
    ▼
Jenkins Agent
    │
    ▼
Checkout Code
    │
    ▼
Build
    │
    ▼
Test
    │
    ▼
Result
```

---

# 🏭 Jenkins Production CI/CD Workflow

```text
Developer
      │
      ▼
    GitHub
      │
      ▼
Jenkins Controller
      │
      ▼
Jenkins Agent
      │
      ▼
   Checkout
      │
      ▼
     Build
      │
      ▼
     Test
      │
      ▼
 Docker Build
      │
      ▼
 Docker Tag
      │
      ▼
 Docker Push
      │
      ▼
Docker Registry
      │
      ▼
 Production Deployment
```

---

# 📦 Jenkins Job vs Build

A Jenkins **Job** contains the configured instructions.

A Jenkins **Build** is one execution of that Job.

```text
Job: backend-build
       │
       ├── Build #1
       ├── Build #2
       ├── Build #3
       └── Build #4
```

Remember:

```text
Job   = What Jenkins is configured to do
Build = One execution of that Job
```

---

# 🔄 Jenkins Pipeline Workflow

```text
Pipeline
    │
    ├── Checkout
    │
    ├── Build
    │
    ├── Test
    │
    ├── Docker Build
    │
    ├── Docker Push
    │
    └── Deploy
```

A Pipeline defines the sequence of stages and steps used to automate a CI/CD workflow.

---

# 📄 Jenkinsfile Workflow

```text
GitHub Repository
       │
       ├── Application Code
       ├── Dockerfile
       └── Jenkinsfile
                │
                ▼
        Pipeline Definition
                │
                ▼
             Jenkins
                │
                ▼
          CI/CD Workflow
```

A Jenkinsfile stores the pipeline definition as code.

Benefits:

- Version controlled
- Reviewable
- Reproducible
- Stored alongside application code

---

# 🚨 Jenkins Troubleshooting Workflow

```text
Pipeline Failure
      │
      ▼
Read Console Output
      │
      ▼
Identify Failed Stage
      │
      ▼
Check Logs
      │
      ▼
Check Configuration
      │
      ▼
Test Smallest Failing Component
      │
      ▼
Fix
      │
      ▼
Re-run Pipeline
      │
      ▼
Verify
```

Common failure areas:

- Source code
- Dependencies
- Build commands
- Test failures
- Git authentication
- Jenkins credentials
- Agent connectivity
- Agent runtime
- Docker permissions
- Docker authentication
- Registry access
- Deployment configuration

---

# 🏗 Jenkins + Docker Workflow

```text
GitHub
   │
   ▼
Jenkins
   │
   ▼
Checkout Code
   │
   ▼
Run Tests
   │
   ▼
Docker Build
   │
   ▼
Docker Tag
   │
   ▼
Docker Push
   │
   ▼
Docker Registry
   │
   ▼
Production
```

This connects the Jenkins module directly with the Docker knowledge completed in the previous module.

---

# 🏗 GitHub Actions Architecture

```text
                 GitHub Repository
                        │
                  Push / PR / Event
                        │
                        ▼
                 GitHub Actions
                        │
                        ▼
                    Workflow
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
        Job 1         Job 2         Job 3
          │             │             │
      ┌───┴───┐     ┌───┴───┐     ┌───┴───┐
      ▼       ▼     ▼       ▼     ▼       ▼
    Step    Step  Step    Step  Step    Step
      │
      ▼
    Runner
 (GitHub-hosted or self-hosted)
```

---

# 🔄 GitHub Actions Production CI/CD Workflow

```text
Developer
      │
      ▼
   git push
      │
      ▼
    GitHub
      │
      ▼
GitHub Actions
      │
      ▼
     Build
      │
      ▼
     Test
      │
      ▼
 Docker Build
      │
      ▼
 Docker Tag (github.sha)
      │
      ▼
 Docker Push
      │
      ▼
Docker Registry
      │
      ▼
Production Environment
      │
      ▼
   Approval
      │
      ▼
    Deploy
```

---

# ☸️ Kubernetes Architecture

```text
Developer
   │
   ▼
kubectl
   │
   ▼
API Server
   │
   ▼
Control Plane
   │
   ▼
Scheduler
   │
   ▼
Worker Node
   │
   ▼
Kubelet
   │
   ▼
Container Runtime
   │
   ▼
Pod
```

---

# 🌐 Kubernetes Request Flow

```text
Client
   │
   ▼
Service
   │
   ▼
EndpointSlice
   │
   ▼
Pod
   │
   ▼
Container
```

---

# 💾 Kubernetes Storage Flow

```text
Pod
 │
 ▼
PVC
 │
 ▼
PV
 │
 ▼
Storage
```

---

# 🚨 Kubernetes Master Troubleshooting Flow

```text
Production Backend Down
        │
        ▼
kubectl get pods
        │
        ▼
Identify abnormal Pods
        │
        ▼
kubectl describe pod
        │
        ▼
kubectl logs
        │
        ▼
kubectl logs --previous
        │
        ▼
kubectl get events
        │
        ▼
Check Service
        │
        ▼
Check EndpointSlices
        │
        ▼
Check ConfigMaps / Secrets
        │
        ▼
Check PVC
        │
        ▼
Check Nodes
```

This connects the Kubernetes module's troubleshooting flow directly with
the CI/CD module's image-tagging discipline (`github.sha` / build-number
tags) — a precise rollback in Kubernetes depends on the same traceable
image tags built in `07-cicd/`.

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
- Docker Compose
- Production Docker (Multi-stage Builds, Image Optimization, Health Checks, Restart Policies, Resource Limits)
- Docker Registry (Docker Hub, Private Registries, Tagging & Versioning, Push/Pull Workflow, AWS ECR)
- Docker Security (Non-root Containers, Least Privilege, Secrets Management)
- Production Docker Lab (Node.js + MySQL Compose stack, health checks, `service_healthy`, DB auth troubleshooting)
- Final Docker Challenge & Interview Revision (secrets management, non-root containers, production rollback, full registry workflow)

**🐳 Docker Module Complete. ✅**

---

# 📊 Jenkins Learning Progress

## ✅ Completed

- Day 11 – Jenkins Fundamentals
- Day 12 – Jenkins Jobs & Pipelines
- Day 13 – Jenkinsfile & GitHub Integration
- Day 14 – Jenkins + Docker
- Day 15 – Production Jenkins CI/CD & Interview Revision

**🚀 Jenkins Module Complete. ✅**

---

# 📊 GitHub Actions Learning Progress

## ✅ Completed

- Day 16 – GitHub Actions Fundamentals
- Day 17 – Advanced GitHub Actions
- Day 18 – Production GitHub Actions & Interview Revision

**🚀 GitHub Actions Module Complete. ✅**

---

# 📊 Kubernetes Learning Progress

## ✅ Completed

- Day 22 – Kubernetes Architecture
- Day 23 – Pods, Deployments & ReplicaSets
- Day 24 – Services, Networking & DNS
- Day 25 – Storage, ConfigMaps, Secrets & Health Checks
- Day 26 – Kubernetes Troubleshooting

**☸️ Kubernetes Module Complete. ✅**

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

# 🧰 Commands Practiced — Docker Compose

```md
## Docker Compose

- `docker compose up`
- `docker compose up -d`
- `docker compose down`
- `docker compose ps`
- `docker compose logs`
- `docker compose exec`
- `docker compose restart`
- `docker compose stop`
- `docker compose start`
- `docker compose build`
- `docker compose pull`
```

---

# 🧰 Commands Practiced — Production Docker

```md
## Production Docker

- `docker images`
- `docker history`
- `docker stats`
- `docker logs`
- `docker inspect`
- `docker system df`
- `docker system prune`
- `docker image prune`
- `docker container prune`
- `docker volume prune`
```

---

# 🧰 Commands Practiced — Docker Registry

```md
## Docker Registry

- `docker login`
- `docker logout`
- `docker build`
- `docker tag`
- `docker push`
- `docker pull`
- `docker images`
- `docker image inspect`
- `docker history`
- `docker rmi`
```

---

# 🧰 Commands Practiced — Production Lab & Final Challenge (Day 09–10)

```md
## Production Lab & Final Challenge

- `docker build`
- `docker run`
- `docker compose up`
- `docker compose down`
- `docker compose ps`
- `docker compose logs`
- `docker compose exec`
- `docker volume ls`
- `docker login`
- `docker tag backend:v1.4 <user>/backend:v1.4`
- `docker push <user>/backend:v1.4`
```

---

# 🧰 Commands Practiced — Jenkins (Day 11)

```md
## Jenkins Service

sudo systemctl status jenkins
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl restart jenkins

## Jenkins Logs

sudo journalctl -u jenkins
sudo journalctl -u jenkins -f

## Java

java -version

## Git Commands Used by Jenkins

git clone <repository>
git checkout <branch>
git pull

## Docker Commands Jenkins May Execute

docker build -t backend:v1 .
docker tag backend:v1 vineet/backend:v1
docker push vineet/backend:v1
```

---

# 🧰 Commands Practiced — Jenkins (Day 12–15)

```md
## Day 12 — Jobs & Pipelines

java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token create-job my-job < config.xml
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token build my-job -p ENV=staging
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token console my-job
curl -X POST -F "jenkinsfile=<Jenkinsfile" http://localhost:8080/pipeline-model-converter/validate
curl -X POST "http://localhost:8080/job/my-job/buildWithParameters?ENV=staging" --user user:api-token

## Day 13 — GitHub Integration

git ls-remote https://github.com/org/repo.git
ssh -T git@github.com
# Webhook payload URL: http://<jenkins-host>/github-webhook/

## Day 14 — Jenkins + Docker

sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
echo $REGISTRY_CREDS_PSW | docker login -u $REGISTRY_CREDS_USR --password-stdin
docker build -t $IMAGE_NAME:$IMAGE_TAG .
docker push $IMAGE_NAME:$IMAGE_TAG
docker system df
docker system prune -af --volumes

## Day 15 — Production Jenkins

sudo tar -czf jenkins-backup-$(date +%F).tar.gz -C /var/lib/jenkins .
sudo tar -xzf jenkins-backup-<date>.tar.gz -C /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token reload-configuration
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token safe-restart
```

---

# 🧰 Commands Practiced — GitHub Actions (Day 16–18)

```md
## Workflow file location

.github/workflows/*.yml

## Core workflow keys used across examples

on:
jobs:
runs-on:
uses:
run:
needs:
if:
strategy: matrix:
permissions:
env:
environment:

## Docker-in-CI (docker-ci.yml, production-cicd.yml)

docker build -t myapp:${{ github.sha }} .
docker tag myapp:${{ github.sha }} myapp:latest
docker push myapp:${{ github.sha }}
docker push myapp:latest

## Reusable Actions used

actions/checkout@v4
actions/setup-node@v4
actions/cache@v4
actions/upload-artifact@v4
actions/download-artifact@v4
docker/login-action@v3
```

---

# 🧰 Commands Practiced — Kubernetes (Day 22–26)

```md
## Cluster & context

kubectl cluster-info
kubectl config get-contexts
kubectl config use-context <context-name>

## Pods

kubectl get pods -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl exec -it <pod-name> -- /bin/sh

## Deployments

kubectl apply -f deployment.yaml
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>
kubectl scale deployment <name> --replicas=5

## Services & Networking

kubectl get svc
kubectl describe svc <name>
kubectl get endpointslices
kubectl get pods --show-labels

## ConfigMaps & Secrets

kubectl create configmap app-config --from-literal=APP_ENV=production
kubectl create secret generic db-secret --from-literal=DB_PASSWORD=changeme
kubectl get secret db-secret -o jsonpath='{.data.DB_PASSWORD}' | base64 --decode

## Storage

kubectl get pvc
kubectl describe pvc <name>
kubectl get storageclass

## Nodes

kubectl get nodes
kubectl describe node <node-name>
kubectl top nodes

## Master Troubleshooting Flow

kubectl get pods -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name> --previous
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get svc,endpointslices
kubectl get pvc
kubectl get nodes
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

# 🧠 Core Concepts — Docker Compose

```text
Docker Compose
docker-compose.yml
Services
Build vs Image
Container Name
Environment Variables
Volumes
Networks
depends_on
Multi-container Applications
Compose Lifecycle
```

---

# 🧠 Core Concepts — Production Docker

```text
Production Docker
Development vs Production
Image Optimization
Multi-stage Builds
Builder Stage
Runtime Stage
Docker Build Context
Docker Layer Caching
Lightweight Base Images
Health Checks
Restart Policies
Resource Limits
Production Docker Best Practices
Docker Security
Image Optimization Strategies
```

---

# 🧠 Core Concepts — Docker Registry

```text
Docker Registry
Docker Hub
Public Registry
Private Registry
Docker Repository
Image Tagging
Version Tags
Semantic Versioning
Docker Authentication
Image Distribution
Production Deployment
Registry Authentication
Image Lifecycle
AWS ECR
Azure ACR
Google Artifact Registry
```

---

# 🧠 Core Concepts — Production Lab & Final Challenge (Day 09–10)

```text
service_healthy Condition
Non-root Containers / Least Privilege
Secrets Management (.env vs hardcoded ENV)
Production Rollback via Versioned Tags
Database Authentication Troubleshooting
```

---

# 🧠 Core Concepts — Jenkins

```text
Jenkins
Automation Server
Continuous Integration
Continuous Delivery
Continuous Deployment
CI/CD
Jenkins Controller
Jenkins Agent
Jenkins Architecture
Jenkins Job
Jenkins Build
Jenkins Pipeline
Jenkinsfile
Pipeline as Code
Pipeline Stage
Pipeline Step
Freestyle Job
Declarative Pipeline
Scripted Pipeline
Build Trigger
Webhook
Jenkins Workspace
Console Output
Build History
Artifacts
Environment Variables
Jenkins Credentials
Git Integration
Docker Integration
Docker Registry
Pipeline Failure
Agent Failure
CI/CD Troubleshooting
Production Deployment
```

---

# 🧠 Core Concepts — GitHub Actions

```text
GitHub Actions
Workflow
Job
Step
Runner
GitHub-hosted Runner
Self-hosted Runner
Event / Trigger
runs-on
uses
run
needs
if Condition
Matrix Strategy
GitHub Secrets
Environment Variables
GitHub Environments
Artifacts
Caching
Permissions / Least Privilege
Supply-chain Security
Docker Integration
github.sha
Image Traceability
Environment Protection Rules
Quality Gates
CI/CD Troubleshooting
Production Deployment
```

---

# 🧠 Core Concepts — Kubernetes

```text
Cluster
Control Plane
Worker Node
API Server
etcd
Scheduler
Controller Manager
Kubelet
Kube Proxy
Container Runtime
Pod
Pod Lifecycle & States
Deployment
ReplicaSet
Self-healing
Rolling Update
Rollback
Service
ClusterIP / NodePort / LoadBalancer / ExternalName
Labels & Selectors
EndpointSlice
Kubernetes DNS
Namespace
ConfigMap
Secret
Volume
PersistentVolume (PV)
PersistentVolumeClaim (PVC)
StorageClass
Dynamic Provisioning
Liveness Probe
Readiness Probe
Startup Probe
Resource Requests
Resource Limits
OOMKilled
nodeSelector
Affinity / Anti-affinity
Taints & Tolerations
Ingress
Ingress Controller
Horizontal Pod Autoscaler (HPA)
Production Troubleshooting
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

# 🗝 Key Learnings — Docker Compose

- Docker Compose defines and runs multi-container applications from a single `docker-compose.yml` file.
- `build` creates an image from a Dockerfile; `image` pulls an existing prebuilt image — a service uses one or the other.
- `depends_on` controls startup order but does not wait for a service to be fully ready.
- Compose automatically creates a shared network so services can resolve each other by service name.
- Compose automatically creates named volumes declared under the top-level `volumes:` key.
- `docker compose up -d` runs services in detached mode; `docker compose down` tears down containers and networks (add `-v` to remove volumes too).

---

# 🗝 Key Learnings — Production Docker

- Production Docker prioritizes small, secure, and predictable images over convenience.
- Multi-stage builds separate the build environment from the runtime environment, keeping only what's needed to run the app.
- The builder stage can include compilers and dev dependencies; the runtime stage copies only the final artifacts.
- Alpine and other minimal base images shrink image size and reduce the attack surface.
- Docker Layer Caching speeds up rebuilds by reusing unchanged layers — ordering instructions from least- to most-frequently-changed matters.
- `.dockerignore` also reduces the build context sent to the Docker daemon, speeding up builds.
- Health Checks let Docker (and orchestrators) know whether a container is actually ready, not just running.
- Restart Policies define how Docker responds to container failure (e.g. `on-failure`, `always`, `unless-stopped`).
- Resource Limits (CPU/memory) prevent a single container from starving the host or other containers.
- `docker system df` and `docker system prune` help audit and reclaim disk space used by images, containers, volumes, and build cache.

---

# 🗝 Key Learnings — Docker Registry

- A Docker Registry stores and distributes Docker images; Docker Hub is the default public registry.
- Public registries suit open-source images; private registries (Docker Hub private repos, AWS ECR, Azure ACR, Google Artifact Registry, Harbor) protect proprietary images.
- Image tags identify specific versions of an image within a repository.
- Semantic Versioning (`major.minor.patch`) gives image tags predictable, meaningful version numbers.
- `docker login` authenticates the CLI against a registry before push/pull of private images.
- `docker tag` labels a local image for a specific repository and version before pushing.
- `docker push` uploads a tagged image to a registry; `docker pull` downloads one from a registry.
- Relying on the `latest` tag in production is risky since it can silently change what gets deployed.
- Cloud-managed registries like AWS ECR integrate registry access with cloud IAM permissions.
- A production registry workflow moves an image from local build → tag → push → registry → pull on the production server → run.

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

# 🎤 Interview Questions — Docker Compose

```md
## Docker Compose

- What is Docker?
- Docker vs Virtual Machine?
- What is Docker Engine?
- Difference between Image and Container?
- Dockerfile vs Docker Compose?
- Build vs Image?
- What is Docker DNS?
- What is Bridge Network?
- Explain Port Mapping.
- What is Docker Volume?
- Volume vs Bind Mount?
- What is depends_on?
- What happens during docker compose up?
- Why use Docker Compose?
```

---

# 🎤 Interview Questions — Production Docker

```md
## Production Docker

- What is Production Docker?
- Development vs Production Docker?
- What is a Multi-stage Build?
- Why use Multi-stage Builds?
- What is `.dockerignore`?
- What is Docker Build Context?
- What is Docker Layer Caching?
- Why use Alpine Images?
- What is a Docker Health Check?
- Why use Restart Policies?
- Why configure Resource Limits?
- How do you optimize Docker images?
- What are Docker production best practices?
```

---

# 🎤 Interview Questions — Docker Registry

```md
## Docker Registry

- What is a Docker Registry?
- What is Docker Hub?
- Difference between Public and Private Registry?
- Why do we tag Docker images?
- Why shouldn't we use `latest` in production?
- What is image versioning?
- Explain the Docker Registry workflow.
- What is AWS ECR?
- Difference between Docker Hub and AWS ECR?
- What happens during `docker push`?
- What happens during `docker pull`?
```

---

# 🎤 Interview Questions — Production Lab & Final Challenge (Day 09–10)

```md
## Production Docker Lab

- Why use `DB_HOST=mysql` instead of `localhost`?
- Why use Docker volumes for databases?
- Difference between running and healthy containers?
- Why use `service_healthy`?
- Why keep secrets outside Docker images?
- How do you troubleshoot database connection failures?
- Why use restart policies?

## Final Interview Areas

- Docker image vs container
- Docker networking
- Docker volumes
- Docker Compose
- Health checks
- `depends_on`
- Docker Registry
- Image tagging
- Production rollback
- Container security
- Non-root containers
- Secrets management
- Production troubleshooting
- Multi-stage builds
```

---

# 🎤 Interview Questions — Jenkins (Day 11)

```md
## Jenkins Fundamentals

- What is Jenkins?
- What problem does Jenkins solve?
- Is Jenkins only a CI tool?
- What is Continuous Integration?
- What is Continuous Delivery?
- What is Continuous Deployment?
- Explain Jenkins architecture.
- What is a Jenkins Controller?
- What is a Jenkins Agent?
- Controller vs Agent?
- Why do we need Agents?
- What is a Jenkins Job?
- What is a Jenkins Build?
- Job vs Build?
- What is a Jenkins Pipeline?
- What is a Jenkinsfile?
- Why use Pipeline as Code?
- What is the Jenkins production workflow?
```

---

# 🎤 Interview Questions — Jenkins (Day 12–15)

```md
## Day 12 — Jobs & Pipelines

- Declarative vs Scripted pipeline syntax?
- Why are Declarative pipelines validated before any stage runs?
- How do you pass and access pipeline parameters?
- When does an `environment {}` variable become available?
- What does `when` do, and what are three example conditions?
- How do you run stages in parallel, and why?
- What is the `post {}` block for?
- How do Shared Libraries reduce duplicated pipeline code?

## Day 13 — GitHub Integration

- Why prefer webhooks over SCM polling?
- What's a Multibranch Pipeline, and how is it different from one job per branch?
- PAT vs SSH key vs GitHub App credentials — when would you use each?
- Building a PR's head vs merging it with the target branch — what's the difference and which do you choose?
- How would you debug a webhook that isn't triggering builds?

## Day 14 — Jenkins + Docker

- Benefits of Docker build agents?
- Docker-outside-of-Docker vs Docker-in-Docker — trade-offs?
- Why is mounting `/var/run/docker.sock` a security consideration?
- How do you authenticate to a private registry from a pipeline without hardcoding credentials?
- Why avoid relying solely on the `latest` tag?

## Day 15 — Production Jenkins

- How do you design RBAC for a multi-team Jenkins instance?
- What's Jenkins's story on high availability?
- What should a production backup strategy include beyond `config.xml`?
- Static vs dynamic/cloud agents — when would you choose each?
- How do you scope credentials so one team can't access another's secrets?
- What's the risk of an unrestricted Groovy sandbox?
```

---

# 🎤 Interview Questions — GitHub Actions (Day 16–18)

```md
## Day 16 — Fundamentals

- What is GitHub Actions?
- What is a workflow, job, step, and runner?
- Difference between `uses` and `run`?
- Where must workflow files live for GitHub to discover them?
- What triggers a workflow?
- Name two differences between Jenkins and GitHub Actions.

## Day 17 — Advanced Workflows

- What does `needs` do?
- How do you conditionally run a job or step?
- What is a matrix strategy, and what does `fail-fast: false` change?
- Secrets vs environment variables — what's the difference?
- What is a GitHub Environment, and what protection rules can it hold?
- Why are artifacts needed to pass files between jobs?
- How does a cache key typically get built, and why?
- Why scope `permissions:` explicitly instead of relying on the default?
- What's a supply-chain risk with an unpinned third-party Action?

## Day 18 — Production GitHub Actions

- Walk through a production CI/CD pipeline end-to-end.
- Why tag Docker images with `github.sha` instead of only `latest`?
- How do you gate a production deploy behind manual approval?
- Docker push fails with "access denied" — likely causes?
- A secret appears empty when used — how do you debug it?
- Difference between a build failure and a runner failure?
- How do you design branch-based deployment (e.g. develop → staging, main → production)?
```

---

# 🎤 Interview Questions — Kubernetes (Day 22–26)

```md
## Day 22 — Architecture

- What does the API Server do, and why is it the only thing kubectl talks to?
- What's the difference between the Scheduler's job and the Kubelet's job?
- Why is etcd so important to back up?

## Day 23 — Pods & Deployments

- What's the relationship between a Deployment, a ReplicaSet, and Pods?
- How does a rolling update avoid downtime?
- How do you roll back to a specific earlier revision?
- What's the difference between a container restarting and a Pod being recreated?

## Day 24 — Services & Networking

- Why doesn't Kubernetes just use Pod IPs directly?
- Explain the four Service types and when you'd use each.
- Why does `DB_HOST=mysql` work as a hostname inside the cluster?
- A Service "isn't working" — what's your troubleshooting order?

## Day 25 — Storage, Config & Probes

- Why doesn't deleting a Pod delete its persistent data?
- Is a Kubernetes Secret encrypted by default?
- What's the practical difference between liveness and readiness failing?
- Requests vs Limits — what happens when each is exceeded?

## Day 26 — Troubleshooting

- Walk through your first three commands when a Pod is reported "down."
- What causes CrashLoopBackOff, and how do you confirm the exact cause?
- What causes OOMKilled, and what would you check before just raising the memory limit?
- Walk through the master production troubleshooting flow from memory.
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
Production Docker (Multi-stage Builds)
   │
   ▼
Docker Registry
   │
   ▼
Docker Security
   │
   ▼
Production Docker Lab
   │
   ▼
Final Docker Challenge & Interview Revision
   │
   ▼
✅ Docker Module Complete
```

---

# 🗺 Jenkins Revision Cheat Sheet

```text
Jenkins Fundamentals
   │
   ▼
Jenkins Jobs & Pipelines
   │
   ▼
Jenkinsfile & GitHub Integration
   │
   ▼
Jenkins + Docker
   │
   ▼
Production Jenkins CI/CD & Interview Revision
   │
   ▼
✅ Jenkins Module Complete
```

---

# 🗺 GitHub Actions Revision Cheat Sheet

```text
GitHub Actions Fundamentals
   │
   ▼
Advanced Workflows (needs, if, matrix, secrets, artifacts, caching)
   │
   ▼
Production GitHub Actions & Docker Integration
   │
   ▼
✅ GitHub Actions Module Complete
```

---

# 🗺 Kubernetes Revision Cheat Sheet

```text
Kubernetes Architecture
   │
   ▼
Pods, Deployments & ReplicaSets
   │
   ▼
Services, Networking & DNS
   │
   ▼
Storage, ConfigMaps, Secrets & Health Checks
   │
   ▼
Kubernetes Troubleshooting
   │
   ▼
✅ Kubernetes Module Complete
```

---

# 🎯 Final Objective

Become confident handling:

- Linux Production Servers
- Git Collaboration
- Dockerized Applications
- Jenkins CI/CD Pipelines
- GitHub Actions CI/CD Pipelines
- Kubernetes Clusters & Production Troubleshooting
- AWS Infrastructure
- Infrastructure as Code
- CI/CD Pipelines
- Monitoring & Alerting
- Production Incidents
- DevOps Interviews

Git Cherry-pick enables selective commit transfer between branches, making it an essential tool for production hotfixes, release backports, and maintaining stable release branches without merging unrelated changes.

Docker Volumes decouple data from the container lifecycle, making them essential for running stateful workloads like databases reliably in production.

Docker Networking enables secure, isolated, and discoverable communication between containers, forming the backbone of any multi-container production application.

Docker Compose ties images, volumes, and networks together into a single declarative file, making it the standard way to define and run multi-container applications in development and production.

Production Docker turns a working container into a deployable one — small, cached, health-checked, resource-bound, and secure enough to run reliably in production.

Docker Registry is the bridge between a built image and a running production container — it's how images get versioned, distributed, and pulled onto servers reliably and repeatably.

The Production Docker Lab and Final Challenge tie every prior Docker topic together into a single working, troubleshot, secured, and versioned production application.

Jenkins connects Git, Build, Test, Docker, Registry, and Deployment into a single automated production CI/CD workflow — turning the Docker module's manual `build → tag → push → pull → run` sequence into something that runs itself on every commit.

The completed Jenkins module ties fundamentals, pipelines, GitHub integration, Docker, and production hardening into one coherent CI/CD skillset — from a first Freestyle job through RBAC, backups, and Shared Libraries on a production instance.

GitHub Actions completes the CI/CD module with a second, natively-hosted way to run the same Git → Build → Test → Docker → Registry → Deployment workflow — trading self-managed Jenkins infrastructure for workflows that live and run directly inside GitHub.

Kubernetes is where the CI/CD module's built and pushed images actually run — turning `docker run` on a single server into self-healing, horizontally scalable workloads with their own networking, storage, and production troubleshooting discipline.

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
- ✅ Docker Module Completed
- ✅ Day 01 – Docker Fundamentals
- ✅ Day 02 – Docker Images & Dockerfile
- ✅ Day 03 – Docker Volumes & Bind Mounts
- ✅ Day 04 – Docker Networking
- ✅ Day 05 – Docker Compose
- ✅ Day 06 – Production Docker
- ✅ Day 07 – Docker Registry
- ✅ Day 08 – Docker Security
- ✅ Day 09 – Production Docker Lab
- ✅ Day 10 – Final Docker Challenge & Interview Revision
- ✅ CI/CD Module Completed (Jenkins + GitHub Actions)
- ✅ Day 11 – Jenkins Fundamentals
- ✅ Day 12 – Jenkins Jobs & Pipelines
- ✅ Day 13 – Jenkinsfile & GitHub Integration
- ✅ Day 14 – Jenkins + Docker
- ✅ Day 15 – Production Jenkins CI/CD & Interview Revision
- ✅ Day 16 – GitHub Actions Fundamentals
- ✅ Day 17 – Advanced GitHub Actions
- ✅ Day 18 – Production GitHub Actions & Interview Revision
- ✅ Kubernetes Module Completed
- ✅ Day 22 – Kubernetes Architecture
- ✅ Day 23 – Pods, Deployments & ReplicaSets
- ✅ Day 24 – Services, Networking & DNS
- ✅ Day 25 – Storage, ConfigMaps, Secrets & Health Checks
- ✅ Day 26 – Kubernetes Troubleshooting

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
