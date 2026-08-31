# Interview Questions — Production Kubernetes

**Q1. What would you check before calling a Deployment "production-ready"?**
Expected answer points:
- `requests`/`limits` set realistically.
- Liveness + readiness (and startup, if needed) probes configured
  correctly.
- Rolling update strategy (`maxSurge`/`maxUnavailable`) considered
  deliberately, not left at defaults blindly.
- Secrets not hardcoded, RBAC/Namespace isolation in place.
- Monitoring/alerting and a rollback plan.

**Q2. Requests vs Limits — explain both, and what happens when each is
exceeded.**
Expected answer points:
- Requests: what the Scheduler reserves; drives placement decisions.
- Limits: hard ceiling; exceeding CPU limit throttles, exceeding memory
  limit triggers OOMKilled.

**Q3. Liveness vs Readiness vs Startup Probe — explain all three and why
you'd use each together.**
Expected answer points:
- Liveness: "is it fundamentally broken" -> restart on failure.
- Readiness: "is it ready for traffic right now" -> removed from Service
  endpoints on failure, not restarted.
- Startup: protects slow-booting apps from being killed by liveness before
  they've finished starting.

**Q4. Why is deploying `latest` risky, and what should you do instead in
production?**
Expected answer points:
- `latest` is a mutable/floating tag — no way to know exactly which build
  is running, and rollback becomes ambiguous.
- Tag with an immutable identifier (e.g. commit SHA) so every deploy and
  rollback is precise and traceable.

**Q5. Describe the production incident workflow end-to-end for "backend
API returning errors."**
Expected answer points:
- Follow the master flow: identify abnormal Pods, describe/logs/events,
  check Service/EndpointSlices, check ConfigMaps/Secrets, check PVC, check
  Nodes.
- Trace root cause rather than fixing only the visible symptom (e.g. a
  crashing backend caused by an unrelated database PVC failure).
- Document the root cause after resolution.

**Q6. What's a PodDisruptionBudget, and why does it matter in production?**
Expected answer points:
- Limits how many Pods of a workload can be voluntarily disrupted at once
  (e.g. during a node drain or cluster upgrade).
- Protects availability during planned maintenance — without one, a drain
  could take down all replicas of a service simultaneously.
