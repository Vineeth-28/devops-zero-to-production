# Production Runbooks

## What this is
A collection of incident-response runbooks for production systems —
written to be opened *during* an incident, not read once and forgotten.
Each runbook follows the same structure so that under pressure you always
know where to look next.

## Why DevOps/SRE engineers need runbooks
- Incidents are stressful; stress degrades recall. A runbook externalizes
  the checklist so you don't have to remember it from scratch at 3am.
- Consistency — anyone on the team follows the same investigation path,
  producing comparable evidence and faster handoffs.
- Runbooks turn "tribal knowledge" (the one engineer who knows why the
  payments service does this) into shared, documented process.
- They shrink MTTR (mean time to recovery) by skipping the "where do I
  even start" phase.

## How to use this folder during an incident
1. Identify the symptom category (HTTP error code, Kubernetes state,
   infra failure, etc.)
2. Open the matching runbook
3. Follow **First 5 Minutes** for triage, then **Troubleshooting Flow**
   for diagnosis
4. Use **Commands** section — every command explains what it checks and
   why, so you're reasoning, not copy-pasting blindly
5. Apply **Fix / Recovery**, distinguishing immediate mitigation from a
   permanent fix
6. Confirm with **Verification**, then read **Prevention** afterward so
   the incident doesn't repeat

## Incident troubleshooting philosophy

### Symptom vs root cause
A symptom is what you observe (502s, CrashLoopBackOff, high CPU). A root
cause is *why* it's happening (a bad deploy, a downstream dependency
timing out, a memory leak). Fixing a symptom without finding the root
cause means the incident recurs — often worse, and often at a worse time.

### Check evidence before changing things
Every change you make during an incident is also a variable you've now
introduced. If you restart something before checking logs, you may have
just destroyed the only evidence of what was wrong. Read-only diagnostics
come first, always.

### Safe recovery
Prefer the smallest change that restores service, not the first thing
that comes to mind. A targeted rollback is safer than a full redeploy; a
scale-up is safer than restarting every node.

### Verification
"It looks fixed" is not verification. Confirm against the same signal
that indicated the incident in the first place (the alert, the dashboard,
a synthetic check) before declaring resolution.

### Prevention
Every incident should leave behind something durable: a new alert, a
dashboard panel, a resource limit, a CI check, better documentation — not
just a fixed instance of the problem.

## General troubleshooting flow

```
Incident
   |
Identify Symptoms
   |
Determine Impact
   |
Identify Layer
   |
Collect Evidence
   |
Investigate
   |
Find Root Cause
   |
Apply Fix
   |
Verify Recovery
   |
Monitor
   |
Document
   |
Prevent Recurrence
```

## Golden Rules

- Don't guess — confirm with evidence before acting.
- Don't randomly restart things — a restart can destroy the evidence you need.
- Don't change multiple variables simultaneously — you won't know what fixed it.
- Check recent changes first — deploys, config changes, and infra changes
  cause a disproportionate share of incidents.
- Check logs and metrics before touching anything.
- Confirm the scope of the incident — one user, one pod, one region, or everyone?
- Preserve evidence — copy logs/state before you remediate if there's any
  risk the act of fixing will erase them.
- Make the smallest safe change that restores service.
- Verify after fixing — against the original signal, not just "looks okay".
- Document the root cause — not just the fix.

## Command Cheat Sheet by Domain

### Linux
```bash
top -o %CPU              # live process view sorted by CPU
uptime                    # load average (1m/5m/15m)
free -h                   # memory usage, human-readable
df -h                     # disk space per filesystem
df -i                     # inode usage per filesystem
du -sh /path/* | sort -rh # find large directories
ps aux --sort=-%mem       # processes sorted by memory
journalctl -xe            # recent system logs with context
dmesg -T | tail -50       # kernel messages (OOM killer shows here)
ss -tulpn                 # listening ports and owning process
```

