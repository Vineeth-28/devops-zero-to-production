# Docker Fundamentals

Production-focused Docker revision with hands-on labs, interview preparation, Docker internals, container lifecycle, storage, networking, Docker Compose, and real-world troubleshooting.

This module focuses on understanding **how Docker works internally**, enabling developers to confidently build, run, debug, and deploy containerized applications in production environments.

---

# 🎯 Objective

Build a strong understanding of Docker fundamentals, containerization, Docker architecture, images, containers, storage, networking, Docker DNS, Docker Compose, and production workflows.

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

## ✅ Day 05 – Docker Compose

- What is Docker Compose?
- Why Docker Compose?
- docker-compose.yml
- Services
- Build vs Image
- Container Name
- Ports
- Environment Variables
- Volumes
- Networks
- depends_on
- `docker compose up`
- `docker compose up -d`
- `docker compose down`
- `docker compose ps`
- `docker compose logs`
- `docker compose exec`
- Multi-container Applications
- Production Workflow

---

## ✅ Day 06 – Production Docker

- Development vs Production Docker
- Image Optimization
- Multi-stage Builds
- `.dockerignore`
- Docker Layer Caching
- Lightweight Base Images (Alpine)
- Health Checks
- Restart Policies
- Resource Limits
- Production Security Best Practices
- Production Docker Workflow
- Optimized Dockerfiles
- Build Context Optimization
- Production Deployment
- Docker Performance Optimization

---

## ✅ Day 07 – Docker Registry

- What is a Docker Registry?
- Docker Hub
- Public vs Private Registries
- Image Repositories
- Image Tagging
- Image Versioning
- Semantic Versioning
- Docker Login
- Docker Logout
- Docker Build
- Docker Tag
- Docker Push
- Docker Pull
- Docker Registry Workflow
- AWS Elastic Container Registry (ECR)
- Azure Container Registry (ACR)
- Google Artifact Registry
- Harbor Registry
- Production Image Distribution
- Registry Best Practices

---

# 📂 Folder Structure

```text
03-docker/

├── README.md
│
├── commands/
│   ├── docker-basics.md
│   ├── docker-images-dockerfile.md
│   ├── docker-volumes.md
│   ├── docker-networking.md
│   ├── docker-compose.md
│   ├── production-docker.md
│   └── docker-registry.md
│
├── troubleshooting/
│   ├── docker-basics.md
│   ├── docker-build-issues.md
│   ├── docker-volumes.md
│   ├── docker-networking.md
│   ├── docker-compose.md
│   ├── production-docker.md
│   └── docker-registry.md
│
├── workflows/
│   ├── docker-workflow.md
│   ├── dockerfile-build-workflow.md
│   ├── docker-volume-workflow.md
│   ├── docker-network-workflow.md
│   ├── docker-compose-workflow.md
│   ├── production-docker-workflow.md
│   └── docker-registry-workflow.md
│
├── dockerfiles/
│   ├── 01-nginx/
│   ├── 02-node-basics/
│   ├── 03-networking/
│   ├── 04-compose/
│   └── 05-production/
│
├── pdfs/
│   ├── Day-01-Docker-Basics.pdf
│   ├── Day-02-Docker-Images-Dockerfile.pdf
│   ├── Day-03-Docker-Volumes.pdf
│   ├── Day-04-Docker-Networking.pdf
│   ├── Day-05-Docker-Compose.pdf
│   ├── Day-06-Production-Docker.pdf
│   └── Day-07-Docker-Registry.pdf
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

## Docker Compose

- `docker compose up`
- `docker compose up -d`
- `docker compose down`
- `docker compose ps`
- `docker compose logs`
- `docker compose exec`
- `docker compose restart`
- `docker compose stop`
- `docker compose start`
- `docker compose build`
- `docker compose pull`

## Production Docker

- `docker images`
- `docker history`
- `docker stats`
- `docker logs`
- `docker inspect`
- `docker system df`
- `docker system prune`
- `docker image prune`
- `docker container prune`
- `docker volume prune`

## Docker Registry

- `docker login`
- `docker logout`
- `docker build`
- `docker tag`
- `docker push`
- `docker pull`
- `docker images`
- `docker image inspect`
- `docker history`
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
- Docker Compose
- Services
- Build vs Image
- Environment Variables
- Multi-container Applications
- Compose Lifecycle
- Production Docker
- Development vs Production
- Image Optimization
- Multi-stage Builds
- Builder Stage
- Runtime Stage
- Docker Build Context
- Docker Layer Caching
- Lightweight Base Images
- Health Checks
- Restart Policies
- Resource Limits
- Production Docker Best Practices
- Docker Security
- Image Optimization Strategies
- Public Registry
- Private Registry
- Docker Repository
- Version Tags
- Semantic Versioning
- Docker Authentication
- Image Distribution
- Registry Authentication
- AWS ECR
- Azure ACR
- Google Artifact Registry

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
              │
              ▼
        Docker Compose
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

# 🏭 Docker Compose Workflow

```text
docker-compose.yml
        │
        ▼
Docker Compose
        │
        ├──────────────┐
        ▼              ▼
Backend Service   MySQL Service
        │              │
        └──────┬───────┘
               ▼
        Docker Network
               │
               ▼
        Docker Volume
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

# 🏗 Production Docker Workflow

