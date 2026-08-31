# Health Checks (Probes)

## What it is
Probes are how Kubernetes checks whether a container is alive
(**Liveness**), ready to serve traffic (**Readiness**), or still starting
up (**Startup**).

## Why we use it
Without probes, Kubernetes can only tell if a *process* is running — not
whether the *application* is actually healthy or ready. Probes let
Kubernetes make better decisions than "the process exists."

## How it works

```text
Liveness fails
   │
   ▼
Container restarted

Readiness fails
   │
   ▼
Pod removed from ready Service endpoints

Startup Probe
   │
   ▼
Allows slow applications time to start
(liveness/readiness are held off until startup succeeds)
```

- **Liveness Probe**: "is this container still working?" A failure causes
  Kubernetes to restart the container.
- **Readiness Probe**: "is this container ready to receive traffic right
  now?" A failure removes the Pod from Service endpoints — the container
  keeps running, it just stops receiving traffic until it passes again.
- **Startup Probe**: protects slow-starting applications from being killed
  by the liveness probe before they've even finished booting.

## Example — HTTP probe

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 3000
  initialDelaySeconds: 5
  periodSeconds: 10

livenessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 15
  periodSeconds: 20
  failureThreshold: 3
```

## Common mistakes

- Using the same endpoint/logic for liveness and readiness — a temporarily
  overloaded (but not broken) app can get killed by liveness instead of
  just being removed from traffic by readiness.
- No `startupProbe` on a slow-booting app — the liveness probe can kill it
  mid-startup, causing a restart loop that never actually finishes booting.

## Production considerations

- Liveness probes should check "is the process fundamentally broken,"
  not "is a downstream dependency slow" — the latter causes unnecessary
  restart storms.
- Readiness probes should check real dependencies (DB connectivity, etc.)
  since that's exactly the situation where you want traffic held back.

## Interview questions

- What's the practical difference between liveness and readiness failing?
- Why would you add a startup probe in addition to a liveness probe?
- What's a bad idea to put inside a liveness probe check?
