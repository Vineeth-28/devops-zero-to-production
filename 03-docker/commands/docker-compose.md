# Docker Compose Commands

Production-ready Docker Compose commands every DevOps Engineer should know.

---

# Start Services

```bash
docker compose up
```

Starts all services.

---

# Start in Background

```bash
docker compose up -d
```

Runs all services in detached mode.

---

# Stop Services

```bash
docker compose down
```

Stops and removes containers.

---

# View Running Services

```bash
docker compose ps
```

Lists all running services.

---

# View Logs

```bash
docker compose logs
```

View logs from every service.

Single service:

```bash
docker compose logs backend
```

---

# Execute Command

```bash
docker compose exec backend bash
```

Enter a running service.

---

# Restart Services

```bash
docker compose restart
```

---

# Stop Services

```bash
docker compose stop
```

---

# Start Stopped Services

```bash
docker compose start
```

---

# Build Images

```bash
docker compose build
```

---

# Pull Images

```bash
docker compose pull
```

---

# Remove Everything

```bash
docker compose down -v
```

Removes containers and volumes.

---

# Key Takeaways

- One command starts the entire application.
- Networks are created automatically.
- Volumes are created automatically.
- Services communicate using Docker DNS.