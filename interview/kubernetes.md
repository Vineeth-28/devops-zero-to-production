# Kubernetes Interview Questions

Based on `../04-kubernetes/` (concepts/, commands/, troubleshooting/, manifests/, workflows/). Helm-specific questions are in `helm.md`.

---

## Q1. Walk me through what actually happens when you run `kubectl apply -f deployment.yaml`.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you understand the full control-plane flow, not just "it creates pods."

### Expected Answer
`kubectl` sends the manifest to the API Server, which validates it and persists the desired state in etcd. The Deployment controller notices the new/changed Deployment and creates/updates a ReplicaSet. The ReplicaSet controller creates Pod objects to match the desired replica count. The Scheduler assigns each unscheduled Pod to a Node based on resource availability and constraints. The kubelet on that node pulls the container image and starts the containers, reporting status back to the API Server.

### Strong Interview Answer
"`kubectl` talks to the API Server, which validates the manifest and writes the desired state into etcd — that's the single source of truth. The Deployment controller sees the new Deployment and creates a ReplicaSet to manage the replica count. The ReplicaSet controller then creates the actual Pod objects. Those Pods start unscheduled, so the Scheduler picks a suitable Node for each based on resource requests and any constraints. Finally the kubelet on that node actually pulls the image and starts the containers, and continuously reports status back so the API Server — and therefore `kubectl get pods` — reflects reality."

### Follow-up Questions
- What's the role of etcd specifically, and why does it matter that it's the source of truth?
- What happens if the Scheduler can't find a suitable node?
- How does the kubelet know to restart a container that crashes?

### Key Points
- Flow: API Server → etcd (desired state) → Deployment controller → ReplicaSet → Pods → Scheduler → kubelet.
- etcd is the single source of truth; everything reconciles against it.
- kubelet is the node-level agent that actually runs containers and reports status.

---

## Q2. A Pod is stuck in `CrashLoopBackOff`. What's your first command and your reasoning?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you go straight to logs/describe rather than guessing, and understand what the status actually means.

