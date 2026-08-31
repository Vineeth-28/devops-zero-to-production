# Pods (Concept)

## What it is
A Pod is the smallest deployable unit in Kubernetes — one or more
containers that share networking (same IP) and storage.

## Why we use it
Kubernetes doesn't schedule individual containers; it schedules Pods.
Containers inside a Pod are meant to be tightly coupled (e.g. an app +
its log-shipping sidecar).

## How it works

- Most Pods run a single container.
- Multi-container Pods share the same network namespace (`localhost`
  between containers) and can share volumes.
- Pods are usually not created directly — a Deployment/ReplicaSet manages
  them, replacing a Pod entirely (new IP, new name) rather than "restarting
  in place" at the Pod level.

## Pod states

```text
Pending    -> accepted by the cluster, not yet running (scheduling / image pull)
Running    -> bound to a node, at least one container running
Succeeded  -> all containers terminated successfully (batch jobs)
Failed     -> all containers terminated, at least one failed
Unknown    -> node communication lost, state can't be determined
```

## Container restart behavior

Individual **containers** inside a running Pod can restart (per
`restartPolicy`) without the Pod itself being recreated — this is what
causes `CrashLoopBackOff`: the container keeps restarting inside the same
Pod.

## Example

```bash
kubectl get pods
kubectl describe pod backend-7d4d9c9f8b-x2kqp
kubectl logs backend-7d4d9c9f8b-x2kqp
kubectl exec -it backend-7d4d9c9f8b-x2kqp -- /bin/sh
```

## Common mistakes

- Deploying standalone Pods to production instead of via a Deployment —
  losing self-healing and rolling updates.
- Confusing "container restarted" with "Pod recreated" — they're different
  events with different causes.

## Production considerations

- Multi-container Pods should only be used for tightly coupled helpers
  (sidecars, log shippers) — not as a way to bundle unrelated services.

## Interview questions

- What's the difference between a Pod and a container?
- When would you use a multi-container Pod?
- What does it mean when a Pod is in `Pending` vs `Unknown` state?
