# Docker Networking

Docker Networking enables communication between containers, the Docker host, and external systems.

Networking is one of the most important Docker concepts because modern applications consist of multiple containers that need to communicate securely and efficiently.

---

# 🎯 Objective

Understand how Docker networking works internally, how containers communicate, how Docker DNS functions, and how to expose applications using port mapping in production environments.

---

# 🌐 Why Docker Networking?

Containers rarely run alone.

A production application may contain:

- Frontend
- Backend
- Database
- Redis
- Reverse Proxy

All these services need to communicate.

Example:

```text
Frontend
    │
    ▼
Backend
    │
    ▼
MySQL
```

Docker Networking makes this communication possible.

---

# 🏗 Docker Network Drivers

Docker provides multiple network drivers.

## 1. Bridge Network (Default)

- Default Docker network
- Containers communicate with each other
- Network isolation from the host
- Most commonly used

---

## 2. Host Network

Container shares the host's network.

Advantages:

- Better performance
- No NAT

Disadvantages:

- No isolation
- Port conflicts

---

## 3. None Network

Container has no networking.

Useful for:

- Highly secure workloads
- Offline processing
- Testing

---

# 🌉 Bridge Network

Docker automatically creates a bridge network during installation.

Example:

```text
Bridge Network

├── nginx
├── mysql
├── redis
```

Containers connected to the same bridge network can communicate.

---

# 🔧 Custom Bridge Network

Create your own network.

```bash
docker network create my-network
```

Advantages:

- Better isolation
- Docker DNS
- Easier service discovery
- Recommended for production

---

# 📡 Docker DNS

Docker automatically resolves container names.

Instead of:

```env
DB_HOST=172.20.0.2
```

Use:

```env
DB_HOST=mysql
```

Docker converts:

```text
mysql

↓

172.20.0.2
```

automatically.

---

# 🔄 Container Communication

Containers on the same custom network communicate using container names.

Example:

```text
Ubuntu

↓

ping nginx1

↓

Docker DNS

↓

172.20.0.2
```

No IP address is required.

---

# 🚫 Different Networks

Containers on different networks cannot communicate.

Example:

```text
frontend-network

├── frontend
└── backend


database-network

├── mysql
└── redis
```

Docker DNS only resolves names inside the same network.

---

# 🔗 Multiple Networks

A container can belong to multiple networks.

Example:

```bash
docker network connect another-network nginx1
```

Architecture:

```text
my-network

ubuntu1

↓

nginx1

↓

another-network

↓

ubuntu2
```

Useful for:

- Reverse Proxy
- API Gateway
- Multi-tier Applications

---

# 🚪 Port Mapping

Containers are isolated from the host.

To access an application from the browser:

```bash
docker run -p 8080:80 nginx
```

Read as:

```text
HOST_PORT : CONTAINER_PORT
```

Example:

```text
localhost:8080

↓

Host Port 8080

↓

Container Port 80

↓

Nginx
```

---

# 🧠 Docker Network Commands

```bash
docker network ls
docker network inspect bridge
docker network create my-network
docker network connect
docker network disconnect
docker run --network
docker run -p
```

---

# 🏭 Production Workflow

```text
Developer

↓

Docker Build

↓

Docker Image

↓

Docker Network

↓

Frontend

↓

Backend

↓

Database
```

---

# 🚨 Production Scenarios

- Backend ↔ MySQL
- Backend ↔ Redis
- Nginx ↔ Backend
- Prometheus ↔ Grafana
- Jenkins ↔ Docker
- Microservices communication

---

# 💡 Best Practices

- Use custom bridge networks.
- Never hardcode container IP addresses.
- Use Docker DNS.
- Publish only required ports.
- Separate applications into different networks.
- Use multiple networks only when required.
- Inspect networks while troubleshooting.

---

# 🎤 Interview Questions

- What is Docker Networking?
- Explain Bridge Network.
- Difference between Bridge and Host Network.
- What is Docker DNS?
- Why use Custom Networks?
- How do containers communicate?
- Can a container belong to multiple networks?
- Why doesn't localhost work between containers?
- Explain Port Mapping.
- What does `docker network inspect` show?

---

# 📝 Key Learnings

- Docker provides Bridge, Host, and None networks.
- Custom Bridge Networks are recommended for production.
- Docker DNS resolves container names automatically.
- Containers on different networks are isolated.
- Containers can belong to multiple networks.
- Port mapping exposes container applications to the host.
- Always remember:

```text
HOST_PORT : CONTAINER_PORT
```

- Docker networking is the foundation of multi-container applications.

---

# 🎯 Summary

Docker Networking allows secure and efficient communication between containers and external systems.

By understanding bridge networks, Docker DNS, network isolation, multiple networks, and port mapping, you can confidently deploy and troubleshoot production-ready containerized applications.