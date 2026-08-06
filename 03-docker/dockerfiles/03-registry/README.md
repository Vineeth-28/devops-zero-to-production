# Docker Registry Examples

This folder contains practical Docker Registry examples demonstrating how Docker images are tagged, pushed, pulled, versioned, and managed in production environments.

The examples are designed to simulate real-world DevOps workflows used in CI/CD pipelines.

---

# 📂 Folder Structure

```text
06-registry/

├── README.md
├── build-image.sh
├── tag-image.sh
├── push-image.sh
├── pull-image.sh
└── versioning-examples.md
```

---

# 🎯 Learning Objectives

By completing these examples, you will understand:

- Docker Registry
- Docker Hub
- Public vs Private Registries
- Image Tagging
- Docker Login
- Docker Push
- Docker Pull
- Image Versioning
- Production Deployment Workflow

---

# 📦 Example 1 – Build an Image

```bash
docker build -t backend:v1.0 .
```

Creates a local Docker image.

---

# 🏷 Example 2 – Tag an Image

```bash
docker tag backend:v1.0 vineet/backend:v1.0
```

Associates the image with a Docker Hub repository.

---

# 🔐 Example 3 – Login

```bash
docker login
```

Authenticates Docker with Docker Hub.

---

# 🚀 Example 4 – Push Image

```bash
docker push vineet/backend:v1.0
```

Uploads the Docker image to Docker Hub.

---

# 📥 Example 5 – Pull Image

```bash
docker pull vineet/backend:v1.0
```

Downloads the Docker image from Docker Hub.

---

# ▶ Example 6 – Run Image

```bash
docker run -d -p 3000:3000 vineet/backend:v1.0
```

Runs the downloaded image.

---

# 🏷 Versioning Strategy

Recommended

```text
backend:v1.0.0
backend:v1.0.1
backend:v1.1.0
backend:v2.0.0
```

Avoid

```text
backend:latest
```

Using versioned tags provides:

- Predictable deployments
- Easy rollback
- Better release management

---

# 🏭 Production Workflow

```text
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
```

---

# 🚀 Public Registries

Examples

- Docker Hub
- GitHub Container Registry

Suitable for:

- Open-source projects
- Public Docker images
- Community images

---

# 🔒 Private Registries

Examples

- AWS Elastic Container Registry (ECR)
- Azure Container Registry (ACR)
- Google Artifact Registry
- Harbor

Suitable for:

- Enterprise applications
- Internal microservices
- Production deployments

---

# 💡 Best Practices

- Use semantic versioning.
- Avoid `latest` in production.
- Tag images before pushing.
- Push only tested images.
- Keep repository names meaningful.
- Use private registries for production applications.
- Integrate registry operations into CI/CD pipelines.
- Remove unused local images regularly.

---

# 🎤 Interview Questions

- What is a Docker Registry?
- What is Docker Hub?
- Difference between Public and Private Registries?
- Why do we tag Docker images?
- Why avoid `latest` in production?
- Explain the Docker image lifecycle.
- What is AWS ECR?
- What happens during `docker push`?
- What happens during `docker pull`?

---

# 📝 Summary

This folder demonstrates the complete Docker Registry lifecycle:

1. Build a Docker image.
2. Tag the image.
3. Authenticate with a registry.
4. Push the image.
5. Store versioned releases.
6. Pull the image.
7. Run the application.

These workflows represent the standard approach used in modern DevOps and CI/CD pipelines for distributing and deploying containerized applications.