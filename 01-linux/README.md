# 🐧 Linux Production Revision

Production-focused Linux revision with real-world troubleshooting, interview preparation, and hands-on labs.

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
- ⏳ Disk Management
- ⏳ Memory Management
- ⏳ Scheduling (cron)
- ⏳ Package Management

---

# 📂 Folder Structure

```
01-linux/

├── commands/
│   ├── linux-commands.md
│   ├── permissions.md
│   ├── users.md
│   └── ssh.md
│
├── troubleshooting/
│   ├── 502-bad-gateway.md
│   ├── high-cpu.md
│   ├── permission-denied.md
│   └── ssh-failure.md
│
├── labs/
│   ├── ec2-nginx-lab.md
│   └── user-management-lab.md
│
└── README.md
```

---

# 🚀 Commands Practiced

### Process Management

- `ps aux`
- `top`
- `htop`
- `kill -15`
- `kill -9`

### Services

- `systemctl status`
- `systemctl start`
- `systemctl stop`
- `systemctl restart`

### Logs

- `journalctl`
- `journalctl -u nginx`

### Networking

- `ss -tulpn`

### Permissions

- `ls -l`
- `chmod`
- `chown`

### Users

- `whoami`
- `id`
- `groups`
- `adduser`

### SSH

- `ssh -i key.pem`
- `authorized_keys`

---

# 🚨 Production Scenarios

Completed:

- ✅ 502 Bad Gateway Investigation
- ✅ High CPU Usage Debugging
- ✅ Permission Denied
- ✅ SSH Login Failure

Upcoming:

- ⏳ Disk Full
- ⏳ Memory Leak
- ⏳ Service Crash
- ⏳ Log Rotation
- ⏳ File System Issues

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

# 📅 Revision Progress

- ✅ Day 01 – Linux Production Basics
- ✅ Day 02 – Permissions, Users & SSH
- ⏳ Day 03 – Networking & Log Analysis
- ⏳ Day 04 – Disk & Memory
- ⏳ Day 05 – Linux Production Mock Interview

---

# 🎯 Goal

Think like a Linux Administrator managing production servers.

**Investigate → Understand → Fix**

Not

**Guess → Restart → Hope**