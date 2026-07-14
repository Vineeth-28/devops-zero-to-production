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
- ⏳ Memory Management
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
│   └── disk-management.md
│
├── troubleshooting/
│   ├── 502-bad-gateway.md
│   ├── high-cpu.md
│   ├── permission-denied.md
│   ├── ssh-failure.md
│   ├── website-not-opening.md
│   ├── log-analysis.md
│   ├── disk-full.md
│   └── no-space-left.md
│
├── labs/
│   ├── ec2-nginx-lab.md
│   ├── user-management-lab.md
│   ├── networking-lab.md
│   └── disk-management-lab.md
│
├── pdfs/
│   ├── Day-01-Linux-Production-Basics.pdf
│   ├── Day-02-Linux-Permissions-and-SSH.pdf
│   ├── Day-03-Linux-Networking-and-Logs.pdf
│   └── Day-04-Linux-Disk-and-Storage.pdf
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

## Upcoming

- ⏳ Memory Leak
- ⏳ High Memory Usage
- ⏳ Service Crash
- ⏳ File System Issues
- ⏳ Log Rotation

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

↓

Investigate

↓

Collect Evidence

↓

Find Root Cause

↓

Apply Fix

↓

Verify

↓

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
- ⏳ Day 05 – Performance & Memory
- ⏳ Day 06 – Linux Mock Interview
- ⏳ Day 07 – Linux Production Challenge

---

# 🎯 Goal

Think like a Linux Administrator managing production servers.

> **Investigate → Understand → Fix → Verify → Prevent**

Never

> **Guess → Restart → Hope**