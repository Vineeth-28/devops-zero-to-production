# Docker Basics Troubleshooting

This document covers common Docker installation issues, container errors, image problems, daemon failures, and production troubleshooting techniques.

---

# Docker Troubleshooting Workflow

```text
Problem
   │
   ▼
Read Error Message
   │
   ▼
Identify Component
(Client / Daemon / Image / Container / Network)
   │
   ▼
Inspect Logs
   │
   ▼
Fix Problem
   │
   ▼
Verify Solution
```

---

# Docker Command Not Found

## Error

```text
docker: command not found
```

## Cause

- Docker is not installed.
- Docker is not added to the system PATH.

## Solution

Verify installation:

```bash
docker --version
```

If Docker is not installed, install Docker Desktop (Windows/macOS) or Docker Engine (Linux).

---

# Cannot Connect to Docker Daemon

## Error

```text
Cannot connect to the Docker daemon
```

## Cause

- Docker Desktop is not running.
- Docker Engine service is stopped.

## Solution

Windows/macOS

Start Docker Desktop.

Linux

```bash
sudo systemctl start docker
```

Verify:

```bash
docker info
```

---

# Permission Denied (Linux)

## Error

```text
permission denied while trying to connect to Docker daemon
```

## Cause

Current user is not in the Docker group.

## Solution

```bash
sudo usermod -aG docker $USER
```

Then log out and log back in.

---

# Unable to Find Image

## Error

```text
Unable to find image locally
```

## Cause

The image does not exist on the local machine.

## Solution

Docker automatically downloads it.

Or manually pull:

```bash
docker pull IMAGE_NAME
```

Example

```bash
docker pull nginx
```

---

# Image Pull Failed

## Error

```text
pull access denied
```

## Cause

- Wrong image name.
- Private repository.
- Authentication required.

## Solution

Verify image name or login:

```bash
docker login
```

---

# Container Exits Immediately

## Cause

The application inside the container finished execution.

Example:

```bash
docker run hello-world
```

The container prints a message and exits normally.

Verify:

```bash
docker ps -a
```

---

# Port Already in Use

## Error

```text
Bind for 0.0.0.0 failed
```

## Cause

Another process is already using the port.

## Solution

Find the process:

Linux

```bash
sudo lsof -i :80
```

Windows

```powershell
netstat -ano
```

Stop the conflicting process or use another port.

---

# Container Already Exists

## Error

```text
Conflict. The container name is already in use.
```

## Solution

List containers:

```bash
docker ps -a
```

Remove the old container:

```bash
docker rm CONTAINER_NAME
```

---

# Unable to Remove Image

## Error

```text
image is being used by stopped container
```

## Cause

A container still references the image.

## Solution

Remove the container first:

```bash
docker rm CONTAINER_ID
```

Then remove the image:

```bash
docker rmi IMAGE_NAME
```

---

# Docker Desktop Not Starting

## Possible Causes

- Virtualization disabled
- WSL not installed
- Hyper-V disabled
- Low system resources

## Solution

- Enable virtualization in BIOS.
- Enable WSL2.
- Restart Docker Desktop.
- Restart the system.

---

# Useful Debug Commands

Docker Version

```bash
docker version
```

Docker Information

```bash
docker info
```

Running Containers

```bash
docker ps
```

All Containers

```bash
docker ps -a
```

Images

```bash
docker images
```

Container Logs

```bash
docker logs CONTAINER_ID
```

Inspect Container

```bash
docker inspect CONTAINER_ID
```

Inspect Image

```bash
docker image inspect IMAGE_NAME
```

---

# Production Troubleshooting Checklist

- Is Docker running?
- Is the Docker daemon healthy?
- Does the image exist?
- Is the container running?
- Are ports available?
- Are logs showing errors?
- Is the correct image version deployed?
- Are enough system resources available?

---

# Production Best Practices

- Use tagged image versions.
- Keep Docker Desktop and Docker Engine updated.
- Monitor container logs regularly.
- Remove unused images and containers.
- Verify images before deployment.
- Test containers locally before production deployment.

---

# Common Production Scenarios

## Scenario 1

Application works locally but not on another machine.

**Cause**

Missing dependencies.

**Docker Solution**

Package dependencies inside the container.

---

## Scenario 2

Deployment fails because Docker is not running.

**Solution**

Start Docker Desktop or Docker Engine.

---

## Scenario 3

Container exits immediately.

**Cause**

The main application finished execution.

Inspect:

```bash
docker logs CONTAINER_ID
```

---

## Scenario 4

Cannot delete an image.

**Solution**

Remove dependent containers first.

---

# Interview Questions

- Why can't Docker connect to the daemon?
- Why does `hello-world` exit immediately?
- What causes `pull access denied`?
- Why can't an image be removed?
- How do you inspect a running container?
- How do you troubleshoot Docker installation issues?
- What is the first command you run when Docker is not working?