# Production Alerting: Patterns and Best Practices

## What it is
A working set of alert concepts for common failure modes, plus guidance on
avoiding noisy alerting.

## Production alert patterns

### High CPU
- Condition: sustained CPU usage above threshold (e.g. 80%) for 5+ minutes
- Why it matters: sustained high CPU can precede latency/error spikes
- Possible action: check for runaway processes, scale out, investigate recent deploys
- Avoiding noise: require `for:` duration; don't alert on brief spikes

### High memory
- Condition: available memory below threshold, or usage trending toward OOM
- Why it matters: OOM kills cause hard failures, not graceful degradation
- Possible action: check for memory leaks, restart/scale, investigate recent deploys
- Avoiding noise: alert on trend/sustained state, not single-sample spikes

### Disk almost full
- Condition: available disk space below ~10-15%
- Why it matters: full disks can crash databases, block logging, halt writes
- Possible action: clean up, expand volume, check for runaway log growth
- Avoiding noise: use a `for:` window; exclude virtual filesystems (tmpfs, overlay)

### Instance down
- Condition: `up == 0` for a target
- Why it matters: means Prometheus can't reach it at all — could be the
  process, host, or network
- Possible action: check process/pod status, host health, network path
- Avoiding noise: short `for:` (1-2m) since this is usually urgent, but
  long enough to survive a single missed scrape

### High HTTP 5xx rate
- Condition: error rate above threshold (e.g. 5%) sustained for 5+ minutes
- Why it matters: direct user-facing impact
- Possible action: check recent deploys, dependency health, rollback if needed
- Avoiding noise: use rate() over a window, not raw counts; consider a
  minimum request-volume guard so low-traffic periods don't produce noisy
  percentages

### High latency
- Condition: p95/p99 latency above SLO threshold sustained
- Why it matters: direct user experience impact even without hard errors
- Possible action: check dependency latency, resource saturation, slow queries
- Avoiding noise: alert on percentiles, not averages; use `for:` duration

### Service unavailable
- Condition: health-check endpoint failing, or `up == 0` combined with zero
  successful requests
- Why it matters: full outage, most urgent class of alert
- Possible action: page immediately, begin incident response
- Avoiding noise: usually minimal `for:` — this should page fast

### High restart rate
- Condition: container/process restart count increasing rapidly
  (crash-looping)
- Why it matters: indicates the workload can't stay up, usually a bad
  deploy or resource limit issue
- Possible action: check recent changes, resource limits, logs from
  previous container instance
- Avoiding noise: alert on restart *rate* over a window, not a single
  restart (single restarts are often benign)

## General best practices
- Alert on symptoms (error rate, latency, availability) as the primary
  page; use cause-level metrics (CPU, memory) for diagnosis, and only page
  on them directly when they reliably predict user impact
- Every alert should have a clear, actionable next step — if there's
  nothing to do, it shouldn't page
- Route by severity; reserve paging (PagerDuty/phone) for things that need
  immediate human action, use lower-urgency channels (Slack) for
  warning-level signals
- Keep annotations useful: include a runbook link and the specific
  instance/service affected

## Interview-ready answer
"Good production alerts follow a pattern: a condition tied to user or
system impact, a `for:` duration to avoid noise from brief spikes, and an
actionable next step. Symptom-level alerts (error rate, latency,
availability) are usually what pages a human; cause-level metrics (CPU,
memory, disk) are used both for their own warning-level alerts and as
diagnostic signals once a symptom-level alert has already fired."
