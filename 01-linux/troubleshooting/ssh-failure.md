# 🚨 SSH Failure

## Problem

```
Permission denied (publickey)
```

---

## Investigation Checklist

✅ Correct username

✅ Correct PEM file

✅ Port 22 open

✅ Security Group

✅ SSH service

✅ authorized_keys

---

## Commands

```bash
systemctl status ssh
```

```bash
chmod 400 key.pem
```

---

## Production Mindset

Never assume.

Verify every layer.