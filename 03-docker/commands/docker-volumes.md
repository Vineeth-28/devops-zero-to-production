# Docker Volumes

## What is a Docker Volume?

A Docker Volume is Docker-managed persistent storage that exists independently of containers.

Unlike a container's writable layer, a Docker Volume is **not deleted** when the container is removed.

Docker stores and manages volumes outside the container filesystem.

---

## Why Do We Need Docker Volumes?

By default, containers are ephemeral.

```
Container
    │
    ▼
Writable Layer
    │
Stores Runtime Data
```

If the container is deleted:

```
Container ❌

Writable Layer ❌

Data Lost ❌
```

To preserve data, Docker provides Volumes.

---

## Docker Volume Architecture

```
Container
     │
     ▼
/app/data
     │
     ▼
Docker Volume
     │
     ▼
Host Storage
```

The application writes data inside the container.

Docker automatically stores that data inside the attached volume.

---

# Advantages

- Persistent storage
- Survives container deletion
- Easy backup and restore
- Can be shared between containers
- Docker manages storage location
- Recommended for production applications

---

# Docker Volume Lifecycle

```
docker volume create
        │
        ▼
Volume Created
        │
        ▼
Mount into Container
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
Mount into New Container
        │
        ▼
Data Available Again
```

---

# Creating a Volume

```bash
docker volume create my-volume
```

Example Output

```
my-volume
```

---

# Listing Volumes

```bash
docker volume ls
```

Example

```
DRIVER    VOLUME NAME
local     my-volume
```

---

# Inspecting a Volume

```bash
docker volume inspect my-volume
```

Useful for checking

- Mountpoint
- Driver
- Labels
- Scope

---

# Removing a Volume

```bash
docker volume rm my-volume
```

A volume cannot be removed while it is attached to a running container.

---

# Mounting a Volume

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
Docker Managed Storage

↓

/usr/share/nginx/html

↓

Folder inside Container
```

Docker mounts the volume into the specified directory inside the container.

---

# Practical Lab

Create Volume

```bash
docker volume create my-volume
```

Run Container

```bash
docker run -d \
--name nginx-volume \
-p 8080:80 \
-v my-volume:/usr/share/nginx/html \
nginx
```

Enter Container

```bash
docker exec -it nginx-volume sh
```

Navigate

```bash
cd /usr/share/nginx/html
pwd
ls
```

Modify Page

```bash
echo "<h1>Hello Docker Volume</h1>" > index.html
```

Exit

```bash
exit
```

Open Browser

```
http://localhost:8080
```

Expected Output

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

Create New Container

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

The modified HTML page is still available because the data is stored inside the Docker Volume.

---

# Sharing Volumes

A single Docker Volume can be mounted into multiple containers.

```
Container A
      │
      ▼
   my-volume
      ▲
      │
Container B
```

Both containers access the same persistent storage.

---

# Docker Volume vs Bind Mount

## Docker Volume

```
-v my-volume:/app/data
```

- Docker manages storage.
- Best for production.
- Ideal for databases.
- Portable across environments.

---

## Bind Mount

```
-v /home/user/project:/app
```

or

```
-v C:\Users\User\project:/app
```

- Uses an existing folder on the host machine.
- Host controls the storage location.
- Best for development.
- Source code updates appear instantly inside the container.

---

# Production Use Cases

Docker Volumes are commonly used with

- MySQL
- PostgreSQL
- MongoDB
- Redis
- Jenkins
- WordPress
- Elasticsearch

---

# Development Use Cases

Bind Mounts are commonly used for

- Node.js
- React
- Angular
- Vue
- Python
- Django
- Flask
- Laravel

They allow live code editing without rebuilding the image.

---

# Interview Questions

### What is a Docker Volume?

Docker Volume is Docker-managed persistent storage that exists independently of containers and survives container deletion.

---

### Why not store database files inside containers?

Because the container's writable layer is deleted when the container is removed.

---

### Can multiple containers share one Docker Volume?

Yes.

Multiple containers can mount and access the same Docker Volume.

---

### Docker Volume or Bind Mount for MySQL?

Docker Volume.

---

### Docker Volume or Bind Mount during development?

Bind Mount.

---

# Key Takeaways

- Containers are ephemeral.
- Writable layers are temporary.
- Docker Volumes provide persistent storage.
- Volumes survive container deletion.
- Multiple containers can share volumes.
- Docker manages volumes automatically.
- Bind Mounts connect host folders directly into containers.
- Use Docker Volumes for production data.
- Use Bind Mounts for development.