# 🚨 Production Runbook - Website Not Opening

## Problem

Customer reports:

```
Website is not opening.
```

---

# Investigation Flow

## Step 1

Is the server reachable?

```bash
ping SERVER_IP
```

---

## Step 2

Can SSH connect?

```bash
ssh -i key.pem ubuntu@SERVER_IP
```

---

## Step 3

Check Web Server

```bash
systemctl status nginx
```

---

## Step 4

Check Listening Ports

```bash
ss -tulpn
```

Verify:

- Port 80
- Port 443
- Application Port (3000)

---

## Step 5

Test Application

```bash
curl localhost:3000
```

If successful:

Application is running.

If Connection Refused:

Application is down.

---

## Step 6

Check Logs

```bash
journalctl -u nginx
```

or

```bash
tail -f app.log
```

---

# Layer-by-Layer Debugging

```
Client
    │
Network
    │
Server
    │
Nginx
    │
Application
    │
Logs
```

Never skip layers.

---

# Common Causes

- Security Group blocking Port 80
- Nginx stopped
- Application crashed
- Port not listening
- Wrong configuration

---

# Engineering Mindset

❌ Restart immediately

✅ Investigate first

---

# Key Takeaway

Always identify the failing layer before applying a fix.