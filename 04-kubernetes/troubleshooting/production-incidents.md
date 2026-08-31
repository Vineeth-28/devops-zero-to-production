# Master Production Troubleshooting Flow

This is the single most important file in this handbook — the fixed
sequence to follow when something is broken in production and you don't
yet know why.

## Master flow

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

Work top to bottom. Each step either finds the root cause or rules out a
category and moves you to the next one — don't skip steps, and don't jump
straight to a guess.

## Why Events first, logs second

`kubectl describe pod` surfaces scheduling, image pull, and probe failures
that happen *before* a container ever produces a log line. Checking Events
early avoids wasting time staring at empty or irrelevant logs for a Pod
that never actually started properly.

## Quick cheat sheet

```text
Pending
→ describe pod
→ Events
→ Scheduling / Resources / PVC / Node

CrashLoopBackOff
→ logs
→ logs --previous
→ describe

ImagePullBackOff
→ describe
→ image / tag / registry credentials

0/1 Running
→ describe
→ probes
→ readiness
→ Service endpoints

OOMKilled
→ memory limits
→ usage
→ application investigation

PVC Pending
→ describe pvc
→ StorageClass / PV / provisioner

Service not working
→ selector
→ labels
→ EndpointSlices
→ ports

Node issue
→ get nodes
→ describe node

Unknown issue
→ get events --sort-by=.metadata.creationTimestamp
```

## Command reference for the flow

```bash
kubectl get pods -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl get events --sort-by=.metadata.creationTimestamp

kubectl get svc
kubectl describe svc <name>
kubectl get endpointslices

kubectl get configmaps
kubectl get secrets

kubectl get pvc
kubectl describe pvc <name>

kubectl get nodes
kubectl describe node <node-name>
```

## Worked example

**Incident**: "Backend API returning 502s in production."

1. `kubectl get pods` — three of four `backend` Pods are `Running`, one is
   `CrashLoopBackOff`.
2. `kubectl describe pod backend-xxxx` — Events show repeated container
   restarts, exit code 1.
3. `kubectl logs backend-xxxx --previous` — log shows
   `Error: connect ECONNREFUSED mysql:3306`.
4. Check Service — `mysql` Service exists, but `kubectl get endpointslices
   -l kubernetes.io/service-name=mysql` shows **zero endpoints**.
5. Check the `mysql` Pod directly — it's `Pending`.
6. `kubectl describe pod mysql-xxxx` — Events show
   `pod has unbound immediate PersistentVolumeClaims`.
7. `kubectl describe pvc mysql-data` — `Pending`, no matching StorageClass.

**Root cause**: the MySQL PVC never bound (StorageClass typo), so the
MySQL Pod never started, so it had no endpoints, so every backend Pod that
tried to connect crashed and entered `CrashLoopBackOff`.

This is why the flow checks **Service → EndpointSlices → PVC** even when
the visible symptom is "backend Pods are crashing" — the actual root cause
was several layers away from the first symptom.

## Common mistakes

- Fixing the visible symptom (restarting the crashing Pod) instead of
  tracing back to the actual root cause.
- Skipping the Service/EndpointSlice/PVC checks because the crashing Pod
  "looks like" the whole story.

## Production considerations

- Document the actual root cause after every incident, even if the fix was
  simple — patterns repeat, and a written trail speeds up the next
  incident.
