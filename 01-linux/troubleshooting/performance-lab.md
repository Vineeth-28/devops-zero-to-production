# 🧪 Linux Performance Lab

## Objective

Practice Linux performance monitoring on an EC2 instance.

---

# Lab 1

Check real-time processes

```bash
top
```

Observe:

- CPU
- Memory
- Load Average

---

# Lab 2

Check memory usage

```bash
free -h
```

Observe:

- Total
- Used
- Free
- Available

---

# Lab 3

Find CPU-heavy processes

```bash
ps aux --sort=-%cpu | head
```

Identify:

- Process Name
- CPU %
- User

---

# Lab 4

Check system load

```bash
uptime
```

Observe:

- Uptime
- Number of users
- Load Average

---

# Production Exercise

Scenario:

Website responds very slowly.

Investigation Order:

1. CPU
2. Memory
3. Processes
4. Logs
5. Root Cause

---

# Learning Outcome

You should now understand:

- top
- free -h
- uptime
- ps aux
- CPU investigation
- Memory investigation
- Load Average