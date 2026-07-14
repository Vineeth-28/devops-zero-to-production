# 📀 Linux Disk Management

## Common Commands

### Filesystem Usage

```bash
df -h
```

---

### Directory Usage

```bash
du -sh *
```

---

### Block Devices

```bash
lsblk
```

---

### Mounted Filesystems

```bash
mount
```

---

### Find Large Files

```bash
find / -type f -size +500M
```

---

# Production Investigation Flow

Disk Alert

↓

Check filesystem usage

↓

Find large directories

↓

Find large files

↓

Verify files are safe

↓

Cleanup

↓

Verify free space

↓

Root Cause Analysis

---

# Best Practices

Never delete files blindly.

Always verify what is consuming storage.

Implement monitoring and log rotation.