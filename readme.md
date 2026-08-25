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
| 🚀 CI/CD | ✅ Jenkins Completed (5/5) |
| ☸️ Kubernetes | ⏳ Planned |
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

CI/CD (Jenkins)       ████████████████████ 100%

Kubernetes            ░░░░░░░░░░░░░░░░░░░░

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

#### ✅ Day 05 – Docker Compose

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

**Key Learnings (Day 05):**

- Docker Compose defines and runs multi-container applications from a single `docker-compose.yml` file.
- `build` creates an image from a Dockerfile; `image` pulls an existing prebuilt image — a service uses one or the other.
- `depends_on` controls startup order but does not wait for a service to be fully ready.
- Compose automatically creates a shared network so services can resolve each other by service name.
- Compose automatically creates named volumes declared under the top-level `volumes:` key.
- `docker compose up -d` runs services in detached mode; `docker compose down` tears down containers and networks (add `-v` to remove volumes too).

#### ✅ Day 06 – Production Docker

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

**Key Learnings (Day 06):**

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

#### ✅ Day 07 – Docker Registry

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

**Key Learnings (Day 07):**

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

#### ✅ Day 08 – Docker Security

- Container Isolation Boundaries
- Non-root Containers
- Least Privilege Principle
- Image Vulnerability Scanning
- Trusted Base Images
- Secrets Management
- Read-only Filesystems
- Docker Security Best Practices

#### ✅ Day 09 – Production Docker Lab

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

**Key Learnings (Day 09):**

- `service_healthy` in `depends_on` is stricter than default `depends_on` — it waits for the health check to pass, not just for the container to start.
- Database authentication failures are diagnosed by checking logs, then verifying credentials match between the app's env vars and the database service.
- Real `.env` files stay out of Git via `.gitignore`; an `.env.example` is committed instead.
- MySQL health checks combined with `depends_on: service_healthy` prevent the backend from starting before the database is actually ready.

#### ✅ Day 10 – Final Docker Challenge & Interview Revision

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

**Key Learnings (Day 10):**

- Hardcoding secrets in a Dockerfile (`ENV DB_PASSWORD=...`) bakes them into every image layer and image history — secrets belong in runtime `.env` files instead.
- Running containers as a dedicated non-root user (`addgroup`/`adduser` + `USER`) limits the blast radius if the application is compromised.
- Predictable rollback in production depends on versioned tags (e.g. `v1.9`, `v2.0`) rather than mutable tags like `latest`.
- Production Dockerfiles combine Alpine base images, multi-stage builds, non-root users, `NODE_ENV=production`, and a minimal runtime image.

**🐳 Docker Module: 10/10 complete. ✅**

---

## 🚀 CI/CD ✅

### Jenkins — Production Focused Revision

Hands-on labs covering CI/CD concepts, Jenkins architecture, jobs, builds, pipelines, Jenkinsfiles, troubleshooting, and real-world production workflows — focused on understanding how Jenkins fits into a production CI/CD system.

#### ✅ Day 11 – Jenkins Fundamentals

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

**Key Learnings (Day 11):**

- Jenkins is an automation server used to automate CI/CD workflows.
- Jenkins can automate checkout, build, testing, packaging, Docker image creation, registry operations, and deployment.
- Continuous Integration means frequently integrating code changes and automatically building/testing them to detect problems early.
- Continuous Delivery/Deployment extends the pipeline toward delivering or deploying validated software.
- The Jenkins Controller manages and coordinates jobs and schedules work.
- Jenkins Agents execute the actual build, test, and deployment work.
- A Job contains configured instructions.
- A Build is one execution of a Job.
- A Pipeline defines the sequence of stages and steps in a CI/CD workflow.
- A Jenkinsfile stores the Pipeline definition as code.
- Pipeline as Code makes CI/CD configuration version-controlled and reviewable.
- GitHub can act as the source repository for Jenkins pipelines.
- Jenkins can integrate with Docker to build and distribute application images.
- Jenkins credentials should be used instead of hardcoding secrets in pipeline code.
- Console Output is one of the first places to investigate a failed build.
- Production troubleshooting should identify the exact failed stage before changing configuration.
- CI/CD pipelines should be repeatable and automated rather than dependent on manual steps.
- Jenkins can connect the Git → Build → Test → Docker → Registry → Deployment workflow.

