# Docker Compose Workflow

Production workflow for building, deploying, managing, and troubleshooting multi-container Docker applications using Docker Compose.

---

# 🎯 Objective

Understand how Docker Compose orchestrates multiple services by automatically creating images, containers, networks, volumes, and service dependencies from a single configuration file.

---

# 📄 Workflow 1 – Docker Compose Lifecycle

```text
Developer
      │
      ▼
docker-compose.yml
      │
      ▼
docker compose up
      │
      ▼
Read Configuration
      │
      ▼
Build Images
      │
      ▼
Pull Images
      │
      ▼
Create Networks
      │
      ▼
Create Volumes
      │
      ▼
Start Containers
      │
      ▼
Application Ready
```

---

# 🏗 Workflow 2 – Building Custom Images

When a service contains:

```yaml
build: .
```

Docker Compose performs:

```text
Project Folder
      │
      ▼
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

Used for:

- Node.js
- Spring Boot
- Django
- Flask
- Laravel

---

# 📦 Workflow 3 – Pulling Existing Images

When a service contains:

```yaml
image: mysql:8
```

Workflow:

```text
Docker Compose
      │
      ▼
Docker Hub
      │
      ▼
Download Image
      │
      ▼
Run Container
```

Used for:

- MySQL
- PostgreSQL
- Redis
- Nginx
- MongoDB

---

# 🌐 Workflow 4 – Automatic Network Creation

Docker Compose automatically creates networks.

```yaml
networks:
  app-network:
```

Workflow:

```text
docker compose up
      │
      ▼
Create app-network
      │
      ▼
Attach Services
      │
      ▼
Docker DNS Enabled
```

Example:

```text
app-network

├── backend
├── mysql
└── redis
```

---

# 💾 Workflow 5 – Automatic Volume Creation

```yaml
volumes:
  mysql-data:
```

Workflow:

```text
docker compose up
      │
      ▼
Create Volume
      │
      ▼
Attach to MySQL
      │
      ▼
Persistent Database
```

Example:

```text
Container Deleted

↓

Docker Volume

↓

Database Still Exists
```

---

# 🔄 Workflow 6 – Service Communication

Docker Compose uses Docker DNS automatically.

```text
Backend
     │
     ▼
DB_HOST=mysql
     │
     ▼
Docker DNS
     │
     ▼
MySQL Container
```

No container IP address required.

---

# 🔗 Workflow 7 – Service Dependencies

```yaml
depends_on:
  - mysql
```

Workflow:

```text
Start MySQL
      │
      ▼
Start Backend
```

Purpose:

- Controls startup order
- Simplifies multi-container startup

**Note:** `depends_on` does not guarantee that MySQL is fully ready to accept connections.

---

# 🌍 Workflow 8 – Port Mapping

```yaml
ports:
  - "3000:3000"
```

Workflow:

```text
Browser

localhost:3000
      │
      ▼
Host Port 3000
      │
      ▼
Docker Compose
      │
      ▼
Container Port 3000
      │
      ▼
Node.js Application
```

Rule:

```text
HOST_PORT : CONTAINER_PORT
```

---

# 🏭 Workflow 9 – Production Application

```text
                Browser
                   │
                   ▼
              Node.js Backend
                   │
                   ▼
              Docker Network
                   │
          ┌────────┴────────┐
          ▼                 ▼
       MySQL             Redis
                   │
                   ▼
             Docker Volume
```

Everything is managed from a single Compose file.

---

# 🚀 Workflow 10 – Starting the Application

Command:

```bash
docker compose up
```

Docker Compose automatically:

```text
Read docker-compose.yml
        │
        ▼
Build Images
        │
        ▼
Pull Images
        │
        ▼
Create Networks
        │
        ▼
Create Volumes
        │
        ▼
Start Services
        │
        ▼
Application Ready
```

---

# 🛑 Workflow 11 – Stopping the Application

Command:

```bash
docker compose down
```

Workflow:

```text
Stop Containers
      │
      ▼
Remove Containers
      │
      ▼
Remove Network
      │
      ▼
Volumes Remain
```

If executed with:

```bash
docker compose down -v
```

Docker Compose removes:

- Containers
- Networks
- Volumes

---

# 🔍 Workflow 12 – Troubleshooting

Application not starting?

Checklist:

```text
docker compose ps
        │
        ▼
docker compose logs
        │
        ▼
Check Dockerfile
        │
        ▼
Check Environment Variables
        │
        ▼
Check Networks
        │
        ▼
Check Volumes
```

---

# 🚨 Common Problems

## Problem

Backend cannot connect to MySQL.

Solution

- Verify `DB_HOST=mysql`
- Check both services are on the same network.
- Verify MySQL container is running.

---

## Problem

Database data disappears.

Solution

Use Docker Volumes.

```yaml
volumes:
  - mysql-data:/var/lib/mysql
```

---

## Problem

Application inaccessible from browser.

Solution

Verify port mapping.

```yaml
ports:
  - "3000:3000"
```

---

## Problem

Container starts before database.

Solution

```yaml
depends_on:
  - mysql
```

---

# 🎯 Production Best Practices

- Keep one service per container.
- Use `build:` for custom applications.
- Use `image:` for official images.
- Use Docker Volumes for databases.
- Use Docker DNS instead of IP addresses.
- Keep configuration in environment variables.
- Publish only required ports.
- Use Docker Compose for local development and testing.

---

# 🎤 Interview Workflow

```text
docker-compose.yml
        │
        ▼
Docker Compose
        │
        ├── Build Images
        ├── Pull Images
        ├── Create Networks
        ├── Create Volumes
        ├── Start Services
        └── Connect Services
                │
                ▼
        Multi-container Application
```

---

# 📝 Summary

Docker Compose automates the deployment of multi-container applications by managing:

1. Service definitions
2. Image building
3. Image pulling
4. Network creation
5. Volume creation
6. Environment variables
7. Service dependencies
8. Port mapping
9. Container lifecycle

With a single command:

```bash
docker compose up
```

Docker Compose builds and launches a complete production-style application.