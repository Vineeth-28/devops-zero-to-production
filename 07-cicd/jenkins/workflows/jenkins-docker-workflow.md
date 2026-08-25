# Workflow — Jenkins + Docker Build & Deploy

```
Jenkinsfile triggers pipeline
        │
        ▼
Stage: Checkout ─────────────────────────────┐
        │                                    │
        ▼                                    │
Stage: Build Image                           │  agent runs on host
  docker build -t app:${BUILD_NUMBER} .      │  with Docker socket
        │                                    │  mounted/available
        ▼                                    │
Stage: Scan Image (optional)                 │
  docker scan / trivy                        │
        │                                    │
        ▼                                    │
Stage: Push Image                            │
  docker login → docker push                 │
  tags: ${BUILD_NUMBER}, latest              │
        │                                    │
        ▼                                    │
Stage: Deploy (when branch == main)          │
  docker stop/rm old container               │
  docker run new image                       │
        │                                    │
        ▼                                    │
post { always { docker logout; cleanWs() } } ┘
```

## Two Integration Patterns

**1. Docker-outside-of-Docker (recommended for most teams)**
- Mount `/var/run/docker.sock` into the Jenkins controller/agent container
- Jenkins issues `docker build`/`docker push` commands that run on the *host* Docker daemon
- Simple, shares image layer cache with host, but containers started this way are siblings of Jenkins, not children

**2. Docker-in-Docker (DinD)**
- A full Docker daemon runs inside a sidecar container dedicated to the build
- Better isolation between builds, but higher overhead and networking is trickier

## Registry Auth
Store registry credentials in Jenkins as "Username with password", inject via `withCredentials` or the `environment { REGISTRY_CREDS = credentials('id') }` shortcut — never hardcode in the Jenkinsfile.

## Reference Jenkinsfile
See [`jenkinsfiles/docker/Jenkinsfile`](../jenkinsfiles/docker/Jenkinsfile).
