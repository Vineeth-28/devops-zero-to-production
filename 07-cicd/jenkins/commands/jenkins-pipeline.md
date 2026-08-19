# Jenkins — Pipeline Syntax Reference

## Declarative vs Scripted

| | Declarative | Scripted |
|---|---|---|
| Syntax | Structured, `pipeline { }` block | Groovy code, `node { }` block |
| Learning curve | Easier, opinionated | More flexible, needs Groovy knowledge |
| Validation | Linted before run | Errors surface at runtime |
| Recommended for | Most teams / most pipelines | Complex custom logic |

## Declarative Pipeline — Full Skeleton
```groovy
pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    parameters {
        choice(name: 'ENV', choices: ['staging', 'production'], description: 'Target environment')
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run test suite')
    }

    environment {
        APP_ENV = "${params.ENV}"
        DOCKER_REGISTRY = credentials('docker-registry-url')
    }

    triggers {
        githubPush()
        cron('H 2 * * *')
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Build') {
            steps { sh 'make build' }
        }

        stage('Test') {
            when { expression { params.RUN_TESTS } }
            steps { sh 'make test' }
            post {
                always { junit 'reports/**/*.xml' }
            }
        }

        stage('Deploy') {
            when { branch 'main' }
            steps { sh 'make deploy ENV=${APP_ENV}' }
        }
    }

    post {
        success { echo 'Build succeeded' }
        failure { mail to: 'team@example.com', subject: 'Build failed', body: "${env.BUILD_URL}" }
        always { cleanWs() }
    }
}
```

## Scripted Pipeline Example
```groovy
node {
    stage('Checkout') {
        checkout scm
    }
    stage('Build') {
        sh 'make build'
    }
    stage('Test') {
        try {
            sh 'make test'
        } catch (err) {
            currentBuild.result = 'UNSTABLE'
        }
    }
}
```

## Shared Libraries
```groovy
// Jenkinsfile
@Library('my-shared-library') _
myPipeline(env: 'staging')
```
```groovy
// vars/myPipeline.groovy in the shared library repo
def call(Map config) {
    pipeline {
        agent any
        stages {
            stage('Build') { steps { sh "make build ENV=${config.env}" } }
        }
    }
}
```

## Common `when` Conditions
```groovy
when { branch 'main' }
when { environment name: 'DEPLOY_ENV', value: 'production' }
when { expression { return params.RUN_TESTS } }
when { changeRequest() }        // only on PRs
when { not { branch 'main' } }
when { allOf { branch 'main'; expression { params.DEPLOY } } }
```

## Docker Agents
```groovy
pipeline {
    agent { docker { image 'node:20-alpine' } }
    stages {
        stage('Test') { steps { sh 'npm ci && npm test' } }
    }
}
```
