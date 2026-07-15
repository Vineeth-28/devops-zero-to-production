# 🐧 Linux Production Revision

Production-focused Linux revision with real-world troubleshooting, interview preparation, hands-on labs, and production debugging scenarios.

---

# 🎯 Objective

Build the mindset of a Linux Administrator / DevOps Engineer by learning how to investigate and troubleshoot production systems instead of memorizing commands.

---

# 📚 Topics Covered

- ✅ Process Management
- ✅ Linux Services (systemd)
- ✅ Networking & Ports
- ✅ Log Analysis
- ✅ File Permissions
- ✅ Users & Groups
- ✅ SSH Authentication
- ✅ Disk Management & Storage
- ✅ Performance & Memory Monitoring
- ⏳ Scheduling (cron)
- ⏳ Package Management

---

# 📂 Folder Structure

```text
01-linux/

├── commands/
│   ├── linux-commands.md
│   ├── permissions.md
│   ├── users.md
│   ├── ssh.md
│   ├── networking.md
│   ├── logs.md
│   ├── storage.md
│   ├── disk-management.md
│   ├── performance.md
│   └── memory.md
│
├── troubleshooting/
│   ├── 502-bad-gateway.md
│   ├── high-cpu.md
│   ├── permission-denied.md
│   ├── ssh-failure.md
│   ├── website-not-opening.md
│   ├── log-analysis.md
│   ├── disk-full.md
│   ├── no-space-left.md
│   ├── high-memory.md
│   └── server-slow.md
│
├── labs/
│   ├── ec2-nginx-lab.md
│   ├── user-management-lab.md
│   ├── networking-lab.md
│   ├── disk-management-lab.md
│   └── performance-lab.md
│
├── pdfs/
│   ├── Day-01-Linux-Production-Basics.pdf
│   ├── Day-02-Linux-Permissions-and-SSH.pdf
│   ├── Day-03-Linux-Networking-and-Logs.pdf
│   ├── Day-04-Linux-Disk-and-Storage.pdf
│   └── Day-05-Linux-Performance-and-Memory.pdf
│
└── README.md
```

---

# 🚀 Commands Practiced

## Process Management

- `ps aux`
- `top`
- `htop`
- `kill -15`
- `kill -9`

## Services

- `systemctl status`
- `systemctl start`
- `systemctl stop`
- `systemctl restart`

## Logs

- `journalctl`
- `journalctl -u nginx`
- `cat`
- `less`
- `tail`
- `tail -f`
- `grep`

## Networking

- `hostname -I`
- `ip addr`
- `ping`
- `curl`
- `wget`
- `ss -tulpn`

## Storage

- `df -h`
- `du -sh`
- `lsblk`
- `mount`
- `find`

## Performance

- `top`
- `free -h`
- `uptime`
- `ps aux --sort=-%cpu`

## Permissions

- `ls -l`
- `chmod`
- `chown`

## Users

- `whoami`
- `id`
- `groups`
- `adduser`

## SSH

- `ssh -i key.pem`
- `authorized_keys`

---

# 🚨 Production Scenarios

## Completed

- ✅ 502 Bad Gateway Investigation
- ✅ High CPU Usage Debugging
- ✅ Permission Denied
- ✅ SSH Login Failure
- ✅ Website Not Opening
- ✅ Log Analysis & Live Monitoring
- ✅ Disk Full Investigation
- ✅ No Space Left on Device
- ✅ High Memory Usage
- ✅ Slow Server Investigation

## Upcoming

- ⏳ Memory Leak
- ⏳ Service Crash
- ⏳ File System Issues
- ⏳ Log Rotation
- ⏳ Linux Mock Interview

---

# 🧠 Engineering Mindset

❌ Restart first

✅ Investigate first

---

❌ Guess the issue

✅ Collect evidence

---

❌ Memorize commands

✅ Understand the system

---

# 💡 Engineering Principles

Every production issue should follow this flow:

```text
Incident
      │
      ▼
Investigate
      │
      ▼
Collect Evidence
      │
      ▼
Find Root Cause
      │
      ▼
Apply Fix
      │
      ▼
Verify
      │
      ▼
Prevent Recurrence
```

Never fix symptoms without understanding the cause.

---

# 🛠 Production Debugging Flow

```text
Customer reports issue
        │
        ▼
Network
        │
        ▼
Server
        │
        ▼
Service
        │
        ▼
CPU / Memory / Disk
        │
        ▼
Application
        │
        ▼
Logs
        │
        ▼
Root Cause
        │
        ▼
Fix
        │
        ▼
Verification
        │
        ▼
Prevention
```

---

# 📅 Revision Progress

- ✅ Day 01 – Linux Production Basics
- ✅ Day 02 – Permissions, Users & SSH
- ✅ Day 03 – Networking & Log Analysis
- ✅ Day 04 – Disk & Storage Management
- ✅ Day 05 – Performance & Memory
- ⏳ Day 06 – Linux Mock Interview
- ⏳ Day 07 – Linux Production Challenge

---

# 🏆 Skills Acquired

After completing Week 1, you should be comfortable with:

- Linux process management
- Service management with systemd
- Networking basics and troubleshooting
- SSH authentication
- Linux permissions and ownership
- User and group management
- Disk and storage troubleshooting
- Performance monitoring
- Memory investigation
- Log analysis
- Root Cause Analysis (RCA)
- Production troubleshooting mindset

---

# 🎯 Goal

Think like a Linux Administrator managing production servers.

> **Investigate → Understand → Fix → Verify → Prevent**

Never

> **Guess → Restart → Hope**