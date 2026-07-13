# 🧪 Linux Networking Lab

## Objective

Practice Linux networking commands on an EC2 instance.

---

# Lab 1 - Check Server IP

```bash
hostname -I
```

or

```bash
ip addr
```

Observe:

- Private IP
- Network Interface

---

# Lab 2 - Network Connectivity

```bash
ping google.com
```

Questions

- Is the machine reachable?
- Is the network working?

---

# Lab 3 - HTTP Test

```bash
curl localhost
```

or

```bash
curl localhost:3000
```

Questions

- Is the application responding?
- Is HTTP working?

---

# Lab 4 - Open Ports

```bash
ss -tulpn
```

Identify:

- Port 22 (SSH)
- Port 80 (HTTP)
- Port 443 (HTTPS)
- Port 3000 (Node.js)

---

# Lab 5 - Log Monitoring

Watch logs live

```bash
tail -f app.log
```

Search logs

```bash
grep ERROR app.log
```

Read logs

```bash
less app.log
```

---

# Production Exercise

Customer:

Website is not opening.

Investigate using this order:

1. Check network connectivity
2. Verify server availability
3. Check listening ports
4. Test application using curl
5. Read logs

---

# Learning Outcome

You should now understand:

- ping
- curl
- wget
- ss
- tail
- tail -f
- grep
- journalctl

Most importantly...

Think in layers while debugging.