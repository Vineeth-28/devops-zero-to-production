# Debugging Flow

## What it is
The general-purpose sequence to follow when investigating any unfamiliar
Kubernetes issue, before jumping to symptom-specific troubleshooting.

## Flow

```text
Symptom Reported
      │
      ▼
kubectl get pods -o wide
      │
      ▼
Identify the abnormal state
(Pending / CrashLoopBackOff / ImagePullBackOff / 0/1 Ready / etc.)
      │
      ▼
kubectl describe pod <pod>
      │
      ▼
Read Events (bottom of describe output)
      │
      ▼
kubectl logs <pod> [--previous]
      │
      ▼
Trace to the specific troubleshooting/ file
for that Pod state
      │
      ▼
Root cause identified
      │
      ▼
Apply fix
      │
      ▼
Verify (rollout status / describe / logs again)
```

## Key points

- The *state* the Pod is in (Pending vs CrashLoopBackOff vs ImagePullBackOff
  vs 0/1 Ready) determines which category of troubleshooting file to jump
  to — identify the state first, before guessing at causes.

## Common mistakes

- Skipping straight to a fix based on a guess, without confirming the
  actual Pod state first.

## Interview questions

- What's the first command you run when told "something in the cluster is
  broken," and why that one first?
