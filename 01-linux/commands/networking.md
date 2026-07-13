# 🌐 Linux Networking

## What is Linux Networking?

Linux networking allows communication between systems over a network.

As a DevOps Engineer, networking is one of the first things to investigate when an application is unreachable.

---

# Networking Flow

```
Client
   │
Internet
   │
DNS
   │
AWS Security Group
   │
EC2
   │
Nginx
   │
Application
```

Always debug layer by layer.

---

# Commands

## Check IP Address

```bash
hostname -I
```

or

```bash
ip addr
```

---

## Test Network Connectivity

```bash
ping google.com
```

Purpose:

Checks whether the target machine is reachable over the network.

---

## Test HTTP Response

```bash
curl http://localhost:3000
```

Purpose:

Checks whether the application is responding.

---

## Download Files

```bash
wget https://example.com/file.zip
```

Purpose:

Download files from the Internet.

---

## Check Listening Ports

```bash
ss -tulpn
```

Purpose:

Shows open ports and listening services.

---

# Interview Questions

- Difference between ping and curl?
- Difference between curl and wget?
- What does ss -tulpn show?
- What happens if Port 80 is blocked?

---

# Memory Tricks

ping

↓

Can I reach the machine?

---

curl

↓

Can I reach the application?

---

wget

↓

Download files

---

ss

↓

Which ports are listening?

---

# Production Scenario

Customer:

Website not opening.

Investigation order:

1. Check network connectivity
2. Check server availability
3. Check listening ports
4. Check web server
5. Check application
6. Check logs

---

# Best Practices

Never assume.

Investigate layer by layer.

---

# Key Takeaways

- ping checks connectivity.
- curl checks HTTP/application response.
- wget downloads files.
- ss shows listening ports.