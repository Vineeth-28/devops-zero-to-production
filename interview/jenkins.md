# Jenkins Interview Questions

Based on `../07-cicd/jenkins/` (commands/, jenkinsfiles/, troubleshooting/, workflows/).

---

## Q1. Explain Jenkins' Controller/Agent architecture and why you'd run builds on agents rather than the controller.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Understanding of Jenkins' distributed architecture and a key production practice.

### Expected Answer
The Controller (formerly "master") schedules jobs, serves the UI, and manages configuration; Agents are separate machines/containers that actually execute build steps. Running builds on the Controller directly is discouraged in production because it competes for resources with the scheduling/UI process itself, and a bad build (resource exhaustion, hung process) can take down the whole Jenkins instance rather than just one agent.

### Strong Interview Answer
"The Controller handles scheduling, the UI, plugin management, and job configuration — it's the brain. Agents are separate machines or containers that actually run the build steps, connecting back to the Controller. In production I always push actual build execution onto agents, never the Controller directly, because if a build hangs or exhausts memory/CPU on the Controller itself, it can degrade or take down the entire Jenkins instance for everyone, not just that one job. Isolating execution on agents also lets me scale build capacity independently and give different jobs different environments."

### Follow-up Questions
- How does a Controller decide which agent to send a job to?
- What's the difference between a static agent and a dynamically provisioned (e.g. Docker/Kubernetes) agent?
- What would you check if a job stays queued and never gets picked up by any agent?

### Key Points
- Controller = scheduling/UI/config; Agent = actual build execution.
- Never run builds on the Controller in production — resource and stability risk.
- Agents allow scaling build capacity and isolating different environments per job.

---

## Q2. What's the difference between a Declarative and a Scripted Jenkins Pipeline?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Baseline pipeline-syntax fluency.

### Expected Answer
Declarative Pipeline uses a structured, opinionated syntax (`pipeline { stages { stage { steps { } } } }`) that's easier to read, validate, and lint, at the cost of some flexibility. Scripted Pipeline is raw Groovy with full programmatic flexibility but is harder to read/maintain and easier to write something fragile.

### Strong Interview Answer
"Declarative uses a fixed, structured block syntax — `pipeline`, `stages`, `stage`, `steps` — which is easier to read, gets built-in validation, and is what most teams default to now. Scripted is essentially raw Groovy, giving you full programmatic control — loops, complex conditionals, whatever Groovy can do — but it's harder to read and maintain, and easier to write something that's fragile or hard for someone else to follow. I default to Declarative and only drop into a Scripted block (`script { }` within a Declarative pipeline) for the specific piece of logic that genuinely needs that flexibility."

### Follow-up Questions
- How do you embed Scripted syntax inside a Declarative pipeline for one specific step?
- What validation does Declarative give you that Scripted doesn't?
- When have you actually needed Scripted's extra flexibility?

### Key Points
- Declarative = structured, readable, validated, opinionated syntax (preferred default).
- Scripted = raw Groovy, maximum flexibility, harder to maintain.
- You can mix: a `script {}` block inside Declarative for specific complex logic.

---

## Q3. What's a Jenkins Shared Library, and why use one?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Awareness of pipeline reuse patterns across multiple projects/teams.

### Expected Answer
A Shared Library is a separate, versioned repository of reusable Groovy code (custom steps, functions) that any Jenkinsfile can import and call, avoiding duplicating the same pipeline logic (e.g. a standard "build, test, notify Slack" sequence) across every project's Jenkinsfile.

### Strong Interview Answer
"A Shared Library is a separate git repo holding reusable pipeline code — custom steps or whole functions — that any Jenkinsfile across the org can import with a single `@Library` line, instead of every team copy-pasting the same 40 lines of 'build, test, notify' logic into their own Jenkinsfile. It's especially valuable when you want a standard practice — like how deployments notify Slack, or how test results get published — enforced consistently and updated in one place rather than N places."

### Follow-up Questions
- How do you version a Shared Library so teams aren't broken by an update to it?
- What's the difference between a global and a per-project Shared Library?
- How would you test changes to a Shared Library before rolling it out broadly?

### Key Points
- Shared Library = versioned, reusable Groovy pipeline code, imported via `@Library`.
- Prevents duplicating common pipeline logic across every project's Jenkinsfile.
- Should be versioned/tagged so teams control when they pick up changes.

---

## Q4. A Jenkins pipeline job fails but a manual run of the same commands locally works fine. What do you check?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Understanding of environment differences between a developer's machine and a CI agent.

