# Jenkins CI/CD Revision

Production-focused Jenkins revision with hands-on labs, CI/CD concepts, Jenkins architecture, jobs, builds, pipelines, Jenkinsfiles, troubleshooting, and real-world production workflows.

This module focuses on understanding **how Jenkins fits into a production CI/CD system**, enabling engineers to confidently build, test, automate, troubleshoot, and deploy applications.

---

# 🎯 Objective

Build a strong understanding of Jenkins, Continuous Integration, Continuous Delivery/Deployment, Jenkins architecture, Controllers, Agents, Jobs, Builds, Pipelines, Jenkinsfiles, and production CI/CD workflows.

The goal is to understand **how Jenkins automates software delivery**, troubleshoot failed pipelines confidently, and connect Jenkins with GitHub, Docker, registries, and production deployments.

---

# 📚 Topics Covered

## ✅ Day 11 – Jenkins Fundamentals

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

---

## ⏳ Day 12 – Jenkins Jobs & Pipelines

- Jenkins Jobs
- Freestyle Jobs
- Pipeline Jobs
- Build Execution
- Pipeline Stages
- Pipeline Steps
- Declarative Pipeline
- Scripted Pipeline
- Parameters
- Build History
- Console Output
- Artifacts
- Pipeline Visualization
- Production Pipeline Structure

---

## ⏳ Day 13 – Jenkinsfile & GitHub Integration

- Jenkinsfile
- Pipeline as Code
- Git Integration
- Repository Checkout
- Branches
- Webhooks
- Build Triggers
- Git Credentials
- Pipeline Environment
- Environment Variables
- Automated CI Workflow
- GitHub → Jenkins Workflow

---

## ⏳ Day 14 – Jenkins + Docker

- Jenkins Docker Integration
- Docker Build from Jenkins
- Docker Authentication
- Docker Registry
- Image Tagging
- Image Versioning
- Docker Push
- Production Image Workflow
- Jenkins Credentials
- Docker Permissions
- CI Pipeline with Docker

---

## ⏳ Day 15 – Production Jenkins CI/CD & Interview Revision

- Production Jenkins Architecture
- CI/CD Pipeline Review
- GitHub → Jenkins → Docker Workflow
- Pipeline Troubleshooting
- Failed Builds
- Agent Failures
- Git Authentication Failures
- Docker Permission Issues
- Credentials Failures
- Deployment Failures
- Production CI/CD Workflow
- Jenkins Interview Questions
- Production Scenarios
- Final Jenkins Revision

---

# 📂 Folder Structure

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
│   │   ├── node/
│   │   └── docker/
│   │
│   ├── labs/
│   │   ├── 01-first-job/
│   │   ├── 02-first-pipeline/
│   │   ├── 03-github-pipeline/
│   │   └── 04-docker-pipeline/
│   │
│   ├── troubleshooting/
│   │   ├── jenkins.md
│   │   ├── pipeline-failures.md
│   │   ├── agent-issues.md
│   │   ├── git-issues.md
│   │   └── docker-issues.md
│   │
│   ├── workflows/
│   │   ├── jenkins-ci-workflow.md
│   │   ├── jenkins-github-workflow.md
│   │   └── jenkins-docker-workflow.md
│   │
│   └── pdfs/
│       ├── Day-11-Jenkins-Fundamentals.pdf
│       ├── Day-12-Jenkins-Pipelines.pdf
│       ├── Day-13-Jenkins-GitHub.pdf
│       ├── Day-14-Jenkins-Docker.pdf
│       └── Day-15-Jenkins-Production.pdf
│
└── github-actions/
    └── ...
