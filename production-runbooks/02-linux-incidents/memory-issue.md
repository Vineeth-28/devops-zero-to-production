# Incident: Memory Issue

## 1. Incident Summary
A host or container is consuming excessive memory, approaching or hitting
its limit — risking OOM kills, swapping, or degraded performance.

## 2. Symptoms
- Alert on high memory usage / low available memory
- Kubernetes pod shows `OOMKilled` in its last termination reason
- Application slows down before crashing (GC pressure, swapping)
- Host-level: increasing swap usage, sluggish overall system response

## 3. Impact
Ranges from degraded latency (GC pressure/swapping) to hard crashes
(OOM kill) causing request failures and, if repeated, CrashLoopBackOff.

## 4. Possible Causes
- Memory leak in application code (unbounded cache, unclosed connections/handles)
- Legitimate increase in working-set size (more data, more concurrent
  requests) exceeding provisioned memory
- Memory limit set too low for the workload's real needs
- A batch job or request pattern that loads unusually large payloads into memory
- Kubernetes pod without a memory limit, allowed to consume until the node itself is starved

## 5. First 5 Minutes
1. Confirm current memory usage and trend (climbing steadily = leak
   pattern; flat-but-high = under-provisioned)
2. Check whether it's isolated to one instance/pod or system-wide
3. Check recent changes — deploy, config, or a new traffic pattern
4. If Kubernetes: check for `OOMKilled` in pod status/events
5. Check for existing memory limits and how close current usage is to them

## 6. Troubleshooting Flow
```
High memory alert / OOMKilled
      |
kubectl describe pod (check last state / termination reason)
      |
OOMKilled? -----------------------------+
      |                                 |
   Yes                                  No (still running, high usage)
      |                                 |
Check memory limit vs actual need        top / ps for growth trend
      |                                 |
Steady climb over time? -> leak          Flat but high -> under-provisioned
      |                                 |
Find root cause
```

## 7. OOMKilled vs CrashLoopBackOff
**OOMKilled** is a *reason* — the kernel (or Kubernetes via cgroup limits)
killed the process because it exceeded its memory limit. It's recorded as
the pod's last termination reason.
**CrashLoopBackOff** is a *state* — Kubernetes repeatedly tries to restart
a container that keeps exiting, regardless of *why* it exited. A pod can
be CrashLoopBackOff *because of* repeated OOMKills, but CrashLoopBackOff
can also be caused by application bugs, bad config, or failing probes that
have nothing to do with memory. Always check the termination reason before
assuming memory is the cause of a crash loop.

## 8. Commands

```bash
free -h
```
**What it checks:** total, used, free, and cached memory on the host, human-readable.
**Why we run it:** quick overall memory picture including how much is
reclaimable cache vs truly in use.
**What to look for:** `available` memory near zero; heavy swap usage.

```bash
top -o %MEM
```
**What it checks:** live process view sorted by memory usage.
**Why we run it:** identifies which specific process is consuming the most memory right now.
**What to look for:** one process's RSS climbing steadily across repeated checks.

```bash
ps aux --sort=-%mem | head -20
```
**What it checks:** point-in-time snapshot of top memory consumers.
**Why we run it:** captures evidence, comparable across repeated runs to
detect a growth trend (a hallmark of a leak).

```bash
kubectl describe pod <pod>
```
**What it checks:** last termination state/reason, memory limits, and events.
**Why we run it:** the fastest way to confirm OOMKilled and see the
configured memory limit vs what was needed.
**What to look for:** `Last State: Terminated, Reason: OOMKilled`.

```bash
dmesg -T | grep -i "killed process"
journalctl -k | grep -i oom
```
**What it checks:** kernel-level OOM killer log entries on the host.
**Why we run it:** confirms a host-level (not just container-level) OOM
event and shows which process the kernel chose to kill.
**What to look for:** entries naming the process and its memory footprint at time of kill.

## 9. How to Interpret the Output
- `free -h` shows `available` near zero and swap actively used → the
  system is under real memory pressure, not just busy.
- `describe pod` shows `OOMKilled` with a memory limit far below what
  `top` showed the process using just before the kill → limit is too low
  for legitimate usage, or there's a leak pushing it there.
- Memory usage climbs steadily over hours/days with no corresponding
  traffic increase → classic leak signature.

## 10. Root Cause Examples
- An in-memory cache with no eviction policy grows unbounded over the
  service's uptime
- A new feature loads entire result sets into memory instead of streaming/paginating
- Memory limit copy-pasted from a smaller, unrelated service's manifest
- Unclosed database connections/file handles accumulating over time

## 11. Fix / Recovery
**Immediate mitigation:**
- Restart the affected pod/process to reclaim memory — ⚠️ note this is a
  temporary fix if there's an underlying leak; it will recur
- Raise the memory limit temporarily if under-provisioning (not a leak) is confirmed

**Permanent fix:**
- Fix the leak (bounded caches, proper connection/handle cleanup)
- Right-size memory requests/limits based on real usage data and load testing
- Paginate/stream large data operations instead of loading everything into memory

## 12. Verification
- Memory usage stabilizes at a sustainable, flat level under normal load
- No further OOMKilled events over a sustained observation window
- Application latency/error rate at baseline

## 13. Prevention
- Alert on memory usage trend (steadily climbing), not just a static threshold
- Set explicit memory requests/limits for every container
- Add memory-usage dashboards per service and review periodically
- Load-test memory-sensitive features before shipping

## 14. Interview Explanation
"I start by checking whether memory usage is climbing steadily (a leak
pattern) or just flat-but-high (an under-provisioning problem). In
Kubernetes, `describe pod` immediately tells me if the last kill was
OOMKilled, and I compare the memory limit against what the process
actually needed. OOMKilled is a reason, not a state — it's important not
to conflate it with CrashLoopBackOff, which can happen for many unrelated
reasons. From there, the fix is either raising limits appropriately or
finding and fixing the actual leak."
