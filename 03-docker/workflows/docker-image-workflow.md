# Docker Image Workflow

This document explains the complete lifecycle of a Docker image, from writing source code to deploying a containerized application in production.

---

# Objective

Understand how Docker Images are created, optimized, stored, versioned, and deployed using production-ready workflows.

---

# Complete Docker Image Workflow

```text
Write Application
        │
        ▼
Create Dockerfile
        │
        ▼
Build Docker Image
        │
        ▼
Test Image Locally
        │
        ▼
Tag Image
        │
        ▼
Push to Registry
        │
        ▼
Pull on Production Server
        │
        ▼
Run Container
        │
        ▼
Monitor Application
```

---

# Step 1 - Develop Application

Example project

```text
my-app/

├── Dockerfile
├── package.json
├── package-lock.json
├── app.js
└── .dockerignore
```

The application should run correctly before containerization.

---

# Step 2 - Create Dockerfile

Example

```Dockerfile
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

ENV NODE_ENV=production

EXPOSE 3000

CMD ["npm","start"]
```

Docker executes each instruction sequentially.

---

# Step 3 - Build Image

```bash
docker build -t my-app:v1 .
```

Internal workflow

```text
Read Dockerfile

↓

Load Build Context

↓

Pull Base Image

↓

Execute Instructions

↓

Create Layers

↓

Generate Image

↓

Assign Tag
```

---

# Step 4 - Verify Image

```bash
docker images
```

Verify

- Repository
- Tag
- Image ID
- Size
- Created Time

---

# Step 5 - Inspect Image

```bash
docker image inspect my-app:v1
```

Useful information

- Environment Variables
- Labels
- Working Directory
- Exposed Ports
- Entrypoint
- Metadata

---

# Step 6 - Analyze Image Layers

```bash
docker history my-app:v1
```

Example

```text
COPY . .

RUN npm ci

COPY package.json

WORKDIR /app

FROM node:22-alpine
```

Every Dockerfile instruction creates an image layer.

---

# Step 7 - Run Container

```bash
docker run -d -p 3000:3000 --name my-container my-app:v1
```

Docker internally

```text
Image

↓

Create Writable Layer

↓

Allocate Resources

↓

Execute CMD

↓

Container Running
```

---

# Step 8 - Verify Running Container

```bash
docker ps
```

Verify

- Container ID
- Image
- Status
- Ports
- Container Name

---

# Step 9 - Test Application

Verify

- Browser access
- REST APIs
- Static files
- Database connectivity
- Application logs

---

# Step 10 - Check Logs

```bash
docker logs my-container
```

Useful for

- Startup failures
- Runtime errors
- Application debugging

---

# Step 11 - Modify Application

Update application code.

Example

```text
index.html

or

app.js
```

---

# Step 12 - Rebuild Image

```bash
docker build -t my-app:v2 .
```

Docker automatically reuses cached layers whenever possible.

---

# Step 13 - Version Images

Good

```text
my-app:v1.0.0

my-app:v1.1.0

my-app:v2.0.0
```

Avoid

```text
latest
```

for production deployments.

---

# Step 14 - Push Image

```bash
docker push my-app:v2
```

Workflow

```text
Developer

↓

Docker Build

↓

Docker Image

↓

Docker Registry
```

---

# Step 15 - Production Deployment

```bash
docker pull my-app:v2

docker run -d my-app:v2
```

Deployment workflow

```text
CI/CD Pipeline

↓

Docker Build

↓

Image Scan

↓

Registry

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

# Docker Layer Workflow

```text
FROM

↓

Layer 1

↓

WORKDIR

↓

Layer 2

↓

COPY package.json

↓

Layer 3

↓

RUN npm ci

↓

Layer 4

↓

COPY Source Code

↓

Layer 5

↓

CMD
```

---

# Docker Cache Workflow

```text
Instruction Changed?

        │
 ┌──────┴──────┐
 │             │
No            Yes
 │             │
 ▼             ▼
Reuse      Rebuild Layer
Cache            │
                 ▼
         Rebuild Remaining Layers
```

---

# Optimized Dockerfile

```Dockerfile
COPY package*.json ./

RUN npm ci

COPY . .
```

Benefits

- Faster builds
- Better cache reuse
- Reduced build time

---

# Production CI/CD Workflow

```text
Developer

↓

Git Commit

↓

Git Push

↓

CI/CD Pipeline

↓

Run Tests

↓

Docker Build

↓

Security Scan

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

Health Check

↓

Application Live
```

---

# Production Best Practices

- Use official base images.
- Pin image versions.
- Keep images lightweight.
- Use `.dockerignore`.
- Minimize Docker layers.
- Install dependencies before copying application code.
- Never store secrets inside images.
- Scan images before deployment.
- Tag every release.
- Rebuild images instead of modifying running containers.

---

# Common Production Scenarios

## Scenario 1

Slow image builds.

**Solution**

Optimize Docker layer caching.

---

## Scenario 2

Large Docker images.

**Solution**

Use Alpine images and remove unnecessary files.

---

## Scenario 3

Application behaves differently across environments.

**Solution**

Deploy the same Docker image everywhere.

---

## Scenario 4

Rollback after a failed deployment.

**Solution**

Redeploy the previous tagged image.

---

# Key Takeaways

- Docker Images are built from Dockerfiles.
- Every Dockerfile instruction creates a layer.
- Docker caches layers for faster builds.
- Containers are running instances of images.
- Image tags provide reliable versioning.
- Production deployments should always use immutable, versioned images.

---

# Interview Questions

- Explain the Docker image workflow.
- What happens internally during `docker build`?
- Why does Docker use image layers?
- What is Docker build cache?
- Why should Docker images be versioned?
- How do you optimize Docker builds?
- Why should `latest` not be used in production?
- How would you deploy a Docker image using CI/CD?
- What is the purpose of `docker history`?
- What information does `docker image inspect` provide?