```text
Developer
      │
      ▼
Dockerfile
      │
      ▼
Multi-stage Build
      │
      ▼
Optimized Docker Image
      │
      ▼
Docker Registry
      │
      ▼
Production Server
      │
      ▼
Running Container
```

---

# 🏗 Docker Registry Workflow

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

### Day 05 – Docker Compose

- Node.js + MySQL
- Backend + Redis
- Nginx Reverse Proxy
- Multi-container Applications
- Local Development Environment
- Docker Compose Projects
- Persistent Storage
- Production Networking

### Day 06 – Production Docker

- Production Node.js Deployment
- Multi-stage Docker Builds
- Optimizing Large Docker Images
- CI/CD Docker Pipelines
- Docker Image Security
- Docker Performance Optimization
- Production Container Deployment
- Resource Management
- High Availability Containers

### Day 07 – Docker Registry

- Store Docker Images
- Share Images Across Teams
- CI/CD Image Distribution
- Versioned Application Releases
- Production Rollbacks
- Private Enterprise Registries
- Cloud Container Registries
- Production Deployments

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
- Docker Compose defines and runs multi-container applications from a single `docker-compose.yml` file.
- `build` creates an image from a Dockerfile; `image` pulls an existing prebuilt image — a service uses one or the other.
- `depends_on` controls startup order but does not wait for a service to be fully ready.
- Compose automatically creates a shared network so services can resolve each other by service name.
- Compose automatically creates named volumes declared under the top-level `volumes:` key.
- `docker compose up -d` runs services in detached mode; `docker compose down` tears down containers, networks (and volumes with `-v`).
- Production Docker prioritizes small, secure, and predictable images over convenience.
- Multi-stage builds separate the build environment from the runtime environment, keeping only what's needed to run the app.
- The builder stage can include compilers and dev dependencies; the runtime stage copies only the final artifacts.
- Alpine and other minimal base images shrink image size and reduce the attack surface.
- Docker Layer Caching speeds up rebuilds by reusing unchanged layers — ordering instructions from least- to most-frequently-changed matters.
- `.dockerignore` also reduces the build context sent to the Docker daemon, speeding up builds.
- Health Checks let Docker (and orchestrators) know whether a container is actually ready, not just running.
- Restart Policies define how Docker responds to container failure (e.g. `on-failure`, `always`, `unless-stopped`).
- Resource Limits (CPU/memory) prevent a single container from starving the host or other containers.
- `docker system df` and `docker system prune` help audit and reclaim disk space used by images, containers, volumes, and build cache.
- A Docker Registry stores and distributes Docker images; Docker Hub is the default public registry.
- Public registries suit open-source images; private registries (Docker Hub private repos, AWS ECR, Azure ACR, Google Artifact Registry, Harbor) protect proprietary images.
- Image tags identify specific versions of an image within a repository.
- Semantic Versioning (`major.minor.patch`) gives image tags predictable, meaningful version numbers.
- `docker login` authenticates the CLI against a registry before push/pull of private images.
- `docker tag` labels a local image for a specific repository and version before pushing.
- `docker push` uploads a tagged image to a registry; `docker pull` downloads one from a registry.
- Relying on the `latest` tag in production is risky since it can silently change what gets deployed.
- Cloud-managed registries like AWS ECR integrate registry access with cloud IAM permissions.
- A production registry workflow moves an image from local build → tag → push → registry → pull on the production server → run.

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

## Day 05 – Docker Compose

- What is Docker Compose?
- Dockerfile vs Docker Compose?
- `build` vs `image`?
- What is `depends_on`?
- What happens during `docker compose up`?
- Does Compose create volumes?
- Does Compose create networks?
- Why use Docker Compose?

## Day 06 – Production Docker

- What is Production Docker?
- Development vs Production Docker?
- What is a Multi-stage Build?
- Why use Multi-stage Builds?
- What is `.dockerignore`?
- What is Docker Build Context?
- What is Docker Layer Caching?
- Why use Alpine Images?
- What is a Docker Health Check?
- Why use Restart Policies?
- Why configure Resource Limits?
- How do you optimize Docker images?
- What are Docker production best practices?

## Day 07 – Docker Registry

- What is a Docker Registry?
- What is Docker Hub?
- Difference between Public and Private Registry?
- Why do we tag Docker images?
- Why shouldn't we use `latest` in production?
- What is image versioning?
- Explain the Docker Registry workflow.
- What is AWS ECR?
- Difference between Docker Hub and AWS ECR?
- What happens during `docker push`?
- What happens during `docker pull`?

---

# 📅 Revision Progress

- ✅ Day 01 – Docker Fundamentals
- ✅ Day 02 – Docker Images & Dockerfile
- ✅ Day 03 – Docker Volumes & Bind Mounts
- ✅ Day 04 – Docker Networking
- ✅ Day 05 – Docker Compose
- ✅ Day 06 – Production Docker
- ✅ Day 07 – Docker Registry
- ⏳ Day 08 – Docker Security
- ⏳ Day 09 – Production Labs
- ⏳ Day 10 – Docker Interview Revision & Production Challenge

---

# 🎯 Goal

Learn Docker the way production engineers use it.

Instead of memorizing commands, understand Docker's architecture, image lifecycle, container lifecycle, storage, networking, Docker DNS, Docker Compose, and deployment workflows to confidently build, deploy, troubleshoot, and manage containerized applications in production.

> **Learn → Understand → Practice → Explain → Apply**