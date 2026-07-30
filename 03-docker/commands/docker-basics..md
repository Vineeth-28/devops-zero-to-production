# Docker Basics

This document covers Docker fundamentals, architecture, core concepts, lifecycle, essential commands, and production best practices.

---

# What is Docker?

Docker is a containerization platform that packages an application together with its runtime, libraries, dependencies, and configuration into a portable unit called a **Container**.

It ensures applications run consistently across development, testing, and production environments.

---

# Why Docker?

Docker solves common software deployment problems:

- Works on my machine issue
- Dependency conflicts
- Different operating systems
- Different runtime versions
- Manual server configuration
- Slow deployments

---

# Problems Before Docker

Before Docker, applications were deployed by manually installing:

- Runtime
- Libraries
- Dependencies
- Databases
- Configuration

Every server had a different setup, causing deployment failures and inconsistent environments.

---

# What is Containerization?

Containerization is the process of packaging an application together with everything required to run it.

```text
Application
     │
     ▼
Libraries
     │
     ▼
Dependencies
     │
     ▼
Runtime
     │
     ▼
Configuration
     │
     ▼
Container
```

---

# Virtual Machines vs Containers

| Virtual Machine | Docker Container |
|-----------------|------------------|
| Guest Operating System | Shares Host Kernel |
| Heavy | Lightweight |
| Starts in Minutes | Starts in Seconds |
| Large Disk Usage | Small Disk Usage |
| High Memory Usage | Low Memory Usage |

---

# Docker Architecture

```text
Docker Client
      │
      ▼
Docker Engine
      │
      ▼
Docker Daemon
 ┌───────────────┐
 ▼               ▼
Images      Containers
      │
      ▼
 Docker Hub
```

---

# Docker Client

The Docker Client is the command-line interface used to communicate with Docker.

Examples:

```bash
docker run
docker build
docker ps
docker images
```

---

# Docker Engine

Docker Engine is the core component responsible for:

- Building images
- Running containers
- Managing storage
- Managing networking
- Managing container lifecycle

---

# Docker Daemon

The Docker Daemon (`dockerd`) runs in the background.

Responsibilities:

- Pull images
- Build images
- Create containers
- Start containers
- Stop containers
- Remove containers

---

# Docker Images

A Docker Image is a **read-only blueprint** used to create containers.

One image can create multiple containers.

```text
Ubuntu Image
      │
      ├────────────┐
      ▼            ▼
Container A   Container B
```

---

# Docker Containers

A Docker Container is a running instance of an image.

Containers are:

- Lightweight
- Isolated
- Portable
- Fast
- Reproducible

---

# Docker Hub

Docker Hub is Docker's public image registry.

Popular images include:

- ubuntu
- nginx
- redis
- mysql
- postgres
- mongo
- node
- python

---

# Docker Lifecycle

```text
Dockerfile
     │
     ▼
Build
     │
     ▼
Image
     │
     ▼
Run
     │
     ▼
Container
     │
     ▼
Stop
     │
     ▼
Start
     │
     ▼
Remove
```

---

# Installing Docker

Verify Docker installation:

```bash
docker --version
```

Check Docker information:

```bash
docker info
```

---

# First Container

Run:

```bash
docker run hello-world
```

Internally Docker performs:

```text
Search Image

↓

Pull Image

↓

Create Container

↓

Run Container

↓

Execute Program

↓

Display Output

↓

Exit
```

---

# Essential Commands

## Docker Version

```bash
docker version
```

---

## Docker Information

```bash
docker info
```

---

## List Images

```bash
docker images
```

---

## Running Containers

```bash
docker ps
```

---

## All Containers

```bash
docker ps -a
```

---

## Run Container

```bash
docker run IMAGE_NAME
```

Example

```bash
docker run hello-world
```

---

## Stop Container

```bash
docker stop CONTAINER_ID
```

---

## Start Container

```bash
docker start CONTAINER_ID
```

---

## Restart Container

```bash
docker restart CONTAINER_ID
```

---

## Remove Container

```bash
docker rm CONTAINER_ID
```

---

## Remove Image

```bash
docker rmi IMAGE_NAME
```

---

# Production Workflow

```text
Developer

↓

Write Code

↓

Docker Build

↓

Docker Image

↓

Docker Registry

↓

Production Server

↓

Run Container

↓

Application Live
```

---

# Production Use Cases

- Standardized development environments
- CI/CD deployments
- Microservices
- Cloud-native applications
- Application isolation
- Easy rollbacks
- Horizontal scaling

---

# Best Practices

- Use official images.
- Pin image versions instead of using `latest`.
- Keep images small.
- Remove unused images.
- Remove unused containers.
- Scan images for vulnerabilities.
- Run a single primary process per container.
- Do not store secrets inside images.

---

# Key Takeaways

- Docker packages applications with dependencies.
- Containers share the host operating system kernel.
- Images are read-only templates.
- Containers are running instances of images.
- One image can create multiple containers.
- Docker Hub stores Docker images.
- Docker Engine manages the complete container lifecycle.

---

# Interview Questions

- What is Docker?
- Why was Docker created?
- What problems does Docker solve?
- What is Containerization?
- Difference between Docker and Virtual Machines?
- What is Docker Engine?
- What is Docker Daemon?
- Difference between Image and Container?
- What is Docker Hub?
- Explain Docker Architecture.
- What happens internally when `docker run hello-world` is executed?
- Why are Docker containers lightweight?