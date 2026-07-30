# Docker Images & Dockerfile

This document covers Docker Images, Dockerfile, image layers, Union File System (UnionFS), Docker build cache, image tagging, and production-ready Dockerfile practices.

---

# What is a Docker Image?

A Docker Image is a **read-only template** that contains everything required to run an application.

It includes:

- Application source code
- Runtime
- Libraries
- Dependencies
- Environment variables
- Configuration
- Default startup command

An image is immutable, meaning it cannot be modified after it is built.

---

# Why Docker Images?

Docker Images solve several deployment problems:

- Consistent environments
- Reproducible builds
- Easy application distribution
- Fast deployments
- Simplified dependency management
- Easy rollback using image versions

---

# Docker Image Architecture

```text
Dockerfile
     │
     ▼
Docker Build
     │
     ▼
Docker Image
     │
     ▼
Container
```

---

# Image vs Container

| Docker Image | Docker Container |
|--------------|------------------|
| Read-only | Writable |
| Blueprint | Running Instance |
| Immutable | Temporary |
| Stored Locally or Registry | Running on Host |
| Can Create Multiple Containers | Created From One Image |

---

# Dockerfile

A Dockerfile is a text file containing instructions that Docker follows to build an image.

Example:

```Dockerfile
FROM nginx:latest

COPY index.html /usr/share/nginx/html/index.html
```

---

# Docker Build Process

```text
Read Dockerfile

↓

Execute FROM

↓

Create Layer

↓

Execute COPY

↓

Create Layer

↓

Generate Final Image

↓

Assign Tag
```

---

# Docker Image Layers

Every Dockerfile instruction creates a layer.

Example:

```Dockerfile
FROM node:22-alpine

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

CMD ["npm","start"]
```

Layers

```text
Application Code

──────────────

Dependencies

──────────────

Working Directory

──────────────

Node Runtime

──────────────

Alpine Linux
```

---

# Union File System (UnionFS)

Docker combines multiple read-only image layers into a unified filesystem.

```text
Application Layer

↓

Dependency Layer

↓

Runtime Layer

↓

Operating System Layer

↓

Merged Filesystem

↓

Container
```

Containers add a thin writable layer above these read-only layers.

---

# Docker Build Cache

Docker checks every instruction while building.

If nothing changes:

```text
Instruction

↓

Cache Hit

↓

Reuse Layer
```

If an instruction changes:

```text
Instruction Changed

↓

Rebuild Layer

↓

Rebuild Remaining Layers
```

---

# Base Images

Most Dockerfiles begin with:

```Dockerfile
FROM ubuntu:24.04
```

or

```Dockerfile
FROM node:22-alpine
```

The base image provides the starting filesystem and runtime.

---

# Image Tags

Images should always use explicit versions.

Example:

```text
node:22-alpine
postgres:16-alpine
nginx:1.27
```

Avoid using:

```text
latest
```

in production.

---

# Dockerfile Instructions

## FROM

Defines the base image.

```Dockerfile
FROM node:22-alpine
```

---

## WORKDIR

Sets the working directory.

```Dockerfile
WORKDIR /app
```

---

## COPY

Copies files into the image.

```Dockerfile
COPY . .
```

---

## ADD

Copies files and can also extract local archives or fetch remote URLs.

```Dockerfile
ADD archive.tar.gz /app/
```

Use `COPY` unless ADD's extra functionality is required.

---

## RUN

Executes commands while building the image.

```Dockerfile
RUN npm ci
```

---

## CMD

Specifies the default command.

```Dockerfile
CMD ["npm","start"]
```

---

## ENTRYPOINT

Defines the executable that always runs.

```Dockerfile
ENTRYPOINT ["node"]
```

---

## ENV

Defines environment variables.

```Dockerfile
ENV NODE_ENV=production
```

---

## EXPOSE

Documents the application's listening port.

```Dockerfile
EXPOSE 3000
```

---

# .dockerignore

Exclude unnecessary files.

Example

```text
node_modules
.git
.env
coverage
dist
```

---

# Docker Build Context

Everything inside the build directory is sent to Docker.

Example

```bash
docker build -t my-app .
```

`.` represents the build context.

A properly configured `.dockerignore` reduces build time and image size.

---

# Docker Commands

Build Image

```bash
docker build -t my-nginx:v1 .
```

List Images

```bash
docker images
```

Inspect Image

```bash
docker image inspect my-nginx:v1
```

View Image History

```bash
docker history my-nginx:v1
```

Remove Image

```bash
docker rmi my-nginx:v1
```

Pull Image

```bash
docker pull nginx
```

---

# Image Build Workflow

```text
Developer

↓

Dockerfile

↓

docker build

↓

Docker Image

↓

docker run

↓

Container

↓

Application Running
```

---

# Production Dockerfile Example

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

---

# Production Best Practices

- Use official images.
- Use lightweight base images.
- Pin image versions.
- Use `.dockerignore`.
- Place dependency installation before copying source code.
- Keep images small.
- Remove unnecessary build artifacts.
- Never store secrets in images.
- Rebuild images for every release.

---

# Common Production Scenarios

## Scenario 1

Application rebuild is slow.

**Cause**

Docker cache is invalidated.

**Solution**

Reorder Dockerfile instructions.

---

## Scenario 2

Large image size.

**Solution**

Use Alpine images and remove unnecessary files.

---

## Scenario 3

Every build downloads dependencies again.

**Solution**

Copy dependency files before application source code.

---

## Scenario 4

Application works locally but fails in production.

**Solution**

Use the same Docker image in every environment.

---

# Key Takeaways

- Docker Images are immutable.
- Images are built from Dockerfiles.
- Every instruction creates a new layer.
- Docker caches layers for faster builds.
- Containers are created from images.
- Dockerfiles should be optimized for caching.
- Image versions should be tagged explicitly.

---

# Interview Questions

- What is a Docker Image?
- What is a Dockerfile?
- Explain Docker image layers.
- What is UnionFS?
- What is Docker build cache?
- Difference between Image and Container?
- Difference between COPY and ADD?
- Difference between CMD and ENTRYPOINT?
- Why use `.dockerignore`?
- Why should images be versioned?
- Why is instruction order important in Dockerfiles?
- What happens internally during `docker build`?