#### ✅ Day 12 – Jenkins Jobs & Pipelines

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

**Key Learnings (Day 12):**

- Declarative pipelines are validated before any stage runs — catching syntax errors upfront, unlike Scripted pipelines where errors surface at runtime.
- `environment {}` block variables are only available once that block is entered — not before.
- `when` directives (`branch`, `expression`, `environment`, `changeRequest()`) make stage execution conditional without needing separate jobs per environment.
- `parallel {}` cuts pipeline wall-clock time by running independent stages (like lint and unit tests) simultaneously.
- `post { success failure always }` blocks are the standard place for notifications, cleanup (`cleanWs()`), and reporting — not the stages themselves.
- `retry(n) { }` and `timeout(time: n, unit: 'MINUTES') { }` protect a pipeline from flaky steps and indefinite hangs.
- Parameters make one Jenkinsfile reusable across environments instead of duplicating jobs.

#### ✅ Day 13 – Jenkinsfile & GitHub Integration

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

**Key Learnings (Day 13):**

- Webhooks are push-based and near-instant; Poll SCM adds latency and unnecessary load, so webhooks are the production default.
- Multibranch Pipelines auto-discover branches and PRs from a Jenkinsfile in the repo — no need to hand-create a job per branch.
- "Merging the PR with the current target branch base" simulates the real post-merge result and is the safer default for gating merges, versus testing the PR's source branch in isolation.
- Credential type must match the Git URL scheme: HTTPS URLs need a PAT/username-password credential, SSH URLs need an SSH key credential.
- Publishing commit status back to GitHub is what powers required-check branch protection rules on PRs.
- A failing webhook is diagnosed via GitHub's "Recent Deliveries" log — response code first, then payload URL and job trigger config.

#### ✅ Day 14 – Jenkins + Docker

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

**Key Learnings (Day 14):**

- Docker agents give every build a clean, disposable environment — no leftover state between runs.
- Docker-outside-of-Docker (mounting `/var/run/docker.sock`) is the common Jenkins pattern: simpler and shares the host's image cache, but it grants effectively root-equivalent host access to anything that can run `docker` commands.
- Docker-in-Docker gives stronger isolation between builds at the cost of more complex networking and overhead.
- Registry credentials must be injected via Jenkins credentials (`withCredentials` / `environment { X = credentials('id') }`) — never hardcoded in a Jenkinsfile.
- Tagging images with a unique build identifier (not just `latest`) is what makes rollback to a specific version possible.
- Unbounded image/layer buildup is a common cause of Jenkins hosts running out of disk — scheduled `docker system prune` or ephemeral agents prevent it.

#### ✅ Day 15 – Production Jenkins CI/CD & Interview Revision

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
sudo tar -xzf jenkins-backup-2026-08-18.tar.gz -C /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins

# Config reload without full restart
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token reload-configuration
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token safe-restart

# Recover from a locked-out security config
sudo sed -i 's/<useSecurity>true<\/useSecurity>/<useSecurity>false<\/useSecurity>/' /var/lib/jenkins/config.xml
```

**Key Learnings (Day 15):**

- Jenkins has no native multi-controller clustering — production HA is really about fast, tested backup/restore (RTO measured in minutes) plus durable storage for `JENKINS_HOME`, not built-in failover.
- Folder-scoped credential stores plus RBAC keep one team's secrets out of another team's pipelines on a shared instance.
- Shared Libraries (`vars/standardPipeline.groovy` + `@Library('name') _`) stop teams from copy-pasting Jenkinsfile boilerplate and centralize governance.
- Backups are only as good as the last successful *restore test* — a backup that's never been restored is unverified.
- Leaving the Groovy sandbox unrestricted is a real risk; script approvals should be scoped to specific signatures, not blanket-approved.
- Diagnosing a stuck pipeline follows a fixed order: node/label match → agent online status → executor availability → `disableConcurrentBuilds()` blocking → dynamic agent provisioning failures.

**🚀 Jenkins Module: 5/5 complete. ✅**

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

### 07-cicd/ structure (Jenkins)

```text
07-cicd/

