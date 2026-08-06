

# Docker Registry Workflow

Docker Registry Workflow explains how Docker images move from development to production using image repositories, versioning, tagging, and container registries.

---

# 🎯 Objective

Understand the complete Docker Registry lifecycle, from building an image to storing it in a registry and deploying it on production servers.

---

# 🏗 Workflow 1 – Build Docker Image

```text
Developer
      │
      ▼
Application Source Code
      │
      ▼
Dockerfile
      │
      ▼
docker build
      │
      ▼
Docker Image
```

Command

```bash
docker build -t backend:v1.0 .
```

---

# 🏷 Workflow 2 – Tag Docker Image

A local image must be tagged with the registry repository before pushing.

Workflow

```text
Local Image
backend:v1.0
      │
      ▼
docker tag
      │
      ▼
username/backend:v1.0
```

Command

```bash
docker tag backend:v1.0 username/backend:v1.0
```

---

# 🔐 Workflow 3 – Login to Registry

Before pushing an image, authenticate with the registry.

```text
Developer
      │
      ▼
docker login
      │
      ▼
Docker Registry Authentication
```

Command

```bash
docker login
```

---

# 🚀 Workflow 4 – Push Image

Upload the tagged image to the registry.

```text
Tagged Image
      │
      ▼
docker push
      │
      ▼
Docker Registry
```

Command

```bash
docker push username/backend:v1.0
```

---

# 📦 Workflow 5 – Docker Registry

The registry stores multiple versions of Docker images.

```text
Docker Registry

├── backend:v1.0
├── backend:v1.1
├── backend:v2.0
└── backend:latest
```

Benefits

- Version control
- Centralized image storage
- Easy collaboration
- Reliable deployments

---

# 📥 Workflow 6 – Pull Image

Production servers download images from the registry.

```text
Docker Registry
      │
      ▼
docker pull
      │
      ▼
Production Server
```

Command

```bash
docker pull username/backend:v1.0
```

---

# ▶ Workflow 7 – Run Container

After pulling the image:

```text
Docker Image
      │
      ▼
docker run
      │
      ▼
Running Container
```

Command

```bash
docker run -d -p 3000:3000 username/backend:v1.0
```

---

# 🏭 Workflow 8 – Complete Production Pipeline

```text
Developer
      │
      ▼
Write Code
      │
      ▼
docker build
      │
      ▼
Docker Image
      │
      ▼
docker tag
      │
      ▼
docker login
      │
      ▼
docker push
      │
      ▼
Docker Registry
      │
      ▼
Production Server
      │
      ▼
docker pull
      │
      ▼
docker run
      │
      ▼
Application Running
```

---

# 🔄 Workflow 9 – CI/CD Pipeline

```text
Developer
      │
      ▼
GitHub Push
      │
      ▼
CI/CD Pipeline
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

This workflow is commonly used with:

- GitHub Actions
- Jenkins
- GitLab CI/CD
- Azure DevOps

---

# 🏷 Workflow 10 – Image Versioning

Recommended strategy

```text
backend:v1.0.0
        │
        ▼
backend:v1.0.1
        │
        ▼
backend:v1.1.0
        │
        ▼
backend:v2.0.0
```

Avoid

```text
backend:latest
```

Benefits

- Easy rollback
- Predictable deployments
- Better release management

---

# 🌐 Workflow 11 – Public vs Private Registry

## Public Registry

```text
Developer
      │
      ▼
Docker Hub
      │
      ▼
Anyone Can Pull
```

Examples

- Docker Hub

---

## Private Registry

```text
Developer
      │
      ▼
Private Registry
      │
      ▼
Authenticated Users Only
```

Examples

- AWS ECR
- Azure ACR
- Google Artifact Registry
- Harbor

---

# 🚨 Common Problems

## Push Access Denied

```text
docker login
        │
        ▼
docker tag
        │
        ▼
docker push
```

---

## Wrong Tag

```text
backend:v1.0

↓

username/backend:v1.0
```

---

## Using latest

```text
latest

↓

Unexpected Deployment
```

Solution

```text
v1.0.0
v1.0.1
v2.0.0
```

---

# 🎯 Production Best Practices

- Use versioned tags.
- Avoid `latest` in production.
- Always tag images before pushing.
- Use private registries for production workloads.
- Keep image versions immutable.
- Push only tested images.
- Remove unused local images regularly.
- Integrate registry operations into CI/CD pipelines.

---

# 🎤 Interview Workflow

```text
Write Code
      │
      ▼
docker build
      │
      ▼
docker tag
      │
      ▼
docker login
      │
      ▼
docker push
      │
      ▼
Docker Registry
      │
      ▼
docker pull
      │
      ▼
docker run
      │
      ▼
Application Available
```

---

# 📝 Summary

The Docker Registry workflow consists of:

1. Build the Docker image.
2. Tag the image with the registry repository.
3. Authenticate with the registry.
4. Push the image to the registry.
5. Store versioned images.
6. Pull images on production servers.
7. Run containers from the downloaded images.

This workflow is the standard process used in modern DevOps and CI/CD pipelines for distributing and deploying containerized applications.