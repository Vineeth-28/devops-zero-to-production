# Docker Volumes

## What is a Docker Volume?

A Docker Volume is a Docker-managed persistent storage mechanism used to store data outside a container's writable layer.

Unlike container data, a Docker Volume survives even if the container is stopped, deleted, or recreated.

---

# Why Do We Need Docker Volumes?

By default, containers are **ephemeral**.

```
Container
     │
     ▼
Writable Layer
     │
Runtime Data
```

When the container is removed:

```
Container ❌
Writable Layer ❌
Data Lost ❌
```

Docker Volumes solve this problem by storing data separately from the container.

---

# Docker Volume Architecture

```
Application

↓

Container

↓

Container Directory
(/app/data)

↓

Docker Volume

↓

Host Storage
```

The application writes data inside the container directory.

Docker redirects that data into the attached volume.

---

# Benefits of Docker Volumes

- Persistent storage
- Data survives container deletion
- Docker manages storage automatically
- Easy backup and restore
- Can be shared across multiple containers
- Ideal for production workloads

---

# Docker Volume Lifecycle

```
docker volume create

        │

        ▼

Volume Created

        │

        ▼

Mounted Into Container

        │

        ▼

Application Writes Data

        │

        ▼

Container Deleted

        │

        ▼

Volume Still Exists ✅

        │

        ▼

Mount Volume Into New Container

        │

        ▼

Data Restored
```

---

# Docker Volume Commands

## Create Volume

```bash
docker volume create my-volume
```

---

## List Volumes

```bash
docker volume ls
```

Example

```
DRIVER    VOLUME NAME
local     my-volume
```

---

## Inspect Volume

```bash
docker volume inspect my-volume
```

Shows

- Mountpoint
- Driver
- Labels
- Scope

---

## Remove Volume

```bash
docker volume rm my-volume
```

> A volume cannot be removed while it is attached to a running container.

---

# Mounting a Docker Volume

Syntax

```bash
docker run -v VOLUME_NAME:CONTAINER_PATH IMAGE
```

Example

```bash
docker run -d \
  --name nginx-volume \
  -p 8080:80 \
  -v my-volume:/usr/share/nginx/html \
  nginx
```

Explanation

```
my-volume
      │
Docker Volume

↓

/usr/share/nginx/html

↓

Folder Inside Container
```

Docker automatically mounts the volume into the specified directory inside the container.

---

# Practical Example

## Step 1

Create Volume

```bash
docker volume create my-volume
```

---

## Step 2

Run Container

```bash
docker run -d \
  --name nginx-volume \
  -p 8080:80 \
  -v my-volume:/usr/share/nginx/html \
  nginx
```

---

## Step 3

Access Container

```bash
docker exec -it nginx-volume sh
```

---

## Step 4

Navigate

```bash
cd /usr/share/nginx/html

pwd

ls
```

---

## Step 5

Modify index.html

```bash
echo "<h1>Hello Docker Volume</h1>" > index.html
```

Verify

```bash
cat index.html
```

---

## Step 6

Exit

```bash
exit
```

Open Browser

```
http://localhost:8080
```

Expected

```
Hello Docker Volume
```

---

# Persistence Test

Delete Container

```bash
docker rm -f nginx-volume
```

Verify Volume

```bash
docker volume ls
```

Recreate Container

```bash
docker run -d \
  --name nginx-volume-new \
  -p 8080:80 \
  -v my-volume:/usr/share/nginx/html \
  nginx
```

Refresh Browser

```
http://localhost:8080
```

Result

```
Hello Docker Volume
```

The data persists because it is stored inside the Docker Volume, not inside the container.

---

# Sharing Volumes

A single Docker Volume can be mounted into multiple containers.

```
Container A

      │

      ▼

Docker Volume

      ▲

      │

Container B
```

Both containers read and write the same data.

---

# Docker Volume vs Bind Mount

## Docker Volume

Example

```bash
-v my-volume:/app/data
```

Characteristics

- Docker manages storage
- Portable
- Best for production
- Recommended for databases

---

## Bind Mount

Example (Linux)

```bash
-v /home/user/project:/app
```

Example (Windows)

```bash
-v C:\Users\User\project:/app
```

Characteristics

- Uses an existing host directory
- Host controls storage
- Best for development
- Live code synchronization

---

# When Should You Use Which?

## Docker Volume

Use for

- MySQL
- PostgreSQL
- MongoDB
- Redis
- Jenkins
- Elasticsearch
- WordPress

Reason

Persistent application data.

---

## Bind Mount

Use for

- Node.js
- React
- Vue
- Angular
- Python
- Django
- Laravel

Reason

Live source code synchronization during development.

---

# Common Interview Questions

## What is a Docker Volume?

A Docker Volume is Docker-managed persistent storage that exists independently of containers and survives container deletion.

---

## Why use Docker Volumes instead of container storage?

Because container writable layers are temporary and deleted when the container is removed.

---

## Can multiple containers share one volume?

Yes.

Multiple containers can mount and access the same Docker Volume simultaneously.

---

## Which is better for MySQL?

Docker Volume.

---

## Which is better during application development?

Bind Mount.

---

# Best Practices

- Use Docker Volumes for databases.
- Use Bind Mounts for application source code.
- Never store production database files only inside a container.
- Name volumes clearly (e.g., `mysql-data`, `postgres-data`, `jenkins-home`).
- Remove unused volumes regularly to reclaim disk space.

---

# Summary

- Containers are ephemeral.
- Writable layers are temporary.
- Docker Volumes provide persistent storage.
- Volumes survive container deletion.
- Multiple containers can share a volume.
- Docker manages volume storage automatically.
- Bind Mounts connect host directories directly to containers.
- Use Docker Volumes in production.
- Use Bind Mounts during development.