### Expected Answer
`CrashLoopBackOff` means the container starts, exits, and Kubernetes is backing off before retrying — it's not a scheduling problem, it's the container itself failing after starting. First command: `kubectl logs <pod> --previous` (to see the crashed container's output, since the current one may have just restarted with no logs yet), then `kubectl describe pod <pod>` for exit code and recent events.

### Strong Interview Answer
"CrashLoopBackOff tells me the container is actually starting and then dying — so it's an application-level failure, not a scheduling issue. My first command is `kubectl logs <pod> --previous`, because the current container instance might have only just restarted with nothing logged yet — `--previous` gets me the logs from the crashed instance. Alongside that, `kubectl describe pod` gives me the exit code and recent events, which tells me if it's an OOM kill, a failed liveness probe, or an application error like a bad config or missing environment variable."

### Follow-up Questions
- What does exit code 137 in the describe output tell you?
- How is CrashLoopBackOff different from `Error` status?
- What would make you suspect a liveness probe misconfiguration instead of a genuine app crash?

### Key Points
- CrashLoopBackOff = container starts then exits repeatedly; Kubernetes backs off retries.
- `kubectl logs --previous` is essential — the current instance may be too fresh to have logs.
- `kubectl describe pod` gives exit code + events for root cause.

---

## Q3. What's the difference between `OOMKilled` and `CrashLoopBackOff`?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you understand that one is a *reason* and the other is a *state/pattern* — they're not mutually exclusive, they answer different questions.

### Expected Answer
`OOMKilled` is a specific reason a container was terminated (it exceeded its memory limit and the kernel killed it). `CrashLoopBackOff` is the Pod's overall state describing a repeating pattern of crash-then-restart, regardless of the reason. A Pod can be in `CrashLoopBackOff` because its container keeps getting `OOMKilled`, or for many other reasons (app bug, failed dependency, bad config).

### Strong Interview Answer
"They're answering different questions. `OOMKilled` is a reason — it tells you specifically that the container exceeded its memory limit and the kernel terminated it. `CrashLoopBackOff` is a state describing behavior — the container keeps crashing and restarting, and Kubernetes is backing off between attempts. So you could see a Pod in `CrashLoopBackOff` state with `OOMKilled` as the last termination reason — that combination tells me the memory limit is too low, or there's a leak, whereas `CrashLoopBackOff` with a generic `Error` reason points me toward the application logs instead of resource limits."

### Follow-up Questions
- How would you confirm a memory limit is genuinely too low vs. there being a memory leak?
- Where do you find the termination reason in `kubectl describe pod` output?
- What would you increase first — memory request or memory limit — and why?

### Key Points
- `OOMKilled` = a termination reason (memory limit exceeded).
- `CrashLoopBackOff` = a Pod state describing the restart pattern, any reason.
- The combination of state + reason together tells the real story — check both.

---

## Q4. A Pod is stuck in `Pending`. How do you find out why?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you know Pending is a scheduling problem and where the Scheduler explains itself.

### Expected Answer
`Pending` means the Pod hasn't been scheduled to a Node yet. `kubectl describe pod` shows Scheduler events explaining why — common causes: insufficient CPU/memory on any node, no node matching a nodeSelector/affinity rule, a taint with no matching toleration, or an unbound PersistentVolumeClaim.

### Strong Interview Answer
"Pending means scheduling hasn't happened yet, so this is a Scheduler-level problem, not an application problem — there's nothing to check in `kubectl logs` because the container hasn't started. I go straight to `kubectl describe pod`, which shows Scheduler events under the Events section explaining exactly why — most commonly insufficient resources on any available node, a nodeSelector or affinity rule that no node satisfies, a taint the Pod doesn't tolerate, or a PVC that can't be bound to a PersistentVolume."

### Follow-up Questions
- How would resource requests being set too high cause this?
- What's the difference between a taint/toleration issue and an affinity issue here?
- How would an unbound PVC show up differently in `describe pod`?

### Key Points
- `Pending` = not yet scheduled; check Scheduler events, not container logs.
- `kubectl describe pod` Events section names the exact blocking reason.
- Common causes: resource shortage, node selector/affinity mismatch, taints, unbound PVC.

---

## Q5. What's the difference between `ImagePullBackOff` and `ErrImagePull`, and how do you troubleshoot either?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you can bucket the failure into "naming problem" vs "auth/network problem" quickly.

### Expected Answer
`ErrImagePull` is the immediate error when a pull attempt fails; `ImagePullBackOff` is Kubernetes backing off between retries of that failing pull — they're related states in the same failure loop, not different root causes. Root causes fall into two buckets: the image name/tag is wrong or doesn't exist, or the registry needs authentication (missing/wrong `imagePullSecrets`) or isn't reachable from the node.

### Strong Interview Answer
"They're two views of the same problem — `ErrImagePull` is the immediate failed attempt, `ImagePullBackOff` is Kubernetes backing off before retrying. `kubectl describe pod` shows the actual pull error message, and I bucket it into two categories: either the image reference itself is wrong — typo in the name, tag doesn't exist, wrong registry — or it's an access problem, meaning the node can't authenticate to a private registry because `imagePullSecrets` is missing or misconfigured, or there's a network path issue reaching the registry at all."

### Follow-up Questions
- How do you configure `imagePullSecrets` for a private registry?
- How would you test if a node can reach the registry independently of Kubernetes?
- What's a common cause of this that only shows up in one environment but not another?

### Key Points
- `ErrImagePull` → `ImagePullBackOff` is the same failure loop, immediate then backed-off.
- Bucket the cause: wrong image reference, vs. auth/network to the registry.
- `kubectl describe pod` has the literal pull error message — read it exactly.

---

## Q6. A Service has no endpoints even though the Deployment shows Pods running. What's wrong?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Whether you understand Services select Pods by label, and readiness probes gate endpoint membership — a genuinely common real incident.

### Expected Answer
Two usual causes: the Service's `selector` doesn't match the Pods' labels (typo or mismatch), or the Pods exist and are "Running" but haven't passed their readiness probe — Kubernetes only adds Pods to a Service's Endpoints once they're Ready, regardless of "Running" status.

### Strong Interview Answer
"`Running` just means the container process started — it doesn't mean the Service will route to it. I'd first check `kubectl get endpoints <service>` — if it's empty, then check the Service's `selector` against the Pods' actual labels with `kubectl get pods --show-labels`, since a mismatch there is a very common typo-level bug. If the labels do match, the next suspect is the readiness probe — a Pod only gets added to Endpoints once it passes readiness, so if the probe is misconfigured or the app takes longer to become ready than the probe expects, the Pod stays 'Running' but never becomes a valid endpoint."

### Follow-up Questions
- How is `kubectl get endpoints` different from checking the Service object itself?
- What's the difference between a Pod being Ready vs Running in terms of Service traffic?
- How would a wrong `targetPort` (vs `port`) cause a similar-looking symptom?

### Key Points
- `Running` ≠ Ready ≠ receiving traffic — Endpoints only include Ready Pods.
- Check selector/label match first (`kubectl get pods --show-labels`), then readiness probe status.
- `kubectl get endpoints <svc>` is the fastest way to confirm whether any Pod is actually eligible.

---

## Q7. Explain readiness vs liveness probes, with a real incident example of getting it wrong.

**Difficulty:** 🔴 Production

### What the interviewer is testing
Deep, scenario-based understanding — this is one of the most commonly misconfigured things in real clusters.

### Expected Answer
Readiness determines if a Pod should receive traffic (removed from Service endpoints if it fails, but not restarted). Liveness determines if a Pod should be restarted (kubelet kills and restarts the container if it fails repeatedly). A real incident: putting a database connectivity check on the liveness probe — if the database has a brief blip, every Pod's liveness probe fails simultaneously, causing a mass restart of all replicas at once, which is far worse than just briefly losing readiness (and traffic) on some of them.

### Strong Interview Answer
"Readiness controls traffic — if it fails, the Pod is pulled out of the Service's endpoints but left running. Liveness controls the Pod's life itself — if it fails repeatedly, kubelet kills and restarts the container. I've seen a real incident caused by putting a database health check on the liveness probe instead of readiness: when the database had a brief network blip, every single replica's liveness probe failed at the same time, so Kubernetes restarted all of them simultaneously — turning a transient dependency issue into a full outage with zero healthy replicas, instead of just some Pods briefly losing traffic via readiness while staying up and ready to recover the moment the DB came back."

### Follow-up Questions
- What probe would you use for a dependency health check instead, and why?
- How would you configure `initialDelaySeconds` to avoid killing a slow-starting app?
- What's `startupProbe` for, and how does it interact with the other two?

### Key Points
- Readiness = traffic gate (removed from Service, not restarted). Liveness = restart trigger.
- Never put a flaky external dependency check on liveness — it can cause synchronized mass restarts.
- `startupProbe` protects slow-starting apps from being killed by liveness before they're even up.

---

## Q8. A Deployment rollout says "succeeded" but users are seeing errors. What went wrong?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Whether you understand that a successful rollout only confirms Pods became Ready per their probes — not that the app is functionally correct.

### Expected Answer
Rollout "success" means the new ReplicaSet's Pods passed their configured readiness probe and the old ones were scaled down — it says nothing about application correctness beyond what the probe actually checks. If the readiness probe is shallow (e.g. just checks the process is up, or hits `/health` which doesn't check downstream dependencies), a genuinely broken deployment can still report success.

