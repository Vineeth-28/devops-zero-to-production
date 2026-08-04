# Docker Fundamentals

Production-focused Docker revision with hands-on labs, interview preparation, Docker internals, container lifecycle, networking, and real-world troubleshooting.

This module focuses on understanding **how Docker works internally**, enabling developers to confidently build, run, debug, and deploy containers in production environments.

---

# 🎯 Objective

Build a strong understanding of Docker fundamentals, containerization, Docker architecture, images, containers, storage, networking, Docker DNS, and production workflows.

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

## ✅ Day 02 – Docker Images & Dockerfile

- What is Docker Image?
- Image vs Container
- Dockerfile
- Docker Build Process
- Docker Image Layers
- Union File System (UnionFS)
- Docker Build Cache
- Base Images
- Docker Hub Images
- Image Tags
- `FROM`
- `WORKDIR`
- `COPY`
- `ADD`
- `RUN`
- `CMD`
- `ENTRYPOINT`
- `ENV`
- `EXPOSE`
- `.dockerignore`
- `docker build`
- `docker image inspect`
- `docker history`
- Production Dockerfiles
- Docker Image Best Practices

---

## ✅ Day 03 – Docker Volumes & Bind Mounts

- Container Writable Layer
- Why Container Data is Lost
- Persistent Storage
- Docker Volumes
- Creating Volumes
- Mounting Volumes
- Volume Lifecycle
- Sharing Volumes Between Containers
- Docker Volume vs Bind Mount
- Production Use Cases
- Development Use Cases

---

## ✅ Day 04 – Docker Networking

- Docker Networks
- Bridge Network
- Host Network
- None Network
- Custom Bridge Network
- Docker DNS
- Container Communication
- Multiple Networks
- Port Mapping
- Host Port vs Container Port
- Docker Network Commands
- Production Networking

---

# 📂 Folder Structure

```text
03-docker/

├── commands/
│   ├── docker-basics.md
│   ├── docker-images-dockerfile.md
│   ├── docker-volumes.md
│   └── docker-networking.md
│
├── troubleshooting/
│   ├── docker-basics.md
│   ├── docker-build-issues.md
│   ├── docker-volumes.md
│   └── docker-networking.md
│
├── workflows/
│   ├── docker-workflow.md
│   ├── dockerfile-build-workflow.md
│   ├── docker-volume-workflow.md
│   └── docker-network-workflow.md
│
├── pdfs/
│   ├── Day-01-Docker-Basics.pdf
│   ├── Day-02-Docker-Images-Dockerfile.pdf
│   ├── Day-03-Docker-Volumes.pdf
│   └── Day-04-Docker-Networking.pdf
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

## Docker Images & Dockerfile

- `docker build -t <name>:<tag> .`
- `docker image inspect <image>`
- `docker history <image>`
- `docker tag <image> <new-tag>`
- `docker images`
- `docker rmi <image>`
- `docker pull <image>`
- `docker push <image>`

## Docker Volumes

- `docker volume create`
- `docker volume ls`
- `docker volume inspect`
- `docker volume rm`
- `docker run -v`
- `docker rm`
- `docker exec`

## Docker Networking

- `docker network ls`
- `docker network inspect <network>`
- `docker network create <network>`
- `docker network connect <network> <container>`
- `docker network disconnect <network> <container>`
- `docker run --network <network>`
- `docker run -p <host-port>:<container-port>`

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
- Dockerfile
- Docker Build Process
- Docker Image Layers
- Union File System (UnionFS)
- Docker Build Cache
- Base Images
- Image Tags
- Container Writable Layer
- Ephemeral Storage
- Persistent Storage
- Docker Volumes
- Volume Lifecycle
- Bind Mounts
- Shared Volumes
- Volume vs Bind Mount
- Docker Networks
- Docker DNS
- Bridge Network
- Custom Bridge Network
- Host Network
- None Network
- Port Mapping
- Container Communication

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
              ┌───────┴────────┐
              ▼                ▼
         Docker Volumes   Docker Networks
                                │
                                ▼
                           Docker DNS
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

# 📦 Docker Image Build Process

```text
Dockerfile
     │
     ▼
docker build
     │
     ▼
Read Instructions (FROM, COPY, RUN, CMD ...)
     │
     ▼
Create Layer (per instruction)
     │
     ▼
Cache Layer (if unchanged)
     │
     ▼
Stack Layers (UnionFS)
     │
     ▼
Final Docker Image
```

---

# 💾 Docker Volume Persistence Flow

```text
Container Writable Layer
     │
     ▼
Container Deleted
     │
     ▼
Writable Layer Lost
     │
     ▼
Docker Volume (managed outside container lifecycle)
     │
     ▼
New Container Mounts Same Volume
     │
     ▼
Data Restored
```

---

# 🌐 Docker Networking Flow

```text
Browser

localhost:8080
      │
      ▼
Host Port 8080
      │
      ▼
Docker Network
      │
      ▼
Container Port 80
      │
      ▼
Nginx
```

```text
Container A                Container B
   │                            │
   ▼                            ▼
docker run --network app-net   docker run --network app-net
   │                            │
   └──────────► Custom Bridge Network ◄──────────┘
                        │
                        ▼
                   Docker DNS
                        │
                        ▼
       Container A resolves Container B by name
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
Docker Network
     │
     ▼
