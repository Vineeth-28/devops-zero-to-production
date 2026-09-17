# Production Troubleshooting & Incident Response Interview Questions

Based on `../production-runbooks/` (all incident runbooks + incident-response.md) and the master troubleshooting framework taught in the root README.

---

## Q1. Walk me through your mental framework for handling a production incident from the first alert to closure.

**Difficulty:** 🔴 Production

### What the interviewer is testing
Whether you have a repeatable, structured process rather than reacting ad hoc — this is often the single most important question in a DevOps interview.

### Expected Answer
Incident → Confirm Symptom (is this real, not a false alarm) → Determine Impact/Blast Radius (how many users, which service) → Check Recent Changes (deploys, config changes, infra changes) → Identify Affected Layer (network, LB, service, container, app, DB) → Collect Evidence (metrics + logs + events) → Investigate → Root Cause → Mitigate (stop the bleeding) → Verify Recovery → Prevent Recurrence → Document/Postmortem.

### Strong Interview Answer
"I follow the same shape every time, regardless of the specific incident. First, confirm the symptom is real — check the actual signal, not just trust the alert blindly. Then determine impact and blast radius, because that decides urgency and who needs to know. Then check what changed recently — most incidents trace back to a recent deploy or config change, so that's a high-value early check. Then I identify which layer is actually affected — is it network, load balancer, the service itself, the container, the application, or the database — because that narrows where to look next instead of checking everything randomly. I collect evidence, metrics, logs, and events together, investigate to find root cause, then mitigate to stop user impact as fast as possible — which might be a rollback rather than a full fix. Once recovery is verified, I focus on preventing recurrence and writing it up, because the incident isn't actually done until the lesson is captured."

### Follow-up Questions
- Why does 'mitigate' come before 'root cause' is fully understood in some cases?
- How do you decide when an incident is actually resolved versus just appearing stable?
- What's the risk of skipping the postmortem step even after service is restored?

### Key Points
- Structured order: Confirm → Impact → Recent Changes → Affected Layer → Evidence → Investigate → Root Cause → Mitigate → Verify → Prevent → Document.
- Mitigation (stopping user impact) can and often should happen before full root cause is known.
- The incident isn't closed until prevention and documentation happen — not just when service is restored.

---

## Q2. Explain the "production layers" mental model and why troubleshooting by layer beats randomly changing things.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Systematic thinking versus panic-driven trial and error under pressure.

### Expected Answer
Think in layers: User/Request → DNS/Network → Load Balancer/Ingress → Service → Kubernetes → Container → Application → Database/External Dependency. Troubleshoot by isolating which layer is actually failing (using evidence at each boundary) before making any change, instead of randomly restarting things and hoping.

### Strong Interview Answer
"Instead of jumping straight to 'let's restart the pod' or 'let's roll back,' I think about the request's path through layers — from the user, through DNS, the load balancer or ingress, the service, into the container, the application code, and finally any database or external dependency it calls. At each layer boundary there's usually a way to check if that specific layer is healthy — can DNS resolve, is the load balancer routing, does the service have healthy endpoints, is the container running and ready, is the app logic actually correct, is the database reachable. Working through it in order means I find the actual broken layer with evidence, instead of guessing and potentially masking or even worsening the real problem with a change that didn't need to happen."

### Follow-up Questions
- Give an example of a symptom that looks like an application bug but is actually a lower layer (like DNS or load balancer).
- How would you quickly narrow down which layer is broken when you have limited time?
- Why is 'randomly restarting things' actually risky, not just inefficient?

### Key Points
- Layers: User → DNS/Network → LB/Ingress → Service → Kubernetes → Container → App → Database/External dependency.
- Check each layer boundary with evidence before acting — don't skip ahead based on a guess.
- Random restarts can mask the real cause and burn time without fixing anything.

---

## Q3. What's the actual difference between 502, 503, and 504 errors, and how does that difference change where you look first?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Precise understanding of HTTP status semantics as diagnostic signals, not just "they're all errors."

### Expected Answer
502 Bad Gateway: the upstream (proxy/load balancer) got an invalid or malformed response from the backend, or couldn't connect to it — points to the backend being down, crashing, or returning garbage. 503 Service Unavailable: the server (or upstream) is explicitly refusing to serve — often deliberate (maintenance mode) or capacity-related (no healthy backends registered). 504 Gateway Timeout: the upstream connected to the backend but didn't get a response within the timeout — points to the backend being alive but too slow (overloaded, stuck query, deadlock).

