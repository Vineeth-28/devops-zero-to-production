# 🧪 Linux Disk Management Lab

## Objective

Practice disk investigation commands on an EC2 instance.

---

# Lab 1

Check filesystem usage

```bash
df -h
```

Observe:

- Size
- Used
- Available
- Mounted On

---

# Lab 2

Check current directory usage

```bash
du -sh .
```

---

# Lab 3

List storage devices

```bash
lsblk
```

---

# Lab 4

Find large log files

```bash
find /var/log -type f -size +100M
```

---

# Production Exercise

Scenario:

Deployment failed.

```
No space left on device
```

Investigation:

1. Filesystem
2. Directory
3. Large files
4. Cleanup
5. Verify deployment
6. Root Cause Analysis

---

# Learning Outcome

Understand:

- df
- du
- lsblk
- find
- Storage troubleshooting
- Root Cause Analysis