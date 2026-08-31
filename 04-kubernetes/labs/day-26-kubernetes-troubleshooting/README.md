# Day 26 — Kubernetes Troubleshooting Lab

## Objective
Practice the master troubleshooting flow end-to-end against deliberately
broken manifests.

## Concepts

- The master flow in `../../troubleshooting/production-incidents.md`
- Pod Pending, CrashLoopBackOff, ImagePullBackOff, OOMKilled, 0/1 Ready
- Service, PVC, and Node-level troubleshooting

## Commands Practiced

```bash
kubectl get pods -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name> --previous
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get svc,endpointslices
kubectl get pvc
kubectl get nodes
kubectl describe node <node-name>
```

## Hands-on Tasks

Deliberately break each of the following, one at a time, and diagnose it
using only the master flow (don't peek at the "cause" until you've found
it yourself):

1. **Pod Pending** — request `cpu: "999"` (absurdly high) in a Deployment's
   `resources.requests` and apply it.
2. **CrashLoopBackOff** — deploy a container with a broken start command or
   missing required environment variable.
3. **ImagePullBackOff** — set an image tag that doesn't exist.
4. **OOMKilled** — set `limits.memory` very low against a workload that
   needs more, and trigger load.
5. **0/1 Ready** — point a readiness probe at a path that doesn't exist.
6. **Service not working** — mismatch the Service selector against the
   Pod's labels.
7. **PVC Pending** — reference a `storageClassName` that doesn't exist.

For each, write down: the command sequence you used, the exact signal that
told you the cause, and the fix.

## Expected Outcome

You can diagnose any of the above from a cold start (just "something's
broken") using the master flow, without needing to be told which category
of problem it is first.

## Interview Questions

- Walk through your first three commands when a Pod is reported "down."
- How do you distinguish a CrashLoopBackOff caused by the app itself from
  one caused by a missing dependency?
- What's your troubleshooting order when a Service "isn't working"?

## Common Mistakes

- Guessing at a fix before confirming the actual root cause via the flow.
- Stopping investigation at the first abnormal-looking thing instead of
  tracing to the real root cause (see the worked example in
  `production-incidents.md`).

## Key Takeaways

- The master flow works because it's ordered from cheapest/most-informative
  checks first — Events and `describe` before deep application-level
  debugging.
- Most "mystery" Kubernetes incidents resolve to one of a small, well-known
  set of causes covered in this lab.
