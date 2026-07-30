# Docker Workflow

This document explains the typical Docker workflow followed by developers and DevOps engineers, from writing code to deploying containerized applications in production.

---

# Docker Development Workflow

```text
Write Code
     │
     ▼
Create Dockerfile
     │
     ▼
Build Docker Image
     │
     ▼
Run Docker Container
     │
     ▼
Test Application
     │
     ▼
Fix Bugs
     │
     ▼
Rebuild Image
     │
     ▼
Push Image to Registry
     │
     ▼
Deploy to Production
```

---

# Step 1 - Write Application

Develop your application normally.

Example:

```text
Node.js
Python
Java
Go
.NET
PHP
```

---

# Step 2 - Create a Dockerfile

The Dockerfile defines how the Docker image will be built.

Example:

```Dockerfile
FROM node:22-alpine

WORKDIR /app

COPY . .

RUN npm install

CMD ["npm","start"]
```

---

# Step 3 - Build the Docker Image

```bash
docker build -t my-app .
```

Result:

```text
Source Code
      │
      ▼
Dockerfile
      │
      ▼
Docker Image
```

---

# Step 4 - Verify Images

```bash
docker images
```

Verify:

- Image name
- Tag
- Image ID
- Size

---

# Step 5 - Run Container

```bash
docker run my-app
```

Docker internally:

```text
Image

↓

Create Container

↓

Allocate Resources

↓

Start Process

↓

Application Running
```

---

# Step 6 - Verify Running Containers

```bash
docker ps
```

See:

- Container ID
- Image
- Status
- Ports
- Names

---

# Step 7 - Inspect Logs

```bash
docker logs CONTAINER_ID
```

Useful for:

- Startup failures
- Runtime errors
- Debugging

---

# Step 8 - Stop Container

```bash
docker stop CONTAINER_ID
```

---

# Step 9 - Restart Container

```bash
docker start CONTAINER_ID
```

or

```bash
docker restart CONTAINER_ID
```

---

# Step 10 - Remove Container

```bash
docker rm CONTAINER_ID
```

---

# Step 11 - Remove Image

```bash
docker rmi IMAGE_NAME
```

---

# Production Workflow

```text
Developer

↓

Git Push

↓

CI/CD Pipeline

↓

Docker Build

↓

Run Tests

↓

Create Image

↓

Push Image

↓

Container Registry

↓

Production Server

↓

Pull Image

↓

Run Container

↓

Application Live
```

---

# Image Lifecycle

```text
Dockerfile

↓

Build

↓

Image

↓

Push

↓

Registry

↓

Pull

↓

Run

↓

Container
```

---

# Container Lifecycle

```text
Create

↓

Run

↓

Pause

↓

Resume

↓

Stop

↓

Start

↓

Remove
```

---

# Production Deployment Checklist

Before deployment, verify:

- Docker daemon is running.
- Docker image builds successfully.
- Application starts without errors.
- Required ports are exposed.
- Environment variables are configured.
- Container logs are clean.
- Image version is tagged correctly.
- Secrets are not stored inside the image.

---

# Best Practices

- Use official base images.
- Tag images with versions.
- Avoid using the `latest` tag in production.
- Keep images lightweight.
- Rebuild images after code changes.
- Remove unused images and containers.
- Store secrets outside the image.
- Test images locally before deployment.

---

# Common Production Workflow

```text
Developer

↓

Write Code

↓

Commit

↓

Push to GitHub

↓

CI/CD Pipeline

↓

Docker Build

↓

Docker Registry

↓

Production Server

↓

Run Container

↓

Monitor Logs
```

---

# Real-World Example

A Node.js application deployment:

```text
Developer

↓

GitHub Repository

↓

GitHub Actions

↓

Docker Build

↓

Docker Hub

↓

AWS EC2

↓

docker pull

↓

docker run

↓

Application Running
```

---

# Key Takeaways

- Docker packages applications with all required dependencies.
- Images are immutable templates.
- Containers are running instances of images.
- Every deployment should use a tagged image.
- Containers should be recreated from new images instead of being modified manually.
- A consistent Docker workflow improves reliability across development and production.

---

# Interview Questions

- Explain the Docker workflow from development to production.
- What happens after running `docker build`?
- What happens internally when `docker run` is executed?
- Why should images be versioned?
- Why shouldn't the `latest` tag be used in production?
- What is the difference between an image lifecycle and a container lifecycle?
- How would you deploy a Docker image to production?
- How does Docker fit into a CI/CD pipeline?