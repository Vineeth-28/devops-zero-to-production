# Docker Registry Commands

Essential Docker Registry commands used for building, tagging, pushing, pulling, and managing Docker images in production.

---

# 📦 Login to Docker Registry

Login to Docker Hub.

```bash
docker login
```

Logout

```bash
docker logout
```

---

# 🔨 Build Docker Image

Build an image from the Dockerfile.

```bash
docker build -t backend:v1.0 .
```

Example

```bash
docker build -t my-app:v1.0 .
```

---

# 🏷 Tag Docker Image

Tag an image before pushing it to a registry.

```bash
docker tag backend:v1.0 username/backend:v1.0
```

Example

```bash
docker tag my-app:v1.0 vineet/my-app:v1.0
```

---

# 🚀 Push Image

Upload an image to Docker Hub.

```bash
docker push username/backend:v1.0
```

Example

```bash
docker push vineet/my-app:v1.0
```

---

# 📥 Pull Image

Download an image from a registry.

```bash
docker pull username/backend:v1.0
```

Example

```bash
docker pull vineet/my-app:v1.0
```

---

# ▶ Run Pulled Image

```bash
docker run -d -p 3000:3000 username/backend:v1.0
```

---

# 📋 List Local Images

```bash
docker images
```

---

# 🔍 Inspect Docker Image

```bash
docker image inspect IMAGE_NAME
```

Example

```bash
docker image inspect backend:v1.0
```

---

# 📜 View Image History

```bash
docker history IMAGE_NAME
```

Example

```bash
docker history backend:v1.0
```

---

# 🏷 List Image Tags

```bash
docker images
```

Shows

- Repository
- Tag
- Image ID
- Size

---

# 🗑 Remove Docker Image

```bash
docker rmi IMAGE_NAME
```

Example

```bash
docker rmi backend:v1.0
```

---

# 🔄 Retag Existing Image

```bash
docker tag backend:v1.0 backend:latest
```

---

# 📦 Pull Latest Version

```bash
docker pull nginx
```

Equivalent to

```bash
docker pull nginx:latest
```

---

# 📌 Pull Specific Version

```bash
docker pull nginx:1.27
```

---

# 🏭 AWS ECR Login

```bash
aws ecr get-login-password \
| docker login \
--username AWS \
--password-stdin <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com
```

---

# 🏭 Push to AWS ECR

Tag image

```bash
docker tag backend:v1.0 \
<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/backend:v1.0
```

Push image

```bash
docker push \
<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/backend:v1.0
```

---

# 📂 Production Workflow

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
docker pull
      │
      ▼
docker run
```

---

# 💡 Best Practices

- Use version tags instead of `latest`.
- Login before pushing images.
- Tag images with your registry namespace.
- Push only tested images.
- Keep image versions immutable.
- Use private registries for production applications.
- Regularly remove unused local images.

---

# 🎤 Interview Commands

Build

```bash
docker build -t backend:v1.0 .
```

Tag

```bash
docker tag backend:v1.0 vineet/backend:v1.0
```

Login

```bash
docker login
```

Push

```bash
docker push vineet/backend:v1.0
```

Pull

```bash
docker pull vineet/backend:v1.0
```

Run

```bash
docker run -d -p 3000:3000 vineet/backend:v1.0
```

---

# 📝 Summary

These commands cover the complete Docker Registry lifecycle:

1. Build the image
2. Tag the image
3. Login to the registry
4. Push the image
5. Pull the image
6. Run the container

This workflow is used in almost every modern CI/CD pipeline and production deployment.