### Strong Interview Answer
"Kubernetes' definition of 'succeeded' is narrow — it means the new Pods passed whatever the readiness probe actually checks, and the rollout replaced old Pods with new ones cleanly. It has no idea whether the app is functionally correct beyond that probe. If the readiness probe is shallow — say it just hits `/health` and that endpoint always returns 200 regardless of whether the app can reach its database — a broken deploy can sail through as 'successful' while users hit real errors. The fix is making the readiness probe meaningfully reflect the app's actual ability to serve traffic, and pairing that with real post-deploy monitoring/alerting rather than trusting rollout status alone."

### Follow-up Questions
- What would you put in a "deep" readiness check vs a "shallow" one, and what's the tradeoff?
- How would you catch this with monitoring even if the probe itself stays shallow?
- What rollout strategy settings (maxSurge/maxUnavailable) affect how fast this would have been noticed?

### Key Points
- "Rollout succeeded" only means the readiness probe passed — not that the app is correct.
- Shallow health checks (process-up only) hide real breakage.
- Pair rollout status with actual post-deploy metrics/alerting, don't trust it alone.

---

## Q9. What's the difference between a ConfigMap and a Secret? Is a Secret actually secure?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you know Secrets are only base64-encoded by default, not encrypted — a common misconception to catch.

### Expected Answer
ConfigMaps and Secrets both inject configuration into Pods (env vars or mounted files); the distinction is intent, not real encryption by default. Secret data is base64-encoded, not encrypted, when stored in etcd unless encryption-at-rest is explicitly configured on the cluster. RBAC restricting who can read Secret objects is the real access control, not the encoding.