Run Container
```

---

# 🚨 Production Scenarios

## ✅ Completed

### Day 01 – Docker Fundamentals

- Run first container
- Inspect Docker images
- Inspect containers
- Understand Docker architecture
- Container lifecycle
- Docker Hub image pull
- Verify Docker installation

### Day 02 – Docker Images & Dockerfile

- Write a production Dockerfile
- Build an image from a Dockerfile
- Inspect image layers
- Debug a failed Docker build
- Reduce image size with a leaner base image
- Optimize build cache with instruction ordering
- Use `.dockerignore` to exclude unnecessary files
- Tag and version images for release

### Day 03 – Docker Volumes & Bind Mounts

- Created Docker Volume
- Mounted Volume into Nginx Container
- Modified index.html
- Verified Changes in Browser
- Deleted Container
- Recreated Container
- Verified Persistent Data
- Compared Docker Volumes with Bind Mounts

### Day 04 – Docker Networking

- Created a custom bridge network
- Connected multiple containers to the same custom network
- Resolved one container from another using Docker DNS (by container name)
- Verified containers on the default bridge network cannot resolve each other by name
- Mapped a container port to a host port and accessed the app via `localhost`
- Compared Bridge, Host, and None network drivers
- Connected and disconnected a running container from a network
- Investigated why `localhost` inside one container doesn't reach another container

---

# 💡 Key Learnings

- Docker packages applications with dependencies.
- Containers share the host OS kernel.
- Images are read-only templates.
- Containers are running instances of images.
- Docker Engine manages images and containers.
- Docker Hub stores Docker images.
- Containers are lightweight and portable.
- A Dockerfile is a set of instructions used to build an image.
- Each Dockerfile instruction creates a new image layer.
- Docker uses UnionFS to stack layers into a single filesystem view.
- Unchanged layers are reused from the build cache to speed up builds.
- Instruction order in a Dockerfile affects cache efficiency.
- `.dockerignore` prevents unnecessary files from bloating the build context.
- Smaller, purpose-built base images reduce final image size and attack surface.
- Containers are ephemeral.
- Writable layers are deleted with containers.
- Docker Volumes persist independently.
- Multiple containers can share a single volume.
- Docker Volumes are ideal for databases.
- Bind Mounts are best suited for local development.
- Containers on the default bridge network can't resolve each other by name — only custom bridge networks get Docker DNS.
- Custom Bridge Networks enable automatic service discovery between containers via container name.
- Host Network removes network isolation, binding the container directly to the host's network stack.
- None Network disables networking entirely for a container.
- Port Mapping (`-p host:container`) exposes a container's internal port to the host.
- `localhost` inside one container does not refer to another container — container-to-container communication requires the Docker network, not localhost.

---

# 🎤 Interview Questions

## Day 01 – Docker Fundamentals

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

## Day 02 – Docker Images & Dockerfile

- What is a Docker Image?
- What is a Dockerfile?
- Explain the Docker build process.
- What are image layers, and why do they matter?
- What is the Union File System (UnionFS)?
- How does Docker's build cache work?
- Difference between `COPY` and `ADD`?
- Difference between `CMD` and `ENTRYPOINT`?
- What is the purpose of `.dockerignore`?
- How do you reduce Docker image size?
- What is a base image, and how do you choose one?
- What does `docker history` show you?

## Day 03 – Docker Volumes & Bind Mounts

- Why is data lost when a container is deleted?
- What is a Docker Volume?
- How is a Volume different from a Bind Mount?
- Where are Docker Volumes stored on disk?
- How do you create and mount a Volume?
- Can multiple containers share the same Volume?
- When would you use a Bind Mount over a Volume in production?
- What is the lifecycle of a Docker Volume relative to its container?
- How do you remove an unused Volume?
- What happens to a Volume when its container is removed?

## Day 04 – Docker Networking

- What is Docker Networking?
- Bridge vs Host Network?
- What is Docker DNS?
- How do containers communicate with each other?
- Why use a Custom Bridge Network instead of the default bridge?
- Docker Volume vs Bind Mount? (recap)
- Difference between Image and Container? (recap)
- Explain Port Mapping.
- Why doesn't `localhost` work between containers?
- Explain Docker Architecture end-to-end, including networking.

---

# 📅 Revision Progress

- ✅ Day 01 – Docker Fundamentals
- ✅ Day 02 – Docker Images & Dockerfile
- ✅ Day 03 – Docker Volumes & Bind Mounts
- ✅ Day 04 – Docker Networking
- ⏳ Day 05 – Docker Compose
- ⏳ Day 06 – Multi-stage Builds
- ⏳ Day 07 – Production Docker
- ⏳ Day 08 – Docker Registry
- ⏳ Day 09 – Production Labs
- ⏳ Day 10 – Production Challenge

---

# 🎯 Goal

Learn Docker the way production engineers use it.

Instead of memorizing commands, understand Docker's architecture, image lifecycle, container lifecycle, storage, networking, Docker DNS, and deployment workflows to confidently run containerized applications in production.

> **Learn → Understand → Practice → Explain → Apply**