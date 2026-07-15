# ⚡ Linux Performance Monitoring

## What is Performance Monitoring?

Performance monitoring helps identify why a Linux server becomes slow.

A DevOps Engineer monitors CPU, Memory, Processes and Load before taking action.

---

# Commands

## Monitor System Performance

```bash
top
```

Purpose:

Displays running processes in real time.

Shows:

- CPU Usage
- Memory Usage
- Running Processes
- Load Average

---

## List CPU Heavy Processes

```bash
ps aux --sort=-%cpu | head
```

Purpose:

Shows the processes consuming the most CPU.

---

## Check System Load

```bash
uptime
```

Purpose:

Displays system uptime and load average.

---

# Load Average

Load Average represents the number of processes waiting for CPU time.

Example:

Load = 1

CPU is handling one process.

Load = 5

Several processes are waiting for CPU.

Higher load usually means a slower server.

---

# Interview Questions

- What does top show?
- What is load average?
- Why use ps aux --sort=-%cpu?
- What causes high CPU usage?

---

# Memory Tricks

top

↓

Linux Task Manager

---

uptime

↓

System Load

---

ps aux --sort=-%cpu

↓

Top CPU-consuming processes

---

# Best Practices

Never kill a process immediately.

Identify:

- Which process?
- Why is it consuming CPU?
- Is it expected?

---

# Key Takeaway

High CPU is a symptom.

Always investigate the root cause before taking action.