# 📜 Linux Log Analysis

## What are Logs?

Logs record everything happening inside the operating system and applications.

Logs are the first place to investigate production issues.

---

# Commands

## Display Entire File

```bash
cat app.log
```

Use for:

Small log files.

---

## Read Large Files

```bash
less app.log
```

Use for:

Large log files.

Navigate page by page.

---

## Show Last Lines

```bash
tail app.log
```

Useful when you only need recent events.

---

## Watch Logs Live

```bash
tail -f app.log
```

Used during deployments and production monitoring.

---

## Search Logs

```bash
grep ERROR app.log
```

Searches for patterns.

Examples:

```bash
grep ERROR app.log

grep nginx app.log

grep 500 app.log
```

---

## System Logs

```bash
journalctl
```

Specific service

```bash
journalctl -u nginx
```

---

# Interview Questions

- Difference between cat and less?
- Why use tail -f?
- Why use grep?
- What is journalctl?

---

# Memory Tricks

cat

↓

Entire file

---

less

↓

Page by page

---

tail

↓

Last few lines

---

tail -f

↓

Live logs

---

grep

↓

Pattern search

---

# Production Scenario

Deployment completed.

Application starts throwing errors.

Command:

```bash
tail -f app.log
```

Observe logs in real time.

---

# Best Practices

- Never read huge logs with cat.
- Use grep to reduce noise.
- Monitor deployments using tail -f.

---

# Key Takeaways

Logs help identify the root cause.

Investigate before restarting services.