### Strong Interview Answer
"Mechanically they're similar — both can be mounted as files or injected as environment variables. Secrets are meant for sensitive data, but by default they're only base64-encoded in etcd, not encrypted — base64 is an encoding, not encryption, so anyone with etcd access or the right RBAC permissions can trivially decode it. Real protection comes from enabling encryption-at-rest for etcd and tightly scoping RBAC so only the Pods and people who need a Secret can read it. I wouldn't rely on Secrets alone for anything highly sensitive without those additional controls, and for real production secrets I'd lean toward something like a dedicated secrets manager integrated via an external-secrets operator."

### Follow-up Questions
- How would you enable encryption-at-rest for Secrets in etcd?
- What RBAC verb specifically controls who can read Secret contents?
- What's an alternative to native Kubernetes Secrets for more sensitive data?

### Key Points
- Secrets are base64-encoded, not encrypted, by default — common misconception.
- Real protection = etcd encryption-at-rest + tight RBAC, not the encoding itself.
- For highly sensitive data, consider an external secrets manager.

---

## Q10. A Pod shows `Running` and `Ready`, but the app is unreachable. How do you troubleshoot?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Layered troubleshooting through the Kubernetes networking stack, not just "check the pod."

### Expected Answer
Work outward from the Pod: can you reach the app directly via `kubectl port-forward` or `exec` (rules the Pod itself out/in)? Does the Service selector match and have valid endpoints? Is the Service `targetPort` correct against the container's actual listening port? Is there a NetworkPolicy blocking traffic? Is the Ingress/LoadBalancer correctly routing to the Service?

### Strong Interview Answer
"I work from the Pod outward. First, `kubectl port-forward` straight to the Pod to see if the app itself responds — that isolates whether it's an app problem or a networking-layer problem. If the Pod responds directly, I move to the Service: does `kubectl get endpoints` show this Pod, and does the Service's `targetPort` actually match the port the container is listening on — I've seen `port` and `targetPort` confused more than once. Then I check for any `NetworkPolicy` that might be blocking traffic between namespaces or Pods. Finally, if the Service itself works via port-forward but external traffic still fails, I move up to Ingress or LoadBalancer configuration."

### Follow-up Questions
- What's the difference between `port`, `targetPort`, and `nodePort` on a Service?
- How would a NetworkPolicy silently block traffic without any obvious error?
- How do you test connectivity to a Service from inside another Pod?

### Key Points
- Isolate layer by layer: Pod directly (port-forward) → Service (endpoints, targetPort) → NetworkPolicy → Ingress/LoadBalancer.
- `port` vs `targetPort` mismatches are a common, easy-to-miss cause.
- NetworkPolicies fail silently — no error, traffic is just dropped.

---

## Q11. Explain how a rolling update and a rollback actually work under the hood.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Understanding of ReplicaSet revision history, not just the `kubectl rollout` commands.

### Expected Answer
A Deployment update creates a new ReplicaSet with the updated Pod template, and gradually scales it up while scaling the old ReplicaSet down, respecting `maxSurge`/`maxUnavailable`. The old ReplicaSet isn't deleted — it's scaled to 0 and kept (revision history), which is what makes rollback fast: `kubectl rollout undo` just scales the previous ReplicaSet back up and the current one down, no rebuild needed.

### Strong Interview Answer
"When you update a Deployment, Kubernetes creates a brand-new ReplicaSet with the new Pod template, and does a controlled swap — scaling the new one up and the old one down gradually, governed by `maxSurge` and `maxUnavailable` so you don't lose too much capacity at once. Crucially, the old ReplicaSet isn't deleted, just scaled to zero — it's kept in revision history. That's why rollback is fast: `kubectl rollout undo` doesn't rebuild anything, it just reverses the process, scaling the old ReplicaSet back up and the new one down."

### Follow-up Questions
- How would you roll back to a specific revision, not just the immediately previous one?
- What do `maxSurge` and `maxUnavailable` control, specifically?
- How long does Kubernetes retain old ReplicaSet revision history by default?

### Key Points
- Rolling update = new ReplicaSet scaled up, old one scaled down, controlled by maxSurge/maxUnavailable.
- Old ReplicaSets are kept (scaled to 0) as revision history, not deleted.
- Rollback is fast because it's just re-scaling existing ReplicaSets, not rebuilding.

---

## Q12. Service vs Ingress — what's the actual division of responsibility?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
L4 vs L7 understanding, not just "Service is internal, Ingress is external" (which is often wrong/incomplete).

### Expected Answer
A Service provides stable networking (a virtual IP and DNS name) and load-balances traffic to a set of Pods at L4 (TCP/UDP) — it doesn't understand HTTP. An Ingress operates at L7, understanding HTTP routing (host/path-based rules, TLS termination) and sits in front of one or more Services, routing external HTTP(S) traffic into the cluster based on those rules.