├── README.md
│
├── jenkins/
│   ├── README.md
│   ├── jenkins-notes.md
│   │
│   ├── commands/
│   │   ├── jenkins.md
│   │   ├── jenkins-jobs.md
│   │   ├── jenkins-pipeline.md
│   │   └── jenkins-credentials.md
│   │
│   ├── jenkinsfiles/
│   │   ├── basic/
│   │   │   └── Jenkinsfile
│   │   ├── node/
│   │   │   └── Jenkinsfile
│   │   └── docker/
│   │       └── Jenkinsfile
│   │
│   ├── labs/
│   │   ├── day-11-jenkins-fundamentals/
│   │   │   └── README.md
│   │   ├── day-12-jobs-pipelines/
│   │   │   └── README.md
│   │   ├── day-13-github-integration/
│   │   │   └── README.md
│   │   ├── day-14-jenkins-docker/
│   │   │   └── README.md
│   │   └── day-15-production-jenkins/
│   │       └── README.md
│   │
│   ├── troubleshooting/
│   │   ├── jenkins.md
│   │   ├── pipeline-failures.md
│   │   ├── agent-issues.md
│   │   ├── git-issues.md
│   │   ├── docker-issues.md
│   │   └── production-jenkins.md
│   │
│   ├── workflows/
│   │   ├── jenkins-ci-workflow.md
│   │   ├── jenkins-github-workflow.md
│   │   ├── jenkins-docker-workflow.md
│   │   └── complete-jenkins-cicd.md
│   │
│   ├── interview/
│   │   ├── day-11-questions.md
│   │   ├── day-12-questions.md
│   │   ├── day-13-questions.md
│   │   ├── day-14-questions.md
│   │   ├── day-15-production-questions.md
│   │   └── final-jenkins-quiz.md
│   │
│   └── pdfs/
│       ├── day-11-jenkins-fundamentals.pdf
│       ├── day-12-jenkins-pipelines.pdf
│       ├── day-13-jenkins-github.pdf
│       ├── day-14-jenkins-docker.pdf
│       ├── day-15-production-jenkins.pdf
│       └── jenkins-final-revision.pdf
│
└── github-actions/
    └── ...
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

### 03-docker/ additions for Day 05

```text
commands/
    docker-compose.md

troubleshooting/
    docker-compose.md

workflows/
    docker-compose-workflow.md

pdfs/
    Day-05-Docker-Compose.pdf
```

### 03-docker/ additions for Day 06

```text
commands/
    production-docker.md

troubleshooting/
    production-docker.md

workflows/
    production-docker-workflow.md

pdfs/
    Day-06-Production-Docker.pdf
```

### 03-docker/ additions for Day 07

```text
commands/
    docker-registry.md

troubleshooting/
    docker-registry.md

workflows/
    docker-registry-workflow.md

pdfs/
    Day-07-Docker-Registry.pdf
```

### 03-docker/ additions for Day 08–10

