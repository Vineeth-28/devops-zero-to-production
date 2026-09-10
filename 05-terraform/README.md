# Terraform — Infrastructure as Code

## Objective

Understand Terraform well enough to define, provision, modify, destroy and
troubleshoot infrastructure using Infrastructure as Code, especially AWS
infrastructure.

This is a **revision handbook**, not a beginner course. It assumes you
already understand Linux, Git, Docker, Jenkins, GitHub Actions, Kubernetes
and Helm. The focus here is mental models, practical usage, production
workflows, troubleshooting, and interview readiness.

Learning philosophy for this module:

```
Learn → Understand → Practice → Explain → Apply
```

---

## Terraform = Infrastructure as Code

Instead of clicking around a cloud console or running one-off CLI commands,
you write down what infrastructure *should* look like, and a tool makes
reality match that description.

Core workflow mental model:

```
Terraform Code
      ↓
terraform init
      ↓
terraform plan
      ↓
Review proposed changes
      ↓
terraform apply
      ↓
Infrastructure
```

The reconciliation loop underneath that workflow:

```
Desired State (your .tf files)
      ↓
Terraform
      ↓
Compare configuration / state / real infrastructure
      ↓
Determine changes needed
      ↓
Apply changes
```

That comparison step is the heart of Terraform. It is not a script that
runs commands top to bottom — it is a reconciler that diffs three things
(your code, your state file, and the real world) and figures out the
minimal set of changes needed.

---

## Folder Map

```
05-terraform/
│
├── README.md                  ← you are here
├── commands/                  ← command references, cheat-sheet style
├── concepts/                  ← deep explanations of core ideas
├── aws/                       ← realistic AWS + Terraform example project
├── modules/                   ← reusable VPC / EC2 / Security Group modules
├── labs/                      ← hands-on days (29, 30, 31)
├── troubleshooting/           ← realistic failure scenarios + fixes
├── workflows/                 ← end-to-end workflow diagrams (local, CI/CD)
└── interview/                 ← interview Q&A + final quiz
```

Use `concepts/` when you need to *understand* something. Use `commands/`
when you already understand it and just need the syntax. Use
`troubleshooting/` when something is broken. Use `interview/` the night
before an interview.

---

## How to Use This Handbook

1. **Before an interview** → read `interview/` end to end, then skim
   `concepts/terraform-state.md` and `concepts/modules.md` again — state
   and modules are where most candidates get caught out.
2. **During a real project** → keep `commands/` and `troubleshooting/`
   open in a tab.
3. **When something breaks** → go straight to `troubleshooting/`, find the
   closest matching scenario, follow the investigation steps.
4. **When working with AWS** → `aws/README.md` plus `modules/` gives you a
   safe, realistic starting point to copy from.
5. **When wiring Terraform into CI/CD** → `workflows/terraform-cicd-workflow.md`.

---

## Terraform vs Other DevOps Tools

| Tool | Responsibility |
|---|---|
| **Terraform** | Infrastructure provisioning / Infrastructure as Code |
| **Ansible** | Configuration management / server automation |
| **Docker** | Application / container packaging |
| **Kubernetes** | Container orchestration |
| **Helm** | Kubernetes package and release management |
| **Jenkins / GitHub Actions** | CI/CD (pipelines that run all of the above) |
| **Prometheus / Grafana** | Monitoring |

Two mental models for how these fit together:

```
Terraform
    ↓
Infrastructure
    ↓
Kubernetes
    ↓
Helm
    ↓
Application
```

```
Terraform
    ↓
EC2 / VPC / RDS / S3
    ↓
Ansible
    ↓
Server configuration
```

**Rule of thumb:** Terraform decides *what exists*. Ansible decides
*what's installed and configured on it*. Kubernetes decides *how containers
run on top of it*. Helm decides *how Kubernetes apps are packaged and
released*. They are layered, not competing.

---

## Terraform Architecture

```
Terraform CLI
      ↓
Provider
      ↓
Cloud / API
      ↓
Infrastructure
```

Concretely, for AWS:

```
Terraform
   ↓
AWS Provider
   ↓
AWS API
   ↓
VPC / EC2 / S3 / RDS
```

Key building blocks you'll see everywhere in this handbook:

- **Terraform CLI** — the binary you run (`terraform init/plan/apply/...`)
- **Providers** — plugins that translate Terraform into API calls for AWS,
  Azure, GCP, Kubernetes, GitHub, Cloudflare, etc.
- **Resources** — infrastructure objects Terraform creates and manages
- **Data sources** — read-only lookups of existing information
- **State** — Terraform's record of what it manages and how config maps
  to real infrastructure
- **Backend** — where and how that state is stored
- **Modules** — reusable, parameterized bundles of Terraform configuration

Full detail on each of these lives in `concepts/`.

---

## The Complete DevOps Stack (context for this module)

```
GitHub
    ↓
CI/CD
    ↓
Terraform
    ↓
AWS Infrastructure
    ↓
Docker
    ↓
Kubernetes
    ↓
Helm
    ↓
Application
    ↓
Prometheus
    ↓
Grafana
```

Terraform's job in this picture is narrow and specific: get the
infrastructure (VPC, EC2, EKS cluster, S3, RDS, IAM, networking) into
existence and keep it in the state you've declared. Everything above
"Infrastructure" in that diagram is a different tool's job.

---

## Final Mental Model

```
Terraform
    ↓
Desired Infrastructure
    ↓
Provider
    ↓
Plan
    ↓
State
    ↓
Apply
    ↓
Cloud Infrastructure
```

```
Learn → Understand → Practice → Explain → Apply
```

🚀 DevOps Zero to Production
