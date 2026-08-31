# Resource Management

## What it is
`requests` and `limits` define how much CPU/memory a container needs
(`requests`) and the maximum it's allowed to use (`limits`).

## Why we use it
Without resource management, one misbehaving container can starve every
other workload on the same node. Requests also drive scheduling decisions.

## How it works

- **Requests** are what the Scheduler reserves for the container when
  deciding which node it can run on — a node needs enough *unallocated*
  capacity to satisfy a Pod's total requests.
- **Limits** are the hard ceiling. Exceeding the CPU limit results in
  throttling (the process is slowed down, not killed). Exceeding the
  memory limit results in the container being **OOMKilled** (terminated).

## Example

```yaml
resources:
  requests:
    cpu: "250m"        # 0.25 vCPU
    memory: "256Mi"
  limits:
    cpu: "500m"         # 0.5 vCPU
    memory: "512Mi"
```

## OOMKilled

If a container's memory usage exceeds its `limits.memory`, the kernel's
OOM killer terminates it. Kubernetes then reports the container's last
state as `OOMKilled` — this shows up in `kubectl describe pod`.

## Common mistakes

- Setting no `requests`/`limits` at all — the container can consume
  unbounded resources and destabilize the node.
- Setting `limits.memory` too low for the app's real peak usage, causing
  frequent OOMKilled restarts.
- Confusing CPU throttling (slowed down) with memory OOMKilled (killed) —
  they behave very differently when a limit is hit.

## Production considerations

- Set requests based on real observed usage (not guesses) — over-requesting
  wastes cluster capacity, under-requesting risks node overcommit.
- Investigate OOMKilled by checking actual memory usage trends
  (`kubectl top pod`) before just raising the limit — it might be a real
  leak.

## Interview questions

- What's the difference between requests and limits?
- What happens when a container exceeds its CPU limit vs its memory limit?
- What would you check before just increasing a memory limit to fix
  OOMKilled?
