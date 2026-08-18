# Jenkins — Revision Notes / Cheatsheet

## Core Concepts

- **Controller (Master)**: schedules builds, dispatches to agents, serves the web UI, stores config.
- **Agent (Node)**: executes the actual build steps. Can be static (permanent) or dynamic (Docker/K8s/cloud).
- **Executor**: a slot on a node that can run one build at a time.
- **Job/Project**: a configured unit of work (Freestyle, Pipeline, Multibranch Pipeline, etc.).
- **Build**: one execution of a job.
- **Workspace**: the directory on the agent where a job's files live during a build.

## Job Types

| Type | Use case |
|------|----------|
| Freestyle project | Simple, UI-configured jobs — good for learning, not for complex logic |
| Pipeline | Jenkinsfile-based, code-as-config, supports Declarative & Scripted syntax |
| Multibranch Pipeline | Auto-discovers branches/PRs in a repo, each gets its own pipeline run |
| Folder | Organizational grouping of jobs |

## Declarative Pipeline Skeleton

```groovy
pipeline {
    agent any
    environment {
        APP_ENV = 'staging'
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Build') {
            steps { sh 'make build' }
        }
        stage('Test') {
            steps { sh 'make test' }
        }
        stage('Deploy') {
            when { branch 'main' }
            steps { sh 'make deploy' }
        }
    }
    post {
        always { echo 'Pipeline finished' }
        failure { echo 'Pipeline failed' }
    }
}
```

## Key Plugins

- **Git / GitHub / GitHub Branch Source** — SCM integration
- **Pipeline** (and Pipeline: Stage View) — Jenkinsfile support + visualization
- **Credentials Binding** — inject secrets into pipelines safely
- **Docker Pipeline** — build/run containers as build steps or agents
- **Blue Ocean** — modern pipeline visualization UI
- **Role-based Authorization Strategy** — fine-grained access control

## Credential Types

- Username/password
- SSH username with private key
- Secret text (API tokens)
- Secret file
- Certificate

Always reference credentials by ID, never hardcode secrets in a Jenkinsfile:
```groovy
withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
    sh 'docker login -u $USER -p $PASS'
}
```

## Triggers

- **Poll SCM**: `H/5 * * * *` — cron-style polling
- **GitHub webhook**: push-based, near-instant, preferred over polling
- **Build periodically**: pure cron, independent of SCM changes
- **Build after other projects**: upstream/downstream chaining

## Useful `sh` / Groovy Snippets

```groovy
// Parallel stages
stage('Test') {
    parallel {
        stage('Unit') { steps { sh 'npm run test:unit' } }
        stage('Lint') { steps { sh 'npm run lint' } }
    }
}

// Retry a flaky step
retry(3) { sh './flaky-script.sh' }

// Timeout a stage
timeout(time: 10, unit: 'MINUTES') { sh './long-task.sh' }
```

## Backup Essentials (JENKINS_HOME)

- `config.xml` — global config
- `jobs/` — all job definitions and build history
- `secrets/` — encryption keys (critical — back these up!)
- `plugins/` — installed plugins

## See Also

- [commands/jenkins.md](commands/jenkins-md) — CLI & general commands
- [jenkins-pipeline.md](commands/jenkins-pipeline.md) — pipeline-specific syntax
- [troubleshooting/jenkins.md](troubleshooting/jenkins.md)
