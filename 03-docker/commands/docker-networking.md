# Docker Networking Commands

Production-ready Docker networking commands every DevOps Engineer should know.

---

# 📌 List Networks

```bash
docker network ls
```

Displays all Docker networks.

Example:

```
NETWORK ID     NAME              DRIVER
abc123         bridge            bridge
def456         host              host
ghi789         none              null
jkl012         my-network        bridge
```

---

# 📌 Inspect Network

```bash
docker network inspect bridge
```

Displays detailed information about a network.

Useful Information:

- Network Name
- Driver
- Subnet
- Gateway
- Connected Containers
- IP Addresses

---

# 📌 Create Custom Network

```bash
docker network create my-network
```

Creates a new custom bridge network.

Verify:

```bash
docker network ls
```

---

# 📌 Remove Network

```bash
docker network rm my-network
```

Deletes a Docker network.

---

# 📌 Connect Container to Network

```bash
docker network connect my-network nginx1
```

Connects an existing container to another network.

A container can belong to multiple networks.

---

# 📌 Disconnect Container from Network

```bash
docker network disconnect my-network nginx1
```

Removes a container from a network.

---

# 📌 Run Container on Custom Network

```bash
docker run -d \
--name nginx1 \
--network my-network \
nginx
```

Runs a container attached to a specific network.

---

# 📌 Run Ubuntu Container

```bash
docker run -it \
--name ubuntu1 \
--network my-network \
ubuntu
```

Starts an Ubuntu container on the same network.

---

# 📌 Enter Running Container

```bash
docker exec -it ubuntu1 bash
```

If bash is unavailable:

```bash
docker exec -it ubuntu1 sh
```

---

# 📌 Test Container Communication

```bash
ping nginx1
```

Docker DNS resolves the container name automatically.

Example:

```
PING nginx1 (172.20.0.2)
```

---

# 📌 Publish Container Port

```bash
docker run -d \
-p 8080:80 \
nginx
```

Maps:

```
Host Port 8080
        │
        ▼
Container Port 80
```

Open:

```
http://localhost:8080
```

---

# 📌 Multiple Port Mapping

```bash
docker run \
-p 3000:3000 \
node-app
```

Example:

```
Browser

localhost:3000

↓

Node.js Container

3000
```

---

# 📌 View Running Containers

```bash
docker ps
```

Displays running containers.

---

# 📌 View All Containers

```bash
docker ps -a
```

Displays running and stopped containers.

---

# 📌 Inspect Container

```bash
docker inspect nginx1
```

Shows:

- Networks
- IP Address
- Volumes
- Ports
- Configuration

---

# 📌 View Port Mapping

```bash
docker port nginx1
```

Example:

```
80/tcp -> 0.0.0.0:8080
```

---

# 📌 Stop Container

```bash
docker stop nginx1
```

Stops the running container.

---

# 📌 Start Container

```bash
docker start nginx1
```

Starts a stopped container.

---

# 📌 Remove Container

```bash
docker rm nginx1
```

Deletes the container.

---

# 📌 Complete Networking Lab

Create Network

```bash
docker network create my-network
```

Run Nginx

```bash
docker run -d \
--name nginx1 \
--network my-network \
nginx
```

Run Ubuntu

```bash
docker run -it \
--name ubuntu1 \
--network my-network \
ubuntu
```

Install Ping

```bash
apt update
apt install iputils-ping -y
```

Test Communication

```bash
ping nginx1
```

Create Another Network

```bash
docker network create another-network
```

Run Ubuntu on Second Network

```bash
docker run -it \
--name ubuntu2 \
--network another-network \
ubuntu
```

Connect Nginx to Both Networks

```bash
docker network connect another-network nginx1
```

Verify Communication

```bash
ping nginx1
```

---

# 🏭 Production Best Practices

- Use custom bridge networks.
- Never hardcode container IP addresses.
- Use container names for communication.
- Use Docker DNS.
- Publish only required ports.
- Separate applications into different networks.
- Attach reverse proxies to multiple networks.
- Inspect networks during troubleshooting.

---

# 🎤 Interview Questions

### What is Docker Networking?

Docker Networking enables communication between containers, the Docker host, and external systems.

---

### What is the default Docker network?

Bridge Network.

---

### Why use a Custom Bridge Network?

- Better isolation
- Docker DNS
- Easier service discovery
- Production-ready networking

---

### Can a container belong to multiple networks?

Yes.

Use:

```bash
docker network connect
```

---

### What does Docker DNS do?

Automatically resolves container names to their IP addresses.

Example:

```
mysql

↓

172.20.0.3
```

---

### Explain Port Mapping.

```
HOST_PORT : CONTAINER_PORT
```

Example:

```bash
docker run -p 8080:80 nginx
```

Browser

```
localhost:8080
```

↓

Container

```
Port 80
```

---

# 🎯 Key Takeaways

- Docker provides Bridge, Host, and None networks.
- Custom bridge networks are recommended for production.
- Docker DNS allows containers to communicate using names.
- Containers on different networks cannot communicate unless connected.
- A container can belong to multiple networks.
- Port mapping exposes container services to the host.
- Always think:

```
HOST_PORT : CONTAINER_PORT
```

- Use custom networks for multi-container applications.
- Inspect networks while troubleshooting.
- Never rely on dynamic container IP addresses.