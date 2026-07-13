# 🚨 Production Runbook - Log Analysis

## Problem

Application is failing after deployment.

Users report:

```
500 Internal Server Error
```

or

```
Login Failed
```

---

# Objective

Find the root cause using logs.

Never restart services without checking logs first.

---

# Investigation Flow

## Step 1

Check application logs

```bash
tail -f app.log
```

Observe new errors in real time.

---

## Step 2

Search for errors

```bash
grep ERROR app.log
```

Examples

```bash
grep ERROR app.log

grep Exception app.log

grep nginx app.log

grep 500 app.log
```

---

## Step 3

System Logs

```bash
journalctl
```

Specific service

```bash
journalctl -u nginx
```

---

## Step 4

Large Log Files

```bash
less app.log
```

Navigate page by page.

Avoid:

```bash
cat huge.log
```

---

# Common Errors

- Database connection failed
- Port already in use
- Permission denied
- File not found
- Out of memory
- Configuration error

---

# Production Mindset

Don't restart immediately.

Read the logs.

Logs usually tell you WHY the application failed.

---

# Common Commands

```bash
tail app.log

tail -f app.log

cat app.log

less app.log

grep ERROR app.log

journalctl

journalctl -u nginx
```

---

# Best Practices

✅ Use tail -f during deployments

✅ Use grep to filter logs

✅ Read logs before restarting services

---

# Key Takeaway

Logs explain the root cause.

Investigate → Understand → Fix