# Docker Network Workflow

Production workflow for designing, deploying, and troubleshooting Docker networking in real-world applications.

---

# 🎯 Objective

Understand how Docker networks are created, how containers communicate, how Docker DNS works, and how applications are exposed to users through port mapping.

---

# 🏗 Workflow 1 – Default Docker Network

```text
docker run nginx
        │
        ▼
Default Bridge Network
        │
        ▼
Container receives IP Address
        │
        ▼
Container Starts
```

Used for:

- Learning Docker
- Quick testing
- Single-container applications

---

# 🌉 Workflow 2 – Custom Bridge Network

```text
Create Network
        │
        ▼
docker network create my-network
        │
        ▼
Run Containers
        │
        ▼
Attach to my-network
        │
        ▼
Docker DNS Enabled
        │
        ▼
Containers communicate using names
```

Example:

```text
my-network

├── frontend
├── backend
└── mysql
```

---

# 📡 Workflow 3 – Docker DNS

Instead of:

```text
backend

↓

172.20.0.2
```

Use:

```text
backend

↓

mysql
```

Docker automatically resolves:

```text
mysql

↓

172.20.0.2
```

Benefits:

- No hardcoded IPs
- Automatic service discovery
- Production-friendly

---

# 🔄 Workflow 4 – Container Communication

```text
Ubuntu Container
        │
        ▼
ping nginx1
        │
        ▼
Docker DNS
        │
        ▼
172.20.0.2
        │
        ▼
Nginx Container
```

Containers communicate using container names.

---

# 🚫 Workflow 5 – Network Isolation

```text
frontend-network

├── frontend
└── backend


database-network

├── mysql
└── redis
```

Result:

```text
frontend

↓

mysql

❌ Communication Blocked
```

Reason:

Containers are connected to different networks.

---

# 🔗 Workflow 6 – Multiple Networks

```text
docker network connect another-network nginx1
```

Architecture:

```text
my-network

ubuntu1
    │
    ▼
 nginx1
    ▲
    │
another-network

ubuntu2
```

Result:

- nginx1 communicates with ubuntu1
- nginx1 communicates with ubuntu2
- ubuntu1 and ubuntu2 remain isolated

Production Use Cases:

- Reverse Proxy
- API Gateway
- Service Mesh
- Monitoring

---

# 🌍 Workflow 7 – Port Mapping

Command:

```bash
docker run -d -p 8080:80 nginx
```

Workflow:

```text
Browser

localhost:8080
        │
        ▼
Host Port 8080
        │
        ▼
Docker Port Mapping
        │
        ▼
Container Port 80
        │
        ▼
Nginx Server
```

Rule:

```text
HOST_PORT : CONTAINER_PORT
```

---

# 🏭 Workflow 8 – Production Application

```text
                Internet
                    │
                    ▼
              Reverse Proxy
                    │
      ┌─────────────┴─────────────┐
      ▼                           ▼
 Frontend                    Backend
                                  │
                                  ▼
                               MySQL
```

Network Layout:

```text
frontend-network

Frontend
Reverse Proxy


backend-network

Reverse Proxy
Backend
MySQL
Redis
```

The reverse proxy belongs to both networks.

---

# 🔍 Workflow 9 – Network Troubleshooting

Problem:

Containers cannot communicate.

Checklist:

```text
docker ps
        │
        ▼
docker network ls
        │
        ▼
docker network inspect
        │
        ▼
Verify Network
        │
        ▼
Verify Container Names
        │
        ▼
Verify Docker DNS
        │
        ▼
Test with ping
```

---

# 🚨 Common Problems

## Problem

Container cannot reach another container.

Solution

- Check network
- Verify container name
- Inspect Docker DNS

---

## Problem

Browser cannot access application.

Solution

Check port mapping.

Example:

```bash
docker run -p 8080:80 nginx
```

---

## Problem

Using localhost between containers.

Wrong:

```env
DB_HOST=localhost
```

Correct:

```env
DB_HOST=mysql
```

---

## Problem

Hardcoded Container IP

Wrong:

```env
DB_HOST=172.20.0.3
```

Correct:

```env
DB_HOST=mysql
```

---

# 🎯 Production Best Practices

- Use custom bridge networks.
- Use Docker DNS instead of container IPs.
- Publish only required ports.
- Keep frontend and backend on separate networks.
- Attach reverse proxies to multiple networks.
- Inspect networks before debugging.
- Never depend on dynamic container IP addresses.

---

# 🎤 Interview Workflow

Docker Networking Process:

```text
Create Network
        │
        ▼
Run Containers
        │
        ▼
Docker DNS
        │
        ▼
Container Communication
        │
        ▼
Expose Ports
        │
        ▼
Browser Access
```

---

# 📝 Summary

A production-ready Docker networking workflow follows this sequence:

1. Create a custom bridge network.
2. Attach containers to the network.
3. Communicate using Docker DNS (container names).
4. Use multiple networks only when required.
5. Publish required ports using `HOST_PORT:CONTAINER_PORT`.
6. Verify communication using `docker network inspect` and `ping`.
7. Troubleshoot by checking networks, DNS, and port mappings.