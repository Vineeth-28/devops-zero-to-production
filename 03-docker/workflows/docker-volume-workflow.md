# Docker Volume Workflow

## Objective

Learn how Docker Volumes provide persistent storage by creating a volume, mounting it into a container, modifying data, deleting the container, and verifying that the data still exists.

---

# Workflow

```
Create Docker Volume
        │
        ▼
Run Container
(with Volume Mounted)
        │
        ▼
Application Writes Data
        │
        ▼
Verify Data
        │
        ▼
Delete Container
        │
        ▼
Volume Still Exists
        │
        ▼
Create New Container
(with Same Volume)
        │
        ▼
Previous Data Restored
```

---

# Step 1 — Create a Docker Volume

```bash
docker volume create my-volume
```

Verify:

```bash
docker volume ls
```

Expected:

```
my-volume
```

---

# Step 2 — Start an Nginx Container

```bash
docker run -d \
  --name nginx-volume \
  -p 8080:80 \
  -v my-volume:/usr/share/nginx/html \
  nginx
```

Workflow

```
Docker Volume

↓

my-volume

↓

Mounted Into

↓

/usr/share/nginx/html

↓

Inside nginx Container
```

---

# Step 3 — Access the Container

```bash
docker exec -it nginx-volume sh
```

Navigate to the mounted directory.

```bash
cd /usr/share/nginx/html
pwd
ls
```

Expected files

```
index.html
50x.html
```

---

# Step 4 — Modify the Website

Replace the default page.

```bash
echo "<h1>Hello Docker Volume</h1>" > index.html
```

Verify

```bash
cat index.html
```

Exit

```bash
exit
```

---

# Step 5 — Verify in Browser

Open

```
http://localhost:8080
```

Expected

```
Hello Docker Volume
```

The application is now serving content stored in the Docker Volume.

---

# Step 6 — Delete the Container

```bash
docker rm -f nginx-volume
```

What happens?

```
Container ❌

Writable Layer ❌

Docker Volume ✅
```

The container is removed, but the volume still exists.

---

# Step 7 — Verify the Volume

```bash
docker volume ls
```

Expected

```
my-volume
```

The volume persists independently of the container.

---

# Step 8 — Create a New Container

```bash
docker run -d \
  --name nginx-volume-new \
  -p 8080:80 \
  -v my-volume:/usr/share/nginx/html \
  nginx
```

Docker mounts the existing volume into the new container.

---

# Step 9 — Verify Persistence

Refresh

```
http://localhost:8080
```

Expected

```
Hello Docker Volume
```

The HTML page is still available because it was stored in the Docker Volume.

---

# Workflow Summary

```
Create Volume

↓

Run Container

↓

Mount Volume

↓

Write Data

↓

Delete Container

↓

Volume Survives

↓

Run New Container

↓

Mount Same Volume

↓

Data Restored
```

---

# Docker Volume vs Bind Mount Workflow

## Docker Volume

```
Container

↓

Docker Volume

↓

Docker Managed Storage
```

Use Cases

- MySQL
- PostgreSQL
- MongoDB
- Redis
- Jenkins
- Production Applications

---

## Bind Mount

```
Host Folder

↓

Container Directory
```

Use Cases

- Node.js
- React
- Angular
- Vue
- Python
- Django
- Local Development

---

# Best Practices

- Use Docker Volumes for persistent application data.
- Use Bind Mounts for source code during development.
- Give volumes meaningful names.
- Verify volume persistence before deleting important data.
- Clean up unused volumes regularly.

---

# Key Takeaways

- Docker Volumes store data outside containers.
- Volumes survive container deletion.
- New containers can reuse existing volumes.
- Multiple containers can share the same volume.
- Docker Volumes are ideal for production workloads.
- Bind Mounts are ideal for local development workflows.