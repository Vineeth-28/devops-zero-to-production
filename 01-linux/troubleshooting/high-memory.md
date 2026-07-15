# 🚨 Production Runbook - High Memory Usage

## Problem

Customer reports:

```
Website is slow.
```

Memory usage appears high.

---

# Investigation Flow

1. Check memory usage

2. Identify memory-heavy processes

3. Determine if usage is expected

4. Review application logs

5. Restore service if required

6. Perform Root Cause Analysis

---

# Common Causes

- Memory leak
- Too many application instances
- Large cache
- Heavy background jobs

---

# Engineering Mindset

Do not restart immediately.

Understand why memory usage increased.

---

# Permanent Fixes

- Optimize application
- Increase memory if required
- Monitor memory usage
- Fix memory leaks

---

# Key Takeaway

High memory usage is not always bad.

Investigate before acting.