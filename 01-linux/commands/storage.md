# 💽 Linux Storage

## What is Storage?

Storage is where Linux stores files, logs, applications and system data.

Every filesystem has a limited amount of space.

When storage becomes full, applications may fail to start, deployments may fail, and logs may stop writing.

---

# Check Disk Usage

```bash
df -h
```

Purpose:

Displays filesystem usage in a human-readable format.

---

# Check Directory Size

```bash
du -sh /var/log
```

Purpose:

Shows how much disk space a directory is using.

---

# Storage Devices

```bash
lsblk
```

Purpose:

Lists disks, partitions and mount points.

---

# Find Large Files

```bash
find /var/log -type f -size +100M
```

Purpose:

Locate files larger than 100 MB.

---

# Memory Tricks

df

↓

Disk Filesystem

Whole filesystem usage

---

du

↓

Disk Usage

Directory usage

---

lsblk

↓

Block Devices

---

find

↓

Locate files

---

# Interview Questions

- Difference between df and du?
- What does lsblk show?
- Why use find?
- Why use -h?

---

# Best Practices

Investigate before deleting files.

Clean safely.

Increase storage only when necessary.