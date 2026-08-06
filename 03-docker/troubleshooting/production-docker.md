# Production Docker Troubleshooting

Common production Docker problems, their causes, diagnosis, and solutions.

---

# 🎯 Objective

Learn how to troubleshoot production Docker environments by identifying common issues related to image size, builds, containers, health checks, restart policies, resource limits, and security.

---

# 🔍 Troubleshooting Workflow

```text
Application Issue
        │
        ▼
docker ps
        │
        ▼
docker logs
        │
        ▼
docker inspect
        │
        ▼
docker stats
        │
        ▼
Identify Root Cause
        │
        ▼
Apply Fix
```

---

# 🚨 Problem 1 — Docker Image is Too Large

## Symptoms

- Slow builds
- Slow pushes
- Slow pulls
- High storage usage

---

## Possible Causes

- Large base image
- No Multi-stage Build
- No `.dockerignore`
- Development dependencies included
- Unnecessary files copied

---

## Diagnosis

Check image size

```bash
docker images
```

Inspect image layers

```bash
docker history IMAGE_NAME
```

---

## Solution

- Use Multi-stage Builds
- Use `node:alpine`
- Create `.dockerignore`
- Remove development dependencies

---

# 🚨 Problem 2 — Docker Build is Slow

## Symptoms

Every build runs `npm install`.

---

## Cause

Poor Dockerfile layer ordering.

Wrong

```dockerfile
COPY . .

RUN npm install
```

---

Correct

```dockerfile
COPY package*.json ./

RUN npm install

COPY . .
```

Docker reuses cached layers.

---

# 🚨 Problem 3 — Build Context is Too Large

## Symptoms

Docker displays

```text
Sending build context...
```

for a long time.

---

## Cause

Everything is copied.

Example

```text
node_modules
.git
.env
coverage
README.md
```

---

## Solution

Create

```text
.dockerignore
```

Example

```text
node_modules
.git
.env
coverage
*.log
README.md
.vscode
.idea
```

---

# 🚨 Problem 4 — Container Stops Immediately

## Symptoms

```bash
docker ps
```

shows nothing.

---

## Diagnosis

```bash
docker ps -a
```

Check logs

```bash
docker logs CONTAINER_NAME
```

---

## Possible Causes

- Wrong CMD
- Application crash
- Missing environment variables

---

## Solution

Fix application errors.

Restart container.

---

# 🚨 Problem 5 — Application is Running but Not Working

## Symptoms

Container status

```text
Up
```

Browser

```text
Application Not Responding
```

---

## Cause

Application crashed internally.

Docker only knows the container is running.

---

## Solution

Use Health Checks.

Example

```dockerfile
HEALTHCHECK CMD curl -f http://localhost:3000 || exit 1
```

---

# 🚨 Problem 6 — Container Doesn't Restart

## Symptoms

Application crashes.

Container remains stopped.

---

## Cause

No restart policy.

---

## Solution

Docker Compose

```yaml
restart: always
```

Available policies

```yaml
restart: always
restart: unless-stopped
restart: on-failure
restart: no
```

---

# 🚨 Problem 7 — Container Uses Too Much Memory

## Symptoms

Server becomes slow.

Other containers crash.

---

## Diagnosis

```bash
docker stats
```

---

## Solution

Set memory limits.

```yaml
deploy:
  resources:
    limits:
      memory: 512M
```

---

# 🚨 Problem 8 — Secrets Included Inside Image

## Symptoms

Environment variables visible inside Docker image.

---

## Cause

Copied

```text
.env
```

into image.

---

## Solution

Ignore secrets.

`.dockerignore`

```text
.env
```

Use runtime environment variables instead.

---

# 🚨 Problem 9 — Alpine Compatibility Issues

## Symptoms

Application fails after switching to Alpine.

---

## Cause

Some native libraries may not be compatible.

---

## Solution

- Install required libraries.
- Use `node:slim` if Alpine is incompatible.

---

# 🚨 Problem 10 — High Disk Usage

## Diagnosis

```bash
docker system df
```

---

## Solution

Remove unused resources.

```bash
docker image prune
```

Remove unused containers

```bash
docker container prune
```

Remove unused volumes

```bash
docker volume prune
```

Remove everything unused

```bash
docker system prune
```

---

# 🛠 Useful Commands

View Images

```bash
docker images
```

Image History

```bash
docker history IMAGE_NAME
```

View Logs

```bash
docker logs CONTAINER_NAME
```

Inspect Container

```bash
docker inspect CONTAINER_NAME
```

Resource Usage

```bash
docker stats
```

Running Containers

```bash
docker ps
```

All Containers

```bash
docker ps -a
```

Disk Usage

```bash
docker system df
```

Cleanup

```bash
docker system prune
```

---

# 🏭 Production Checklist

Before deployment verify:

- ✅ Multi-stage Build
- ✅ Small Base Image
- ✅ `.dockerignore`
- ✅ Docker Layer Caching
- ✅ Health Check
- ✅ Restart Policy
- ✅ Resource Limits
- ✅ No Secrets Inside Image
- ✅ Optimized Image Size

---

# 🎤 Interview Questions

### Why is my Docker image large?

- Large base image
- Development dependencies
- No Multi-stage Build
- No `.dockerignore`

---

### Why is Docker Build slow?

Poor Dockerfile layer ordering.

---

### Why use Health Checks?

To verify application health instead of only container status.

---

### Why use Restart Policies?

To automatically recover from application crashes.

---

### Why use Resource Limits?

To prevent one container from consuming all host resources.

---

### Why should `.env` not be copied?

To prevent sensitive information from being embedded inside Docker images.

---

# 🎯 Summary

Production Docker troubleshooting focuses on identifying issues with:

- Image optimization
- Build performance
- Build context
- Health monitoring
- Restart behavior
- Resource consumption
- Security
- Storage usage

Following production best practices results in smaller, faster, more secure, and more reliable Docker deployments.