### Strong Interview Answer
"They point to different failure shapes, so I don't investigate them the same way. 502 means the proxy tried to talk to the backend and got either no valid response or a connection failure — that sends me looking at whether the backend process is even up or crashing. 503 usually means there's genuinely nothing healthy to route to — no ready endpoints behind the load balancer — or it's a deliberate maintenance response; that sends me to check backend health/readiness state rather than assuming a crash. 504 means the backend was reachable, the connection succeeded, but it just never responded in time — that points toward the backend being alive but overloaded or stuck, like a slow database query or a deadlock, not a crash at all. Reading which one it is saves real time versus treating all three as 'the backend is broken' generically."

### Follow-up Questions
- What load balancer/proxy-level evidence would confirm a 503 is about missing healthy endpoints specifically?
- How would you distinguish a slow backend (504) from a genuinely hung/deadlocked one?
- Could a bad readiness probe configuration cause a 503 even though the app itself is fine?

### Key Points
- 502 = backend unreachable/invalid response → check if backend is up/crashing.
- 503 = no healthy backend to route to / deliberate refusal → check readiness/capacity.
- 504 = backend reachable but too slow → check for overload, slow queries, deadlocks, not a crash.

---

## Q4. How do you determine the "blast radius" of an incident quickly, and why does it matter before you start deep investigation?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Prioritization instinct — impact assessment shapes urgency and communication, and should happen early.

### Expected Answer
Check monitoring/dashboards for affected scope: is it one instance, one region, one service, or system-wide? Is it all users or a specific segment (a feature flag cohort, a specific customer)? This determines severity classification, who needs to be notified, and whether to mitigate immediately (e.g. a fast rollback) versus taking time for careful root-causing.

### Strong Interview Answer
"Before diving deep, I check scope — is this one instance out of many, one service, one region, or is it affecting the whole system; is it all users or a specific segment, like people on a particular feature flag. That assessment directly drives severity and urgency — a single-instance blip that's auto-healing is very different from an all-users, all-regions outage, even if the underlying technical symptom looks superficially similar in the first alert. Getting blast radius right early also shapes communication — who needs to know now versus who can wait for the postmortem — and it often decides whether I mitigate immediately with something blunt like a rollback, versus taking a bit more time to actually understand root cause first."

### Follow-up Questions
- How would you assess blast radius if your monitoring itself is partially degraded during the incident?
- What's the difference in response between a SEV-1 and a SEV-3, in your own words?
- Why might you choose to mitigate immediately even without a confirmed root cause?

### Key Points
- Blast radius = scope of impact (instances/regions/services/users affected).
- Drives severity classification, urgency, and who gets notified.
- Bigger blast radius often justifies immediate blunt mitigation (rollback) over careful root-causing first.

---

## Q5. Walk me through the "First 5 Minutes" of responding to a page for a production incident.

**Difficulty:** 🔴 Production

### What the interviewer is testing
Composure and correct triage priorities under real time pressure — a frequent scenario-based question.

### Expected Answer
Acknowledge the alert so others know it's being handled. Confirm the symptom is real using a dashboard/direct check, not just the alert text. Do a fast blast-radius check. Check for very recent changes (deploys in the last hour are the highest-probability cause). Communicate status if others are impacted or asking. Only then move into deeper investigation.

### Strong Interview Answer
"First, acknowledge the alert so it's visibly being handled and doesn't page someone else redundantly. Then confirm it's real — pull up the actual dashboard or run a direct check rather than trusting the alert text alone, since false positives happen. Quick blast-radius check — is this small or is it spreading. Then I immediately check for anything that changed recently, especially deploys in the last hour, because that's disproportionately often the actual cause. If others are impacted or already asking, a short status update goes out early, even just 'investigating, will update in 10 minutes' — that alone reduces chaos. Only after that do I move into deeper, more time-consuming investigation."

### Follow-up Questions
- Why is checking recent deploys prioritized so early, before deeper investigation?
- What would you actually say in that first status update if you don't know the cause yet?
- How do you avoid tunnel-visioning into deep investigation before doing this initial triage?