### Docker
```bash
docker ps -a                      # all containers, including exited
docker logs <container> --tail 200
docker inspect <container>
docker stats                      # live resource usage per container
docker system df                  # disk usage breakdown
docker system prune               # ⚠️ DANGEROUS — removes unused data
```

### Kubernetes
```bash
kubectl get pods -o wide
kubectl describe pod <pod>
kubectl logs <pod> [--previous] [-c <container>]
kubectl get events --sort-by=.lastTimestamp
kubectl get svc,endpoints <service>
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>
kubectl delete pod <pod>          # ⚠️ DANGEROUS if not backed by a controller
```

### Terraform
```bash
terraform init
terraform validate
terraform plan
terraform apply                   # ⚠️ DANGEROUS — changes real infra
terraform state list
terraform state show <resource>
terraform force-unlock <lock-id>  # ⚠️ DANGEROUS — only if lock is confirmed stale
```

### Ansible
```bash
ansible-inventory --list
ansible all -m ping
ansible-playbook site.yml --check   # dry run
ansible-playbook site.yml -vvv      # verbose for debugging
```

### GitHub Actions / Jenkins
```bash
# GitHub Actions: re-run with debug logging
# repo -> Actions -> failed run -> "Re-run jobs" -> enable debug logging

# Jenkins: tail the console output for the exact failing step
# Blue Ocean view or classic console output, search for the FIRST error
```

### Networking
```bash
curl -v https://<host>/            # verbose HTTP request/response
curl -o /dev/null -s -w '%{http_code}\n' <url>
dig <hostname>                     # DNS resolution
traceroute <host>                  # path/hop analysis
ss -tulpn                          # local listening sockets
nc -zv <host> <port>               # basic TCP reachability test
```

### Monitoring
```text
Prometheus UI  -> /targets, /alerts, Graph tab for ad-hoc PromQL
Grafana        -> Explore view to test a query outside a dashboard panel
Alertmanager   -> UI shows current alert routing/matches
```

---

# Production Troubleshooting Interview Framework

When an interviewer gives you an incident scenario, structure your answer
around this sequence — it demonstrates process, not just knowledge:

1. Confirm the symptom
2. Determine impact/blast radius
3. Identify affected layer
4. Check recent changes
5. Check metrics
6. Check logs
7. Reproduce/test where safe
8. Find root cause
9. Mitigate
10. Verify
11. Prevent recurrence

## 15 Production Troubleshooting Interview Questions

**1. API returns 502 — how do you investigate?**
Confirm scope (all requests or some), then walk the path client → proxy →
upstream. Check the load balancer/ingress logs first (does it show a
connection error to the backend?), then check whether the backend pods are
even Running and listening on the expected port. A 502 means the proxy
never got a valid response from upstream — the question is *why* the
upstream didn't answer.

**2. Pod is CrashLoopBackOff — how do you investigate?**
CrashLoopBackOff is a state, not a cause. Get the exit code and previous
logs (`kubectl logs --previous`), then `describe pod` for events. Common
causes: application crash on bad config/missing env var, failing
liveness probe killing it repeatedly, or an unhandled startup dependency
(DB not reachable yet).

**3. Pod is Pending — how do you investigate?**
`describe pod` and read the Events section — the scheduler explains
exactly why it can't place the pod (insufficient CPU/memory on any node,
unsatisfied node selector/affinity, taint without toleration, or an
unbound PVC).

**4. CPU suddenly reaches 100% — what's your approach?**
Don't restart immediately. Check whether the service is still responding
correctly despite high CPU — high CPU with normal latency/error rate might
be a legitimate traffic increase, not an incident. If it's causing real
impact, identify the top CPU-consuming process/pod, check for a recent
deploy, and check whether it's application-level (a hot loop, inefficient
query) or genuine load requiring scale-out.

