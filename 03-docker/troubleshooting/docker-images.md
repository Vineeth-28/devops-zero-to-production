# Docker Images Troubleshooting

This document covers common Docker image build errors, Dockerfile mistakes, image cache issues, tagging problems, and production troubleshooting techniques.

---

# Docker Image Troubleshooting Workflow

```text
Problem
   │
   ▼
Read Error Message
   │
   ▼
Identify Failed Dockerfile Instruction
   │
   ▼
Inspect Build Logs
   │
   ▼
Verify Dockerfile
   │
   ▼
Rebuild Image
   │
   ▼
Verify Solution
```

---

# Unable to Find Base Image

## Error

```text
pull access denied
```

or

```text
manifest unknown
```

## Cause

- Incorrect image name
- Incorrect tag
- Private repository
- Authentication required

## Solution

Verify image name.

Example

```bash
docker pull nginx
```

or

```bash
docker login
```

---

# Dockerfile Not Found

## Error

```text
failed to read dockerfile
```

## Cause

Dockerfile is missing or incorrectly named.

## Solution

Verify:

```text
Dockerfile
```

The filename should have no extension.

Correct

```text
Dockerfile
```

Incorrect

```text
Dockerfile.txt
```

---

# Build Context Too Large

## Cause

Unnecessary files are copied during build.

Example

```text
node_modules
.git
dist
coverage
```

## Solution

Create a `.dockerignore`

Example

```text
node_modules
.git
.env
coverage
dist
```

---

# COPY Failed

## Error

```text
COPY failed
```

## Cause

File does not exist inside the build context.

## Solution

Verify file path.

Example

```Dockerfile
COPY index.html /usr/share/nginx/html/
```

Ensure `index.html` exists in the build directory.

---

# RUN Command Failed

## Error

```text
executor failed running
```

## Cause

Invalid command.

Missing packages.

Syntax error.

## Solution

Verify command manually.

Example

```Dockerfile
RUN npm ci
```

Ensure dependencies exist.

---

# CMD Not Working

## Cause

Incorrect executable.

Wrong syntax.

## Solution

Use JSON array syntax.

Correct

```Dockerfile
CMD ["npm","start"]
```

Avoid shell form unless required.

---

# ENTRYPOINT Problems

## Cause

ENTRYPOINT overrides default startup behavior.

## Solution

Verify ENTRYPOINT.

Example

```Dockerfile
ENTRYPOINT ["node"]
```

---

# Image Build Uses Old Files

## Cause

Docker build cache reused previous layers.

## Solution

Rebuild without cache.

```bash
docker build --no-cache -t my-app .
```

---

# Image Too Large

## Cause

Large base image.

Copied unnecessary files.

Too many build artifacts.

## Solution

- Use Alpine images.
- Remove unnecessary files.
- Use `.dockerignore`.
- Remove temporary files during build.

---

# Wrong Image Tag

## Example

```text
latest
```

## Problem

Production deployments become unpredictable.

## Solution

Use version tags.

```text
my-app:v1.0.0
```

---

# Unable to Remove Image

## Error

```text
image is being used by stopped container
```

## Solution

Remove containers first.

```bash
docker ps -a
```

Remove container.

```bash
docker rm CONTAINER_ID
```

Then remove image.

```bash
docker rmi IMAGE_ID
```

---

# Image Build Is Slow

## Cause

Dockerfile instruction order.

Cache invalidation.

Large build context.

## Solution

Good

```Dockerfile
COPY package*.json ./

RUN npm ci

COPY . .
```

Bad

```Dockerfile
COPY . .

RUN npm ci
```

---

# Build Cache Not Working

## Cause

Earlier Dockerfile instruction changed.

## Solution

Place frequently changing files at the end of the Dockerfile.

---

# Build Context Missing Files

## Cause

Incorrect build directory.

## Solution

Run build from the project root.

Example

```bash
docker build -t my-app .
```

---

# Inspect Image

Useful command

```bash
docker image inspect IMAGE_NAME
```

Displays

- Metadata
- Environment variables
- Layers
- Configuration

---

# View Image History

```bash
docker history IMAGE_NAME
```

Useful for

- Layer analysis
- Image optimization
- Build debugging

---

# Useful Docker Commands

Build

```bash
docker build -t my-app .
```

Images

```bash
docker images
```

Inspect

```bash
docker image inspect my-app
```

History

```bash
docker history my-app
```

Remove Image

```bash
docker rmi my-app
```

No Cache Build

```bash
docker build --no-cache -t my-app .
```

---

# Production Troubleshooting Checklist

- Is Dockerfile valid?
- Does the base image exist?
- Are image tags correct?
- Is `.dockerignore` configured?
- Are files copied correctly?
- Is Docker cache causing issues?
- Is the build context correct?
- Is the image optimized?
- Are dependencies installed successfully?

---

# Production Best Practices

- Use official images.
- Pin image versions.
- Keep Dockerfiles small.
- Reduce image layers.
- Use `.dockerignore`.
- Never use `latest` in production.
- Rebuild images after code changes.
- Scan images for vulnerabilities.
- Use immutable image tags.

---

# Common Production Scenarios

## Scenario 1

Application builds locally but fails in CI.

**Cause**

Missing dependency.

**Solution**

Build using the same Dockerfile everywhere.

---

## Scenario 2

Image size exceeds 1 GB.

**Solution**

Use Alpine base image.

Remove unnecessary packages.

---

## Scenario 3

Every build downloads dependencies.

**Solution**

Optimize Docker layer caching.

---

## Scenario 4

Deployment uses incorrect application version.

**Solution**

Deploy using explicit image tags.

---

# Interview Questions

- Why is my Docker image build slow?
- Why is Docker cache not working?
- What causes COPY failures?
- How do you reduce Docker image size?
- Why shouldn't `latest` be used in production?
- How do you inspect Docker images?
- What does `docker history` show?
- How do you troubleshoot Docker image build failures?
```