# 🚨 Production Runbook - Disk Full

## Problem

```
No space left on device
```

---

# Investigation

1. Check filesystem usage

2. Identify full partition

3. Locate large directories

4. Locate large files

5. Verify safe cleanup

6. Free space

7. Verify application

8. Perform Root Cause Analysis

---

# Common Causes

- Huge application logs
- Log rotation failure
- Debug logging enabled
- Old backups
- Large temporary files

---

# Production Mindset

Never delete everything.

Always understand why the disk became full.

---

# Permanent Fixes

- Configure log rotation
- Remove unnecessary files
- Enable monitoring alerts
- Increase storage only when required

---

# Key Takeaway

Temporary Fix ≠ Permanent Solution