**5. Disk reaches 100% — what's your approach?**
`df -h` to confirm which filesystem, `du -sh` to find what's consuming it
(logs are the most common cause), and check `df -i` too since inode
exhaustion presents identically to operators but needs a different fix.
Clear safely (rotate/compress logs) rather than deleting blindly —a
process holding a deleted-but-open file won't actually free space until
restarted.

**6. Deployment succeeded but users see errors — what's your approach?**
"Succeeded" often just means the rollout mechanically completed (pods
became Ready), not that the application is functionally correct. Check
readiness probe definitions (are they too shallow to catch a real issue?),
check application logs on the new pods specifically, and compare behavior
between old and new revision if a rollback is available.

**7. Kubernetes Service has no endpoints — what's your approach?**
Trace the Service → selector → pod labels chain. Endpoints populate only
from pods matching the Service's selector AND passing readiness checks. No
endpoints usually means either a label mismatch or every matching pod is
NotReady.

**8. Docker image cannot be pulled — what's your approach?**
`describe pod` shows the exact reason: wrong image name/tag, private
registry needing `imagePullSecrets`, or a network path issue reaching the
registry. Check each in that order — it's almost always a naming or auth
issue, rarely the registry itself being down.

**9. Terraform apply fails — what's your approach?**
Read the actual error first — auth/permission errors, provider errors,
and state-lock errors all look different and need different fixes. Run
`terraform plan` to see if it even gets that far; check for state lock
contention if another apply might be running concurrently; check for
drift if the real infra no longer matches the state file.

**10. Ansible host unreachable — what's your approach?**
UNREACHABLE means Ansible couldn't even establish a connection — it's a
transport problem (DNS/IP, network path, SSH, or credentials), not a task
logic problem. Test manually with plain `ssh` to the same host/user/key
before blaming Ansible.

**11. CI pipeline suddenly fails — what's your approach?**
Find the *first* meaningful failure, not the final cascading error message
— a failed test early in the pipeline can produce a confusing failure
message in a later stage. Check what changed: new dependency version, a
secret/credential expiring, or a genuinely broken commit.

**12. Database connection timeout — what's your approach?**
Don't blame the database first. Walk the path: application config
(correct host/port?) → DNS resolution → network/security-group reachability
→ database itself (is it even up, and does it have connection slots
available?) → credentials. Most "database is down" incidents are actually
network or config issues.

**13. API latency suddenly increases — what's your approach?**
Check p95/p99 latency, not average, and check whether it's uniform across
all requests or isolated to one endpoint/dependency. Correlate against a
recent deploy, a dependency's own latency (database, downstream API), and
resource saturation (CPU throttling, connection pool exhaustion).

**14. Application is healthy but traffic cannot reach it — what's your
approach?**
This points at the routing layer, not the app. Walk DNS → load balancer →
ingress/service → pod, checking each layer for whether it's actually
routing to a live, ready backend. A healthy app behind a broken Service
selector is a very common version of this.

**15. Monitoring alert fires but the application appears healthy — what's
your approach?**
Could be a flapping/noisy alert (threshold too sensitive, no `for:`
buffer), a metric that doesn't actually reflect user impact (alerting on
cause instead of symptom), or a real-but-brief issue that self-resolved
before you looked. Check the alert's underlying query against the actual
time window it fired, and check whether user-facing symptom metrics (error
rate, latency) moved at all during that window.

---

## Folder Map

| Folder | Covers |
|---|---|
| `01-http-errors/` | 502, 503, 504 |
| `02-linux-incidents/` | High CPU, memory issues, disk full |
| `03-kubernetes-incidents/` | CrashLoopBackOff, Pending, ImagePullBackOff, deployment failure, Service/Ingress issues |
| `04-cicd-incidents/` | CI pipeline failures, Docker build failures |
| `05-infrastructure-incidents/` | Terraform failures, Ansible unreachable hosts |
| `06-application-incidents/` | Database connection failures |
| `07-incident-response/` | Severity levels, incident lifecycle, RCA, postmortem template |
