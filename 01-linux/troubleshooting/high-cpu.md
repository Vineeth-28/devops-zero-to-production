# 🔥 High CPU Usage Troubleshooting

## Incident

Production Alert:

```
CPU Usage: 99%
Application Response Slow
```

---

## Goal

Find the root cause before restarting or killing processes.

---

# Debugging Steps


## 1. Check Server Load

```bash
uptime
```

Check:

- Load average
- How long server is running


---

## 2. Find High CPU Process

```bash
top
```

or

```bash
htop
```

Look for:

- PID
- CPU %
- Process name


Example:

```
PID     CPU     COMMAND

3421    98%     node
```


---

## 3. Investigate Process

```bash
ps aux | grep node
```

or

```bash
ps -p PID -f
```

Find:

- User running process
- Command
- Runtime


---

## 4. Check Network Connections

```bash
ss -tulpn
```

Check:

- Too many connections
- Traffic spike


---

## 5. Check Logs

Service logs:

```bash
journalctl -u nginx
```

Application logs:

```bash
tail -f app.log
```


---

# Never Do Immediately

❌ kill -9 PID

❌ restart server


First:

Find root cause → Fix → Restart if required


---

# Production Mindset

A DevOps Engineer investigates before taking action.