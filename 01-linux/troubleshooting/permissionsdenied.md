# 🚨 Permission Denied

## Problem

```
./deploy.sh

Permission denied
```

---

## Investigation

Check permissions

```bash
ls -l deploy.sh
```

Check owner

```bash
ls -l
```

---

## Possible Fixes

```bash
chmod +x deploy.sh
```

or

```bash
chown ubuntu:ubuntu deploy.sh
```

---

## Root Cause

- Missing execute permission
- Wrong owner
- Wrong group

Never guess.

Investigate first.