### Strong Interview Answer
"A Service is L4 — it gives a stable virtual IP and DNS name, and load-balances TCP/UDP traffic to matching Pods, but it has no idea about HTTP paths or hostnames. Ingress is L7 — it understands HTTP, so it can route based on hostname or URL path, terminate TLS, and it sits in front of Services, not Pods directly. So a typical setup is: external traffic hits the Ingress controller, which reads the Ingress rules to decide which Service to send it to, and that Service then load-balances across its Pods."

### Follow-up Questions
- What's an Ingress controller, and why is it a separate thing from the Ingress resource?
- How would you route `/api` and `/app` to two different backend Services?
- When would a Service of type LoadBalancer be used instead of Ingress?

### Key Points
- Service = L4, stable virtual IP + load balancing to Pods, no HTTP awareness.
- Ingress = L7, HTTP-aware routing (host/path), TLS termination, routes to Services.
- Ingress resource needs an Ingress controller actually running to do anything.

---

## Q13. How would you distinguish a genuine memory leak from an under-provisioned container, both showing repeated `OOMKilled`?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Trend analysis skill — using metrics history, not just the current snapshot.

### Expected Answer
Look at memory usage over time in monitoring (Prometheus/Grafana): a leak shows a steady, continuous climb across the container's lifetime regardless of load, eventually always hitting the limit no matter how high you raise it. Under-provisioning shows memory tracking normal load/usage patterns and hitting the ceiling only during legitimate peak usage — raising the limit to match real peak usage resolves it and it stays stable.

### Strong Interview Answer
"I'd pull up memory usage over time for that container in Grafana. A real leak has a distinctive shape — usage climbs steadily and continuously over the container's uptime, independent of traffic, and it'll eventually hit whatever limit you set, even if you double it, because it never plateaus. Under-provisioning looks different — usage tracks actual load, spikes during real traffic peaks, and plateaus at a sane level under normal load. If raising the limit to a reasonable, load-justified number makes the OOM kills stop and stay stopped, it was provisioning. If they come back after a while at any limit, it's a leak, and I'd go looking in the app for unbounded caches, unclosed connections, or similar."

### Follow-up Questions
- What Prometheus query would you use to graph a container's memory over time?
- How would you correlate a memory climb with a specific application event (e.g. a specific request type)?
- What's a reasonable next step once you suspect a genuine leak, beyond raising the limit?

### Key Points
- Leak = steady climb independent of load, recurs at any limit.
- Under-provisioning = usage tracks load, plateaus once limit matches real peak.
- Use historical metrics (Grafana/Prometheus), not a single snapshot, to tell them apart.

---

## Q14. What's the difference between `requests` and `limits`, and how does misconfiguring them cause a real incident?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Whether you understand these drive both scheduling and runtime enforcement, and can describe a failure mode from getting them wrong.

### Expected Answer
`requests` is what the Scheduler guarantees is reserved for the container and uses for bin-packing decisions. `limits` is the hard ceiling enforced at runtime — exceeding a memory limit gets the container OOM-killed; exceeding a CPU limit gets it throttled (not killed). A common incident: setting requests too low lets the Scheduler over-pack a node, and when several Pods simultaneously approach their real usage, the node runs out of actual resources, causing broader node-level pressure and evictions beyond just the offending Pod.

### Strong Interview Answer
"`requests` is what the Scheduler reserves and uses to decide which node a Pod can fit on — it's a scheduling-time guarantee. `limits` is enforced live at runtime — go over the memory limit and you're OOM-killed, go over the CPU limit and you're throttled, not killed. A real incident pattern is setting requests unrealistically low to 'fit more Pods per node' — the Scheduler happily over-packs the node based on those low requests, but when several of those Pods simultaneously use more than their request (which is allowed, up to the limit), the node runs genuinely low on resources, and you can get node-level memory pressure causing the kubelet to evict Pods that had nothing to do with the original problem."

### Follow-up Questions
- Why does exceeding a CPU limit throttle instead of kill, unlike memory?
- How would you right-size requests and limits based on real usage data?
- What's the risk of setting requests and limits to the exact same value everywhere?

### Key Points
- `requests` = scheduling-time reservation; `limits` = runtime hard ceiling.
- Memory over limit → OOMKilled. CPU over limit → throttled, not killed.
- Under-set requests can cause node over-packing and cascading eviction of unrelated Pods.

---