### Expected Answer
Check for environment differences: different tool versions on the agent (Java, Node, Docker), missing environment variables/credentials that are set locally but not injected into the Jenkins job, working directory/path assumptions that differ, or the agent lacking permissions/network access a local machine has. Read the actual Jenkins console output for the precise error rather than assuming it's identical to local.

### Strong Interview Answer
"Locally working but CI failing almost always means an environment difference, so I go through them systematically. First, tool versions — is the agent running the same Node/Java/Docker version I have locally? Then environment variables and credentials — locally I might have things exported in my shell that the Jenkins job never gets unless explicitly configured via `withCredentials` or environment blocks. Then path/working-directory assumptions — a script that assumes it's run from repo root might behave differently under Jenkins' workspace layout. And I always read the actual Jenkins console log carefully first, since the real error is usually right there and saves guessing."

### Follow-up Questions
- How would you pin a specific tool version for a Jenkins agent to match local development?
- How do credentials get securely injected into a pipeline without hardcoding them?
- What's the Jenkins workspace, and how could its layout differ from a developer's local checkout?

### Key Points
- Suspect environment drift first: tool versions, missing env vars/credentials, working-directory assumptions.
- Read the actual Jenkins console output — don't assume the failure mirrors local exactly.
- Credentials must be explicitly injected into the job (e.g. `withCredentials`), not just present in someone's shell.

---

## Q5. How does Jenkins RBAC/permissions typically work, and why does it matter for pipeline security?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Security-mindedness around who can trigger/modify what in a CI system.

### Expected Answer
Jenkins supports role-based access control (often via a plugin like Role-Based Authorization Strategy) restricting who can configure jobs, view credentials, trigger builds, or access specific folders/projects. This matters because Jenkins often holds powerful credentials (deploy keys, cloud access) — overly broad permissions mean a compromised or careless account could trigger unauthorized deployments or exfiltrate secrets.

### Strong Interview Answer
"Jenkins RBAC, usually via a role-based authorization plugin, lets you scope who can view or edit specific jobs/folders, who can trigger builds, and critically who can access stored credentials. It matters a lot because Jenkins is frequently holding the keys to production — deploy credentials, cloud API keys — so if permissions are too broad, a compromised or just careless account could trigger an unintended production deployment or read out secrets that should be scoped to a specific pipeline. I'd scope credentials to the specific jobs/folders that need them rather than making everything globally available, and restrict who can edit Jenkinsfiles for sensitive pipelines."

### Follow-up Questions
- What's the difference between a credential scoped globally vs. scoped to a specific folder/job?
- How would you prevent a pull request from an untrusted contributor from running a pipeline with access to production secrets?
- What audit trail does Jenkins give you for who triggered a given build?

### Key Points
- RBAC scopes who can view/edit jobs, trigger builds, and access credentials.
- Jenkins often holds sensitive deploy credentials — permission scope is a real security control.
- Scope credentials to specific jobs/folders, not globally, to limit blast radius.

---

## Q6. Jenkins vs GitHub Actions — how would you compare them, and how would you choose between them for a new project?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Cross-technology judgment — a very common comparison question.

### Expected Answer
Jenkins is self-hosted, highly extensible via plugins, gives full infrastructure control, but requires you to maintain the server/agents yourself. GitHub Actions is managed/hosted by GitHub, tightly integrated with GitHub repos and events, easier to get started with, but less flexible for complex custom infrastructure and ties you to GitHub's ecosystem. Choice depends on: existing infrastructure investment, need for custom agent environments/on-prem access, and whether the org is already fully on GitHub.

### Strong Interview Answer
"Jenkins is self-hosted and extremely flexible via its huge plugin ecosystem, but that flexibility comes with the operational cost of maintaining the Jenkins server and its agents yourself. GitHub Actions is fully managed by GitHub, integrates natively with repo events, and needs almost no setup to get a basic pipeline running, but you're more constrained to what Actions and its marketplace support, and you're tied into GitHub's ecosystem. For a new project already living on GitHub with fairly standard build/test/deploy needs, I'd default to Actions for the lower operational overhead. I'd reach for Jenkins when there's a need for tight control over the build environment, on-prem/internal network access agents can't easily get otherwise, or the org already has significant Jenkins infrastructure and expertise."

### Follow-up Questions
- What's a scenario where Jenkins' self-hosted nature is a genuine requirement, not just preference?
- How does cost scale differently between the two as usage grows?
- Could you use both together in one organization, and why might that make sense?

### Key Points
- Jenkins = self-hosted, highly extensible, more operational overhead.
- GitHub Actions = managed, tightly GitHub-integrated, faster to start, less infra control.
- Choice depends on existing infra, need for custom/on-prem agents, and ecosystem lock-in tolerance.

---