```

---

# 🚀 Commands Practiced

## Jenkins Service

```bash
sudo systemctl status jenkins
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl restart jenkins
```

## Jenkins Logs

```bash
sudo journalctl -u jenkins
sudo journalctl -u jenkins -f
```

## Java

```bash
java -version
```

## Git Commands Used by Jenkins

```bash
git clone <repository>
git checkout <branch>
git pull
```

## Docker Commands Jenkins May Execute

```bash
docker build -t backend:v1 .
docker tag backend:v1 vineet/backend:v1
docker push vineet/backend:v1
```

---

# 🧠 Core Concepts

- Jenkins
- Automation Server
- Continuous Integration
- Continuous Delivery
- Continuous Deployment
- CI/CD
- Jenkins Controller
- Jenkins Agent
- Jenkins Architecture
- Jenkins Job
- Jenkins Build
- Jenkins Pipeline
- Jenkinsfile
- Pipeline as Code
- Pipeline Stage
- Pipeline Step
- Freestyle Job
- Declarative Pipeline
- Scripted Pipeline
- Build Trigger
- Webhook
- Jenkins Workspace
- Console Output
- Build History
- Artifacts
- Environment Variables
- Jenkins Credentials
- Git Integration
- Docker Integration
- Docker Registry
- Pipeline Failure
- Agent Failure
- CI/CD Troubleshooting
- Production Deployment

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

# 📦 Job vs Build

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

# 🔄 Pipeline Workflow

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

# 🚨 Production Scenarios

## Day 11 – Jenkins Fundamentals

- Understand Jenkins as an automation server
- Explain CI/CD
- Explain Jenkins architecture
- Explain Controller vs Agent
- Explain Job vs Build
- Explain Pipeline
- Explain Jenkinsfile
- Explain the basic production CI/CD workflow

## Day 12 – Jenkins Jobs & Pipelines

- Create a Jenkins Job
- Run a Build
- Read Console Output
- Create a Pipeline
- Understand stages and steps
- Work with build history and artifacts

## Day 13 – Jenkins + GitHub

- Connect Jenkins to a Git repository
- Checkout application code
- Configure credentials
- Configure triggers
- Run an automated CI pipeline

## Day 14 – Jenkins + Docker

- Build a Docker image from Jenkins
- Tag the image
- Authenticate with a registry
- Push the image
- Troubleshoot Docker permission/authentication issues

## Day 15 – Production Jenkins

- Build a complete CI/CD workflow
- Troubleshoot failed pipelines
- Diagnose agent issues
- Diagnose Git/credentials failures
- Diagnose Docker failures
- Perform Jenkins interview revision

---

# 💡 Key Learnings

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

---

# 🎤 Interview Questions

## Day 11 – Jenkins Fundamentals

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

## Day 12 – Jenkins Jobs & Pipelines

- What is a Freestyle Job?
- What is a Pipeline Job?
- What are stages and steps?
- Declarative vs Scripted Pipeline?
- What is a build artifact?
- How do you inspect a failed build?
- What is Console Output?
- How do you parameterize a Jenkins job?

## Day 13 – Jenkins + GitHub

- How does Jenkins integrate with GitHub?
- What is a webhook?
- What can trigger a Jenkins build?
- How do Jenkins credentials work?
- How does Jenkins checkout source code?
- How would you troubleshoot a Git checkout failure?

## Day 14 – Jenkins + Docker

- How does Jenkins build a Docker image?
- How does Jenkins authenticate with Docker Hub?
- Why do we tag images before pushing?
- How would you troubleshoot Docker permission errors?
- Explain GitHub → Jenkins → Docker Registry workflow.

## Day 15 – Production Jenkins

- How would you troubleshoot a failed production pipeline?
- What happens if a Jenkins Agent goes offline?
- How do you handle credentials securely?
- How do you prevent a failed test from reaching deployment?
- Explain a complete Jenkins production CI/CD pipeline.
- Jenkins vs GitHub Actions?
- What would you monitor in a Jenkins installation?

---

# 📅 Revision Progress

- 🔥 Day 11 – Jenkins Fundamentals
- ⏳ Day 12 – Jenkins Jobs & Pipelines
- ⏳ Day 13 – Jenkinsfile & GitHub Integration
- ⏳ Day 14 – Jenkins + Docker
- ⏳ Day 15 – Production Jenkins & Interview Revision

**Jenkins: 1/5 complete. 🔥**

---

# 🎯 Goal

Learn Jenkins the way production DevOps engineers use it.

Instead of memorizing Jenkins UI options, understand the complete automation flow:

```text
Learn
  ↓
Understand
  ↓
Hands-on
  ↓
Break It
  ↓
Troubleshoot
  ↓
Explain
  ↓
Document
  ↓
Commit
```

The final goal is to confidently explain, build, troubleshoot, and maintain a production-oriented Jenkins CI/CD pipeline.