### Key Points
- Acknowledge → confirm it's real → quick blast-radius check → check recent changes → early communication → then deep investigation.
- Recent deploys/changes are the single highest-value early check.
- An early, honest "still investigating" update is more valuable than going silent while digging.

---

## Q6. What's the "5 Whys" technique, and can you walk through an example applied to a real incident?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Root-cause analysis depth — whether you stop at the surface symptom or dig to the actual systemic cause.

### Expected Answer
5 Whys is repeatedly asking "why" to a surface symptom until you reach a true root cause rather than stopping at the first plausible explanation. Example: site down → why? backend pods crashing → why? OOMKilled → why? memory limit too low for actual load → why? load increased after a marketing campaign wasn't communicated to the infra team → why? no process exists for infra to be notified of expected traffic spikes. The real fix is a process/communication gap, not just "raise the memory limit."

### Strong Interview Answer
"5 Whys means not stopping at the first answer that sounds plausible — you keep asking why until you hit something systemic. Say the site went down: why? Backend pods were crashing. Why? They were getting OOM-killed. Why? The memory limit was too low for the actual load. Why? Load had spiked because of a marketing campaign. Why did that cause an incident? Because infra never knew the campaign was happening, so nobody scaled ahead of time. The real root cause isn't 'memory limit too low' — raising it just treats the symptom for this one event. The actual fix is a process gap: there's no mechanism for marketing to notify infra of expected traffic spikes ahead of time. That's what actually prevents recurrence."

### Follow-up Questions
- How do you know when to stop asking 'why' — what's a genuine root cause versus going too far?
- What's the risk of a postmortem that stops at the first technical cause instead of digging further?
- How would you turn that final 'why' into an actual action item?

### Key Points
- Keep asking "why" past the first plausible technical answer to find the systemic root cause.
- Often the deepest "why" is a process/communication gap, not a purely technical one.
- The fix should address that root cause, not just patch the surface symptom for next time.

---

## Q7. What goes into a good postmortem, and why should it be blameless?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Organizational/cultural maturity around incidents, not just technical process.

### Expected Answer
A good postmortem includes: timeline of events, impact/blast radius, root cause (ideally via 5 Whys or similar), what went well, what went poorly, and concrete action items with owners. Blameless means focusing on systemic/process causes rather than individual fault — because people acted reasonably given the information and incentives they had at the time; blame discourages honest reporting and hides the real systemic issues that would actually prevent recurrence.

### Strong Interview Answer
"A good postmortem has a clear timeline, the actual impact and blast radius, root cause dug out properly rather than stopped at the surface, an honest account of what went well and what didn't during the response itself, and concrete action items with real owners and deadlines — not just 'be more careful.' Blameless matters because if people are afraid a postmortem will single them out, they under-report, soften details, or avoid volunteering the full picture, and you lose the exact information that would actually prevent it happening again. Almost every incident, when you dig in, traces back to a reasonable decision made with incomplete information or a systemic gap — a missing alert, a missing process — not an individual being careless, so that's where the postmortem should focus."

### Follow-up Questions
- How would you write an action item so it's actually likely to get done, rather than forgotten?
- What's the difference between an incident timeline and a root cause section?
- How would you handle a postmortem where the root cause genuinely was a human error in judgment?

### Key Points
- Postmortem contents: timeline, impact, root cause, what went well/poorly, concrete owned action items.
- Blameless focus = systemic/process causes, not individual fault — encourages honest, complete reporting.
- Even "human error" root causes usually point to a missing safeguard or process, which is the real fix.

---

## Q8. How do you decide the severity (SEV-1 through SEV-4) of an incident, and what changes in response at each level?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you understand severity classification drives concrete operational behavior, not just a label.

### Expected Answer
Severity is generally based on user impact and scope: SEV-1 = full outage or critical functionality broken for all/most users, all-hands urgent response, constant communication. SEV-2 = significant but partial impact (a feature broken, a subset of users), urgent but more contained response. SEV-3 = minor impact, degraded but functioning, normal-hours response is fine. SEV-4 = negligible/cosmetic impact, tracked but not urgent. Higher severities trigger more people being paged, more frequent status updates, and a formal postmortem requirement.

