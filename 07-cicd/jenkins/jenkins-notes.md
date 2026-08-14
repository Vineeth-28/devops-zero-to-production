# Jenkins — Day 11 Notes

## What is Jenkins?
Jenkins is an automation server used to automate CI/CD workflows.

Common tasks:
- Checkout code
- Build applications
- Run tests
- Package applications
- Build Docker images
- Push images
- Deploy applications

## CI/CD

### Continuous Integration
```text
Code Push → Checkout → Build → Test
```

### Continuous Delivery / Deployment
```text
Build → Test → Package → Deploy
```

## Architecture
```text
                 Jenkins
                    │
              Controller
                    │
          ┌─────────┴─────────┐
          ↓                   ↓
       Agent 1              Agent 2
       Linux                Windows
          │                   │
       Build                Test
```

Controller = coordinator. Agent = worker.

## Job vs Build
```text
Job: backend-build
    ├── Build #1
    ├── Build #2
    └── Build #3
```

## Pipeline
```text
Checkout → Build → Test → Docker Build → Docker Push → Deploy
```

## Jenkinsfile
A Jenkinsfile stores the pipeline definition as code.

Benefits:
- Version controlled
- Reviewable
- Reproducible
- Stored alongside application code
