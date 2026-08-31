# ☸️ Kubernetes Production Revision

## Objective

Understand Kubernetes architecture, workloads, networking, storage,
configuration, health checks, scheduling, and troubleshooting — the way a
DevOps engineer actually uses Kubernetes in production, not as a beginner
tutorial.

> **Learn → Understand → Practice → Explain → Apply**

---

## Topics Covered

- Day 22 — Kubernetes Architecture
- Day 23 — Pods, Deployments & ReplicaSets
- Day 24 — Services, Networking & DNS
- Day 25 — Storage, ConfigMaps, Secrets & Health Checks
- Day 26 — Kubernetes Troubleshooting

---

## Revision Progress

- [x] Day 22 — Kubernetes Architecture
- [x] Day 23 — Pods & Deployments
- [x] Day 24 — Services & Networking
- [x] Day 25 — Storage, Config & Probes
- [x] Day 26 — Kubernetes Troubleshooting

**☸️ Kubernetes Module: 5/5 complete. ✅**

---

## Core Architecture

```text
Developer
   │
   ▼
kubectl
   │
   ▼
API Server
   │
   ▼
Control Plane
   │
   ▼
Scheduler
   │
   ▼
Worker Node
   │
   ▼
Kubelet
   │
   ▼
Container Runtime
   │
   ▼
Pod
```

---

## Repository Structure

```text
04-kubernetes/
│
├── README.md
│
├── commands/               # kubectl command reference, by topic
├── manifests/               # valid, realistic YAML examples
├── concepts/                 # revision notes — what/why/how/commands/example/mistakes/production/interview
├── troubleshooting/           # symptom-based debugging guides + master flow
├── workflows/                 # end-to-end flow diagrams
├── labs/                       # Day 22-26 hands-on labs
│   ├── day-22-kubernetes-architecture/
│   ├── day-23-pods-deployments/
│   ├── day-24-services-networking/
│   ├── day-25-storage-config-probes/
│   └── day-26-kubernetes-troubleshooting/
└── interview/                   # practical Q&A with expected answer points
```

---

## Where to Start

- **New to a topic?** Start in `concepts/` — each file covers what it is,
  why it's used, how it works, commands, an example, common mistakes,
  production considerations, and interview questions.
- **Need exact commands?** Go straight to `commands/`.
- **Something's broken?** Go to `troubleshooting/production-incidents.md`
  first — it's the master flow that routes you to the right specific file.
- **Practicing hands-on?** Work through `labs/` in order, Day 22 to Day 26.
- **Interview prep?** `interview/` has expected answer points, not just
  one-line definitions.

---

## The Master Troubleshooting Flow

The single most important file in this handbook:
`troubleshooting/production-incidents.md`

```text
Production Backend Down
        │
        ▼
kubectl get pods
        │
        ▼
Identify abnormal Pods
        │
        ▼
kubectl describe pod
        │
        ▼
kubectl logs
        │
        ▼
kubectl logs --previous
        │
        ▼
kubectl get events
        │
        ▼
Check Service
        │
        ▼
Check EndpointSlices
        │
        ▼
Check ConfigMaps / Secrets
        │
        ▼
Check PVC
        │
        ▼
Check Nodes
```

---

## Goal

Understand Kubernetes the way a DevOps engineer uses it in production —
able to reason about *why* something failed, not just which command to
run.

> **Learn → Understand → Practice → Explain → Apply**
