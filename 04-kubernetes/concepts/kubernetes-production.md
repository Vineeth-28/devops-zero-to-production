# Kubernetes in Production

## What it is
The practices and considerations that separate "it runs on Kubernetes" from
"it runs *reliably* on Kubernetes in production."

## Why we use it
A cluster that works in a demo can still fail badly in production without
resource limits, health checks, rollout strategy, and observability in
place.

## How it works — key production practices

- **Always set requests/limits** — prevents one workload from starving
  others and drives correct scheduling decisions.
- **Always configure liveness + readiness probes** — self-healing and
  zero-downtime traffic shifting both depend on them.
- **Use Deployments, not standalone Pods** — for self-healing and rolling
  updates.
- **Namespace + RBAC + ResourceQuota** — isolate teams/environments and
  prevent runaway resource usage.
- **Secrets via encryption at rest / external secrets manager** — base64
  alone is not security.
- **PodDisruptionBudgets** — protect availability during voluntary
  disruptions (node drains, cluster upgrades).
- **Monitoring & alerting** (metrics, logs, events) — you need visibility
  before an incident, not just commands to run during one.
- **etcd backups** — the control plane's source of truth needs a tested
  restore path.

## Diagram — production request path

```text
Internet
   │
   ▼
Ingress (TLS termination, routing)
   │
   ▼
Service
   │
   ▼
EndpointSlice (only Ready Pods)
   │
   ▼
Pod (with requests/limits + probes)
   │
   ▼
Container
```

## Common mistakes

- Treating a working `kubectl apply` as "done" without checking rollout
  status, probes, and resource settings.
- No PodDisruptionBudget — a routine node drain during maintenance can take
  down all replicas of a service simultaneously.

## Production considerations

- Production readiness is a checklist, not a single setting: resources,
  probes, rollout strategy, RBAC, secrets handling, and observability all
  need to be deliberately configured.

## Interview questions

- What would you check before calling a Deployment "production-ready"?
- Why is a PodDisruptionBudget important during planned maintenance?
- What's the minimum set of things every production Deployment should
  have configured?
