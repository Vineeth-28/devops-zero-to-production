# Docker Compose

Docker Compose is a tool for defining and managing multi-container Docker applications using a single YAML configuration file.

Instead of running multiple `docker run` commands, Docker Compose allows you to start an entire application with a single command.

---

# 🎯 Objective

Learn how Docker Compose simplifies multi-container application deployment by automatically managing services, networks, volumes, environment variables, and container dependencies.

By the end of this chapter, you should be able to build, run, and troubleshoot production-ready applications using Docker Compose.

---

# 🤔 Why Docker Compose?

Without Docker Compose, starting an application requires multiple commands.

Example:

```bash
docker network create app-network

docker volume create mysql-data

docker build -t backend .

docker run ...

docker run ...
```

Managing applications this way becomes difficult as the number of services grows.

Docker Compose solves this problem.

```bash
docker compose up
```

One command starts the complete application.

---

# 📄 docker-compose.yml

Docker Compose uses a YAML configuration file.

Example:

```yaml
services:
  backend:
    build: .

  mysql:
    image: mysql:8
```

This file defines everything required to run the application.

---

# 🏗 Services

Every container inside Docker Compose is defined as a service.

Example:

```yaml
services:
  backend:
  mysql:
  redis:
```

Each service can have:

- Image
- Build
- Ports
- Environment Variables
- Volumes
- Networks
- Dependencies

---

# 🔨 Build

Use when building your own application.

```yaml
services:
  backend:
    build: .
```

Docker Compose will:

```text
Current Folder
      │
      ▼
Dockerfile
      │
      ▼
Build Image
      │
      ▼
Run Container
```

---

# 📦 Image

Use an existing Docker image.

```yaml
services:
  mysql:
    image: mysql:8
```

Docker Compose pulls the image from Docker Hub if it is not available locally.

---

# 📛 Container Name

```yaml
container_name: mysql
```

Assigns a custom container name.

Instead of:

```text
project-mysql-1
```

You get:

```text
mysql
```

---

# 🌐 Ports

Expose container ports to the host.

```yaml
ports:
  - "3000:3000"
```

Remember:

```text
HOST_PORT : CONTAINER_PORT
```

Example:

```text
Browser

localhost:3000

↓

Host Port 3000

↓

Container Port 3000
```

---

# ⚙ Environment Variables

Pass configuration into containers.

```yaml
environment:
  DB_HOST: mysql
  DB_PORT: 3306
```

Docker DNS resolves the service name automatically.

Instead of:

```text
172.20.0.2
```

Use:

```text
mysql
```

---

# 💾 Volumes

Provide persistent storage.

```yaml
volumes:
  - mysql-data:/var/lib/mysql
```

Benefits:

- Data survives container removal.
- Ideal for databases.
- Automatically created by Docker Compose.

---

# 🌍 Networks

Connect services together.

```yaml
networks:
  - app-network
```

Docker Compose automatically creates the network.

Services communicate using Docker DNS.

Example:

```text
backend

↓

mysql
```

No IP address required.

---

# 🔗 depends_on

Control startup order.

```yaml
depends_on:
  - mysql
```

Workflow:

```text
Start MySQL

↓

Start Backend
```

**Note:** `depends_on` controls startup order but does not guarantee that the dependent service is ready to accept connections.

---

# 🚀 docker compose up

```bash
docker compose up
```

Docker Compose performs the following automatically:

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
Start Containers
        │
        ▼
Application Ready
```

---

# 📂 Sample docker-compose.yml

```yaml
services:

  backend:
    build: .

    ports:
      - "3000:3000"

    environment:
      DB_HOST: mysql

    depends_on:
      - mysql

    networks:
      - app-network

  mysql:
    image: mysql:8

    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: appdb

    volumes:
      - mysql-data:/var/lib/mysql

    networks:
      - app-network

volumes:
  mysql-data:

networks:
  app-network:
```

---

# 🏭 Production Workflow

```text
Developer

↓

docker-compose.yml

↓

Docker Compose

↓

Build Images

↓

Create Networks

↓

Create Volumes

↓

Start Services

↓

Application Ready
```

---

# 🚨 Production Use Cases

- Node.js + MySQL
- Spring Boot + PostgreSQL
- Django + Redis
- Laravel + MySQL
- React + Backend API
- Microservices Development
- Local Development Environment

---

# 💡 Best Practices

- Keep one service per container.
- Use `build:` for your own applications.
- Use `image:` for official Docker images.
- Store database data in volumes.
- Use service names instead of container IPs.
- Keep configuration in environment variables.
- Organize related services in one Compose file.
- Commit `docker-compose.yml` to version control.

---

# 🎤 Interview Questions

- What is Docker Compose?
- Why use Docker Compose?
- Difference between Dockerfile and Docker Compose?
- Difference between `build` and `image`?
- What is a service?
- What does `depends_on` do?
- Does Docker Compose create networks automatically?
- Does Docker Compose create volumes automatically?
- What happens during `docker compose up`?
- Difference between `docker compose up` and `docker compose up -d`?

---

# 📝 Key Learnings

- Docker Compose manages multi-container applications.
- `docker-compose.yml` defines services and their configuration.
- `build:` creates images from a Dockerfile.
- `image:` uses existing Docker images.
- Docker Compose automatically creates networks and volumes when defined.
- Services communicate using Docker DNS.
- `depends_on` controls startup order.
- One command can start an entire application.

---

# 🎯 Summary

Docker Compose simplifies application deployment by allowing you to define multiple services, networks, volumes, and environment variables in a single configuration file.

It enables developers to build, run, and manage complete multi-container applications using simple commands such as:

```bash
docker compose up
docker compose down
docker compose ps
docker compose logs
```

Docker Compose is the standard tool for local development and multi-container application management before moving to orchestration platforms like Kubernetes.