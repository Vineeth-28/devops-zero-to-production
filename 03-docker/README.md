# Docker Fundamentals

Production-focused Docker revision with hands-on labs, interview preparation, Docker internals, container lifecycle, and real-world troubleshooting.

This module focuses on understanding **how Docker works internally**, enabling developers to confidently build, run, debug, and deploy containers in production environments.

---

# 🎯 Objective

Build a strong understanding of Docker fundamentals, containerization, Docker architecture, images, containers, and production workflows.

The goal is to understand **how Docker works under the hood**, troubleshoot containerized applications confidently, and use Docker effectively in real-world production environments.

---

# 📚 Topics Covered

## ✅ Day 01 – Docker Fundamentals

- What is Docker?
- Why Docker?
- Problems Before Docker
- What is Containerization?
- Virtual Machines vs Containers
- Docker Architecture
- Docker Client
- Docker Engine
- Docker Daemon
- Docker Images
- Docker Containers
- Docker Hub
- Docker Lifecycle
- `docker run`
- `docker images`
- `docker ps`
- `docker stop`
- `docker start`
- `docker rm`
- `docker rmi`
- Production Workflow
- Best Practices

---

# 📂 Folder Structure

```text
03-docker/

├── commands/
│   └── docker-basics.md
│
├── troubleshooting/
│   └── docker-basics.md
│
├── workflows/
│   └── docker-workflow.md
│
├── pdfs/
│   └── Day-01-Docker-Basics.pdf
│
└── README.md
```

---

# 🚀 Commands Practiced

## Docker Basics

- `docker --version`
- `docker version`
- `docker info`
- `docker images`
- `docker ps`
- `docker ps -a`
- `docker run hello-world`
- `docker stop`
- `docker start`
- `docker restart`
- `docker rm`
- `docker rmi`

---

# 🧠 Core Concepts

- Containerization
- Docker Client
- Docker Engine
- Docker Daemon
- Docker Image
- Docker Container
- Docker Hub
- Docker Registry
- Container Lifecycle
- Image Lifecycle
- Virtual Machines
- Host Operating System
- Shared Kernel
- Isolation

---

# 🏗 Docker Architecture

```text
        Docker Client
              │
              ▼
        Docker Engine
              │
       Docker Daemon
       ┌──────┴──────┐
       ▼             ▼
 Docker Images   Docker Containers
              │
              ▼
         Docker Hub
```

---

# 🔄 Docker Lifecycle

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

# 🏭 Production Workflow

```text
Developer
     │
     ▼
Write Code
     │
     ▼
Docker Build
     │
     ▼
Docker Image
     │
     ▼
Docker Registry
     │
     ▼
Production Server
     │
     ▼
Run Container
```

---

# 🚨 Production Scenarios

- Run first container
- Inspect Docker images
- Inspect containers
- Understand Docker architecture
- Container lifecycle
- Docker Hub image pull
- Verify Docker installation

---

# 💡 Key Learnings

- Docker packages applications with dependencies.
- Containers share the host OS kernel.
- Images are read-only templates.
- Containers are running instances of images.
- Docker Engine manages images and containers.
- Docker Hub stores Docker images.
- Containers are lightweight and portable.

---

# 🎤 Interview Questions

- What is Docker?
- Why was Docker created?
- What is Containerization?
- Docker vs Virtual Machine?
- What is Docker Engine?
- What is Docker Daemon?
- Difference between Image and Container?
- What happens during `docker run hello-world`?
- What is Docker Hub?
- Explain Docker Architecture.

---

# 📅 Revision Progress

- ✅ Day 01 – Docker Fundamentals
- ⏳ Day 02 – Docker Images & Dockerfile
- ⏳ Day 03 – Container Lifecycle
- ⏳ Day 04 – Volumes
- ⏳ Day 05 – Networking
- ⏳ Day 06 – Docker Compose
- ⏳ Day 07 – Production Docker
- ⏳ Day 08 – Docker Registry
- ⏳ Day 09 – Production Labs
- ⏳ Day 10 – Production Challenge

---

# 🎯 Goal

Learn Docker the way production engineers use it.

Instead of memorizing commands, understand Docker's architecture, image lifecycle, container lifecycle, storage, networking, and deployment workflows to confidently run containerized applications in production.

> **Learn → Understand → Practice → Explain → Apply**