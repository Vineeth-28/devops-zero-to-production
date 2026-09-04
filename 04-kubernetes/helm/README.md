# Helm — Kubernetes Package & Release Management

## Objective

Understand Helm well enough to create, customize, deploy, upgrade, rollback, troubleshoot, and explain Helm Charts in a production Kubernetes environment.

## Core Mental Model

```
Kubernetes
    ↓
Many YAML manifests
    ↓
Helm
    ↓
Chart + Values + Templates
    ↓
Rendered Kubernetes manifests
    ↓
Kubernetes API
    ↓
Resources
```

Helm sits **on top of** Kubernetes. It does not replace `kubectl`, the API server, or the scheduler — it solves the problem of managing large numbers of repetitive, environment-specific YAML files.

## Topics Covered

- Helm overview
- Charts
- Chart structure
- Chart.yaml
- values.yaml
- Templates
- Template expressions
- Helm releases
- Install
- Upgrade
- Rollback
- Values overrides
- Environment-specific values
- Helm repositories
- Chart dependencies
- Hooks
- Helm + CI/CD
- Helm troubleshooting
- Production Helm workflows

## Folder Guide

| Folder | Purpose |
|---|---|
| `commands/` | Command reference, grouped by task |
| `concepts/` | Deep explanations of how Helm works |
| `charts/backend/` | A real, working example chart (Node.js backend) |
| `labs/` | Hands-on practice days (27–28) |
| `troubleshooting/` | Real failure scenarios and how to debug them |
| `workflows/` | ASCII-diagram workflows for deploy/upgrade/rollback/CI-CD |
| `interview/` | Interview questions with model answers |

## How This Complements the Kubernetes Notes

This folder does **not** repeat core Kubernetes concepts (Pods, Deployments, Services, etc. — see `../concepts/`). It assumes that knowledge and focuses only on what Helm adds: packaging, templating, and release management.

---

**Learn → Understand → Practice → Explain → Apply**

DevOps Zero to Production 🚀