```text
pdfs/
    Day-08-Docker-Security.pdf
    Day-09-Production-Docker-Lab.pdf
    Day-10-Final-Challenge-Interview.pdf
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

---

## ⏳ Upcoming

- Kubernetes CrashLoopBackOff
- ImagePullBackOff
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

**🐳 Docker Module: 10/10 complete. ✅**

---

# 📊 Jenkins Learning Progress

## ✅ Completed

- Day 11 – Jenkins Fundamentals
- Day 12 – Jenkins Jobs & Pipelines
- Day 13 – Jenkinsfile & GitHub Integration
- Day 14 – Jenkins + Docker
- Day 15 – Production Jenkins CI/CD & Interview Revision

**🚀 Jenkins Module: 5/5 complete. ✅**

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
sudo tar -xzf jenkins-backup-2026-08-18.tar.gz -C /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token reload-configuration
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token safe-restart
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

# 🗝 Key Learnings — Production Lab & Final Challenge (Day 09–10)

- `service_healthy` in `depends_on` is stricter than default `depends_on` — it waits for the health check to pass, not just for the container to start.
- Database authentication failures are diagnosed by checking logs, then verifying credentials match between the app's env vars and the database service.
- Hardcoding secrets in a Dockerfile (`ENV DB_PASSWORD=...`) bakes them into every image layer and image history — secrets belong in runtime `.env` files instead.
- Running containers as a dedicated non-root user (`addgroup`/`adduser` + `USER`) limits the blast radius if the application is compromised.
- Predictable rollback in production depends on versioned tags (e.g. `v1.9`, `v2.0`) rather than mutable tags like `latest`.

---

# 🗝 Key Learnings — Jenkins (Day 11)

- Jenkins is an automation server used to automate CI/CD workflows.
- Jenkins can automate checkout, build, testing, packaging, Docker image creation, registry operations, and deployment.
- Continuous Integration means frequently integrating code changes and automatically building/testing them to detect problems early.
- Continuous Delivery/Deployment extends the pipeline toward delivering or deploying validated software.
- The Jenkins Controller manages and coordinates jobs and schedules work.
- Jenkins Agents execute the actual build, test, and deployment work.
- A Job contains configured instructions; a Build is one execution of a Job.
- A Pipeline defines the sequence of stages and steps in a CI/CD workflow.
- A Jenkinsfile stores the Pipeline definition as code, making it version-controlled and reviewable.
- Jenkins credentials should be used instead of hardcoding secrets in pipeline code.
- Console Output is one of the first places to investigate a failed build.
- Production troubleshooting should identify the exact failed stage before changing configuration.

---

# 🗝 Key Learnings — Jenkins (Day 12–15)

- Declarative pipelines are validated before any stage runs; Scripted pipeline errors only surface at runtime.
- `when` directives make stage execution conditional (branch, expression, environment) without duplicating jobs per environment.
- Webhooks beat SCM polling for both latency and load; Multibranch Pipelines remove the need to hand-create a job per branch.
- Building the PR merged with its target branch catches integration issues that testing the source branch alone would miss.
- Docker agents give every build a clean, disposable environment; mounting the Docker socket is simpler than Docker-in-Docker but grants host-level access to anything that can run `docker` commands.
- Image tags should include a unique build identifier, not just `latest`, so any deployed version can be pinned and rolled back precisely.
- Jenkins has no native multi-controller HA — production resilience comes from fast, tested backup/restore and durable `JENKINS_HOME` storage.
- Shared Libraries and folder-scoped credentials/RBAC are what keep a multi-team Jenkins instance maintainable and secure at scale.

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

# 🎯 Final Objective

Become confident handling:

- Linux Production Servers
- Git Collaboration
- Dockerized Applications
- Jenkins CI/CD Pipelines
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

Docker Compose ties images, volumes, and networks together into a single declarative file, making it the standard way to define and run multi-container applications in development and production.

Production Docker turns a working container into a deployable one — small, cached, health-checked, resource-bound, and secure enough to run reliably in production.

Docker Registry is the bridge between a built image and a running production container — it's how images get versioned, distributed, and pulled onto servers reliably and repeatably.

The Production Docker Lab and Final Challenge tie every prior Docker topic together into a single working, troubleshot, secured, and versioned production application.

Jenkins connects Git, Build, Test, Docker, Registry, and Deployment into a single automated production CI/CD workflow — turning the Docker module's manual `build → tag → push → pull → run` sequence into something that runs itself on every commit.

The completed Jenkins module ties fundamentals, pipelines, GitHub integration, Docker, and production hardening into one coherent CI/CD skillset — from a first Freestyle job through RBAC, backups, and Shared Libraries on a production instance.

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
- ✅ Docker Module Completed (10/10)
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
- ✅ CI/CD Module Completed (Jenkins 5/5)
- ✅ Day 11 – Jenkins Fundamentals
- ✅ Day 12 – Jenkins Jobs & Pipelines
- ✅ Day 13 – Jenkinsfile & GitHub Integration
- ✅ Day 14 – Jenkins + Docker
- ✅ Day 15 – Production Jenkins CI/CD & Interview Revision

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