### Strong Interview Answer
"I classify severity by actual user impact and scope. SEV-1 is a full outage or something critical broken for essentially everyone — that pulls in whoever's needed immediately, with frequent status updates until resolved, and always gets a postmortem. SEV-2 is significant but partial — a specific feature down, or a subset of users affected — still urgent, but the response can be more contained. SEV-3 is a minor, degraded-but-functioning issue that doesn't need to wake anyone up outside working hours. SEV-4 is negligible or cosmetic, just tracked as a normal ticket. The severity level isn't just a label — it directly decides who gets paged, how often updates go out, and whether a formal postmortem is mandatory."

### Follow-up Questions
- How would you reclassify severity mid-incident if the impact turns out smaller or larger than first thought?
- Who typically decides the severity level — is it automatic or a judgment call?
- Why does even a SEV-4 get tracked rather than just fixed silently?

### Key Points
- Severity is based on scope and user impact, not just how alarming the symptom looks.
- Each level maps to concrete response behavior: who's paged, update frequency, postmortem requirement.
- Severity can and should be reassessed as more information comes in during the incident.

---

## Q9. A database connection failure is causing errors across multiple services. How do you approach this incident?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Applying the layered framework to a shared-dependency incident, and understanding cascading failure.

### Expected Answer
Recognize this as a shared-dependency incident — the blast radius spans every service depending on that database, so it's likely SEV-1/SEV-2 by default. Confirm the database itself is actually the problem (not a network path issue between services and the DB) — check DB health/connection pool exhaustion/CPU/replication lag. Check recent changes to the DB (migration, config, failover). Mitigate at the DB layer if possible (failover, kill a runaway query, scale connections) rather than trying to fix each dependent service individually.

### Strong Interview Answer
"Because it's a shared dependency, I immediately treat blast radius as wide — every service depending on that database is affected, so this is high severity by default, not something to underestimate because it 'looks like' just a connection error. I'd confirm it's genuinely the database and not a network path issue between the services and the DB — checking DB-side health directly: is it up, is connection pool exhausted, is there a runaway query eating CPU, is there replication lag if it's a replica issue. I'd check for anything that changed recently at the DB layer — a migration, a config change, a failover event. And critically, I fix it at the database layer, not by chasing each individual dependent service's errors separately, since those are all downstream symptoms of the same root cause."

### Follow-up Questions
- How would you distinguish connection pool exhaustion from the database genuinely being down?
- Why might killing a single runaway query resolve errors across many services at once?
- How would you prevent one misbehaving service from exhausting shared DB connections for everyone else?

### Key Points
- Shared-dependency incidents have wide blast radius by nature — treat severity accordingly early.
- Confirm the DB itself is the problem, not the network path to it, before acting.
- Fix at the shared dependency layer — don't chase symptoms in each downstream service separately.

---

## Q10. What's the difference between "mitigation" and "root cause fix," and why might you deliberately do the former without the latter during an active incident?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Practical incident triage judgment — speed of recovery vs. completeness of understanding.

### Expected Answer
Mitigation stops user-facing impact quickly (rollback, restart, failover, scale up) without necessarily understanding or fixing the underlying cause. A root cause fix addresses why it happened, often taking longer and requiring careful investigation. During an active incident, restoring service quickly is usually the priority — mitigate first, understand and permanently fix afterward, especially when a fast known-good action (like rollback) is available.

### Strong Interview Answer
"Mitigation is about stopping the bleeding for users right now, even if I don't yet fully understand why it happened — rolling back a bad deploy, failing over to a healthy replica, scaling up to relieve pressure. A root cause fix actually addresses the underlying reason it happened, which usually takes real investigation time. During an active incident, especially anything with meaningful user impact, I prioritize mitigation — if I have a fast, known-safe action like rollback available, I take it immediately rather than spending that time root-causing while users are still affected. The root cause investigation and permanent fix happen afterward, calmly, once service is stable, and that's exactly what the postmortem process is for."

### Follow-up Questions
- Give an example where mitigating without understanding root cause first could actually make things worse.
- How do you decide between 'mitigate now' and 'take a bit more time to understand it properly first'?
- Why is it still important to eventually find root cause even after mitigation has already resolved user impact?

### Key Points
- Mitigation = fast action to stop user impact (rollback, failover, scale) without full understanding required.
- Root cause fix = addressing why it happened, usually slower, done calmly post-incident.
- Prioritize mitigation during active user impact when a safe fast action exists; root-cause afterward.

---
