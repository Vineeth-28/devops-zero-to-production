# Incident: High CPU

## 1. Incident Summary
CPU usage on a host or container is sustained at a high level (often
approaching 100%). This may or may not be an actual incident — the first
job is determining whether it's causing real impact.

## 2. Symptoms
- Alert fires for sustained high CPU usage
- Possibly elevated latency, or possibly no user-facing impact at all
- Load average climbing on the host

## 3. Impact
Ranges from none (legitimate traffic increase handled fine) to severe
(latency/errors as the system can't keep up, or other processes starved).
Impact must be confirmed, not assumed, from the CPU number alone.

## 4. Possible Causes
- Legitimate increase in traffic/load
- A single runaway process (infinite loop, bad recursive call)
- Inefficient application code (unoptimized hot path, missing caching)
- Garbage collection thrashing (managed-runtime languages)
- Cron job or batch process overlapping with peak traffic
- Kubernetes CPU limit set too low, causing throttling that paradoxically
  shows as pegged usage against the limit

## 5. First 5 Minutes
1. Confirm the alert is real: check current CPU, not just the alert's snapshot
2. Check whether the service is still responding correctly (latency, error
   rate) — high CPU alone is not automatically an incident
3. Check recent changes — deploy, config, scheduled job
4. Identify the top CPU-consuming process
5. Check if this is isolated to one host/pod or system-wide

## 6. Troubleshooting Flow
```
High CPU alert
      |
Is the application still responding correctly?
      |
   Yes -----------------------------+
      |                             |
Likely legitimate load               No -> real incident
Monitor, consider scaling            |
                                     Identify top CPU process (top/ps)
                                     |
                              Is it the app process itself?
                                     |
                         Yes -------------------- No
                          |                        |
                  Check recent deploy      Check for cron/batch/other process
                  Check for hot loop/bug   Check Kubernetes CPU limits/throttling
                          |                        |
                       Find root cause
```

## 7. CPU usage vs load average
**CPU usage** is the percentage of CPU time consumed right now (or over a
short window) — a direct measure of processor utilization.
**Load average** (1m/5m/15m from `uptime`) represents the average number
of processes wanting CPU (running or waiting for CPU/IO) over that window.
A load average above your core count means processes are queuing for CPU;
a load average below core count with 100% CPU usage on one core just
means one process is pegging a single core while others are idle — very
different situations with different fixes.

## 8. Commands

```bash
uptime
```
**What it checks:** load average over 1/5/15 minutes.
**Why we run it:** quick sense of whether demand for CPU is trending up,
steady, or already recovering.
**What to look for:** load average significantly higher than the number of CPU cores.

```bash
top -o %CPU
```
**What it checks:** live view of processes sorted by CPU usage.
**Why we run it:** identifies exactly which process is consuming CPU right now.
**What to look for:** one process pinned near 100% of a core (possible
runaway) vs many processes each using a moderate share (likely genuine load).

```bash
ps aux --sort=-%cpu | head -20
```
**What it checks:** a point-in-time snapshot of top CPU consumers, scriptable/loggable.
**Why we run it:** captures evidence for later analysis, unlike `top`'s live view.
**What to look for:** the same process appearing consistently across repeated snapshots.

```bash
kubectl top pod
kubectl top node
```
**What it checks:** CPU (and memory) usage per pod/node from the metrics server.
**Why we run it:** Kubernetes-native equivalent of `top`, scoped to workloads.
**What to look for:** a specific pod's usage pinned at its CPU limit
(indicates throttling, not necessarily "healthy high usage").

## 9. How to Interpret the Output
- A single process pegged at/near 100% of one core, others idle → likely a
  runaway process or infinite loop in that specific service.
- Load average high, CPU usage spread across many processes → genuine
  traffic-driven load; consider scaling rather than "fixing" a single process.
- Pod CPU usage flatlined exactly at its configured limit → throttling;
  raise the limit or optimize the code, don't assume it's healthy full utilization.

## 10. Root Cause Examples
- A recent deploy introduced an inefficient loop or missing cache, doubling CPU per request
- A batch/cron job scheduled to run during peak traffic hours
- Real traffic growth outpacing current replica count
- CPU limit set far below what the workload actually needs, causing
  constant throttling that looks like sustained high usage

## 11. Fix / Recovery
**Immediate mitigation:**
- Scale out (add replicas/instances) if the cause is legitimate load
- Kill/restart a specific runaway process if isolated and safe to do so —
  ⚠️ DANGEROUS: confirm it's actually the runaway process and not
  something else depending on it first
- Raise CPU limits temporarily if throttling is causing the symptom

**Permanent fix:**
- Fix the inefficient code path causing excess CPU per request
- Move batch/cron jobs to off-peak windows
- Right-size CPU requests/limits based on real usage data
- Add autoscaling (HPA) so legitimate load spikes are absorbed automatically

## 12. Verification
- CPU usage returns to baseline range
- Load average drops below core count
- Application latency/error rate unaffected or recovered

## 13. Prevention
- Alert on CPU usage combined with a latency/error signal, not CPU alone,
  to reduce false-positive pages
- Add HPA for services with variable load
- Profile/load-test before shipping performance-sensitive changes
- Review batch job scheduling against traffic patterns

## 14. Interview Explanation
"High CPU by itself isn't automatically an incident — the first thing I
check is whether the service is still meeting its latency/error SLOs.
If it is, I treat it as informational and consider whether scaling is
warranted. If there's real impact, I use `top`/`ps` (or `kubectl top` in
Kubernetes) to find the specific process consuming CPU, check whether it
correlates with a recent deploy or a scheduled job, and only then decide
between scaling out, fixing inefficient code, or adjusting resource
limits."
