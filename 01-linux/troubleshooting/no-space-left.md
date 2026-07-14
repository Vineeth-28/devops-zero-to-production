# 🚨 Production Runbook - No Space Left on Device

## Error

```
No space left on device
```

Applications may fail to:

- Deploy
- Write logs
- Create temporary files
- Store uploads

---

# Investigation Flow

Filesystem

↓

Directory

↓

Files

↓

Cleanup

↓

Deploy Again

↓

Root Cause Analysis

---

# Possible Causes

- Disk full
- Large logs
- Backups consuming storage
- Temporary files
- Debug mode enabled

---

# Engineering Mindset

Restore service first.

Understand the root cause.

Prevent recurrence.