# Final DevOps Mock Interview

A full mock interview simulating a real Senior/Mid-level DevOps Engineer loop: 6 rounds plus one large production incident scenario. Use this as a timed, closed-book self-test before treating yourself as interview-ready. Detailed answers for every individual topic live in the topic-specific files (`linux.md`, `kubernetes.md`, etc.) — this file is deliberately questions-first so you can practice actually answering out loud before checking yourself.

**How to use this file:** Go round by round. Answer out loud, in 30-90 seconds per question, before reading the "Expected Concepts" line. Don't skip to the answer.

---

## Round 1 — Fundamentals (15 questions, rapid, 🟢/🟡)

1. What's the difference between `df` and `du`? — *Expected: filesystem-level vs. directory-tree usage; deleted-but-open-file mismatch.*
2. `chmod` vs `chown`? — *Expected: permissions vs. ownership; both can cause "Permission denied."*
3. Merge vs rebase? — *Expected: non-destructive/shared-safe vs. linear/rewrites history, unsafe once shared.*
4. Reset vs revert? — *Expected: rewrites history (local only) vs. new undo commit (safe for shared/pushed).*
5. Image vs container? — *Expected: static read-only template vs. running instance with a writable layer.*
6. Volumes vs bind mounts? — *Expected: Docker-managed/portable vs. direct host path mapping.*
7. Pod vs Deployment? — *Expected: smallest deployable unit vs. controller managing ReplicaSets/desired state for Pods.*
8. Service vs Ingress? — *Expected: L4 stable virtual IP/load balancing vs. L7 HTTP-aware routing.*
9. Readiness vs liveness probe? — *Expected: traffic gate (removed from endpoints) vs. restart trigger.*
10. ConfigMap vs Secret? — *Expected: both inject config; Secret is base64-encoded not encrypted by default.*
11. Terraform plan vs apply? — *Expected: dry-run diff vs. actual execution.*
12. Ansible command vs shell module? — *Expected: no shell involved (safer, predictable) vs. full shell features (pipes/redirects).*
13. CI vs CD (Delivery vs Deployment)? — *Expected: integrate+test vs. always-releasable-with-human-gate vs. fully automatic to prod.*
14. Prometheus Counter vs Gauge? — *Expected: monotonically increasing (use rate()) vs. freely up/down, read directly.*
15. 502 vs 503 vs 504? — *Expected: bad/invalid upstream response vs. no healthy backend/refused vs. backend reachable but too slow.*

---

## Round 2 — Practical / Hands-On (15 questions, 🟡)

1. Walk me through resolving a Git merge conflict end to end.
2. How would you build a multi-stage Dockerfile and explain why each stage exists?
3. Write (verbally) a PromQL query for p95 latency from a histogram metric.
4. How do you safely clean up Docker disk usage without breaking running containers?
5. Walk through `kubectl apply` from command to running Pod, naming every component involved.
6. How would you configure `helm upgrade --install` safely for a CI/CD pipeline?
7. How do you import an existing manually-created resource into Terraform?
8. Write an Ansible task using `command` safely with an idempotency guard (`creates:`).
9. How would you set up `depends_on` with a real health check in Docker Compose, not just container-started?
10. How would you structure a Jenkins Declarative Pipeline with build/test/deploy stages?
11. Design a GitHub Actions workflow using `matrix` to test across 3 Node versions.
12. How do you find which process is holding a deleted-but-still-open file on Linux?
13. How would you cherry-pick a hotfix from `main` onto a release branch?
14. Write a PromQL query for error rate as a percentage.
15. How would you configure a Kubernetes readiness probe to actually reflect app health, not just process-up?

---

## Round 3 — Troubleshooting (15 questions, 🔴)

1. A Pod is in `CrashLoopBackOff` — what's your first command and reasoning?
2. `df -h` shows free space but you get "No space left on device" — what's happening?
3. A Service has no endpoints despite Pods showing `Running` — what do you check?
4. A container exits immediately after starting — walk through your debugging.
5. `terraform apply` fails partway through — what's your recovery process?
6. An Ansible run reports a host as `UNREACHABLE` — how is that different from `FAILED`, and where do you look?
7. A `docker build` fails partway — how do you isolate the failing step?
8. A `helm upgrade` reports success but the app is broken — what's the gap, and how do you catch it?
9. High CPU on a production server — walk through your investigation from first command.
10. A GitHub Actions workflow that worked yesterday fails today with zero code changes — what do you investigate?
11. SSH fails with "Connection refused" — what layer does that point to, versus "Connection timed out"?
12. A CI/CD pipeline shows a cascading failure across multiple stages — how do you find the true root cause?
13. `OOMKilled` keeps recurring on a Pod — how do you tell if it's a leak or under-provisioning?
14. A Deployment rollout reports "succeeded" but users are seeing errors — what's the gap?
15. Logs show errors right after a deploy — how do you confirm the deploy actually caused it?

---

## Round 4 — Production Scenarios (15 questions, 🔴)

1. Users report the site is down. Walk me through your first 5 minutes.
2. A bad commit was pushed to a shared branch others have pulled — how do you fix it, and why not `reset`?
3. You discover a secret was accidentally committed to a public repo — what's your immediate priority, and what's the full remediation?
4. A database connection failure is causing errors across multiple unrelated services — how do you approach it?
5. Production disk is full — walk through safe recovery, not just "delete things."
6. A rolling deployment left the cluster with mixed old/new Pod versions serving simultaneously and inconsistent behavior — what happened and how do you stabilize it?
7. A liveness probe checking a database dependency caused every replica to restart at once during a brief DB blip — what's the actual design flaw and the fix?
8. An `ImagePullBackOff` is blocking a critical deploy under time pressure — how do you quickly bucket the cause?
9. You're mid-incident and don't yet know the root cause, but you have a safe rollback available — what do you do, and why?
10. A shared dependency (message queue, cache) degrades and causes cascading failures across many services — how do you scope blast radius quickly?
11. `git reset --hard` was run by mistake and needed commits are gone — how do you recover them, calmly?
12. Terraform state and real infrastructure have drifted after a manual emergency fix — how do you reconcile it deliberately?
13. A production Terraform `prevent_destroy` resource blocked an urgent, allegedly-necessary destroy — what's your process before overriding it?
14. Two engineers ran conflicting `terraform apply` at the same time without a remote backend — what went wrong structurally, and what should exist to prevent it?
15. An alert fired but turned out to be a false positive, and the team is now second-guessing all alerts — how do you address alert fatigue going forward?

---

## Round 5 — Architecture (10 questions, 🟡)

1. Draw (verbally) the full path: Developer commit → GitHub → CI → Docker build → Registry → Helm → Kubernetes → Prometheus → Grafana → Alertmanager. Explain each tool's responsibility.
2. Where does Terraform fit vs. Ansible in provisioning vs. configuring infrastructure, end to end?
3. Design the stages of a CI/CD pipeline for a containerized web app, start to finish.
4. How would you architect a Kubernetes Service + Ingress setup to route two different paths to two different backends?
5. What does an end-to-end request path look like through the "production layers" model, from user to database?
6. How would you design alerting (Prometheus rules → Alertmanager routing) so that a SEV-1 pages immediately but a SEV-3 doesn't wake anyone?
7. How would you structure Terraform for three environments (dev/staging/prod) without relying on workspaces alone?
8. How does a Helm chart with subcharts compose a multi-service application as one release?
9. How would you design a deployment strategy (rolling update settings) to minimize risk during a risky release?
10. What's your reasoning for build-once-deploy-everywhere (same image through staging and production) rather than rebuilding per environment?

---

## Round 6 — Rapid Fire (20 one-liners, 🟢)

Answer each in one sentence, no more.

1. What does `rate()` do that raw counter subtraction doesn't?
2. What's a Helm release revision?
3. What's the difference between `ps` and `top`?
4. What's `df -i` for?
5. What's a Terraform module?
6. What's an Ansible handler?
7. What does `needs` do in a GitHub Actions workflow?
8. What's the Jenkins Controller responsible for?
9. What's `histogram_quantile()` used for?
10. What's a NetworkPolicy's failure mode when misconfigured?
11. What's the risk of the `latest` Docker tag?
12. What does `git reflog` show you?
13. What's the difference between `requests` and `limits` in Kubernetes?
14. What's `create_before_destroy` for in Terraform?
15. What's a Shared Library in Jenkins?
16. What's the difference between Alertmanager inhibition and silencing?
17. What's `--atomic` do in `helm upgrade`?
18. What's the difference between a taint and a toleration?
19. What does `--force-with-lease` protect against that plain `--force` doesn't?
20. What's the blameless part of a postmortem actually protecting?

---

## Final Round — Large Incident Scenario

**Scenario (read once, then respond as if live):**

> It's 2:47 PM. Your monitoring fires a SEV-1 page: error rate on the checkout service has jumped from 0.2% to 38% over the last 4 minutes, and it's climbing. Customer support is already getting complaints. A deploy to the checkout service went out 12 minutes ago. The checkout service depends on a payments API and a Postgres database. Grafana shows checkout Pod CPU and memory look normal. `kubectl get pods` shows all checkout Pods as `Running` and `Ready`. The load balancer shows a mix of 200s and 502s.

**Walk through your full response, out loud, covering:**

1. Your first 3 actions in the first 2 minutes.
2. How you'd determine blast radius and severity.
3. Given the timing, what's your leading hypothesis and why?
4. What specific evidence (which dashboards, which commands, in what order) would you pull to confirm or rule that out?
5. Given `Running`/`Ready` Pods but a mix of 502s, what layer does that point you toward, and why doesn't "Ready" rule it out?
6. What's your mitigation decision — do you roll back immediately, or investigate further first? Justify it.
7. Once mitigated, what would go in your root cause investigation and eventual postmortem?
8. Name one concrete prevention action item this incident would produce.

### Expected Concepts (self-check after answering)

- **First actions:** acknowledge the page, confirm it's real via the actual dashboard (not just alert text), check the recent-deploy timing immediately — 12 minutes ago is a huge red flag given a SEV-1 that started right around then.
- **Blast radius/severity:** checkout is a critical, revenue-affecting path with climbing error rate — this is correctly a SEV-1; check if it's all users or a subset (e.g. one region, one payment method).
- **Leading hypothesis:** the recent deploy is the highest-probability cause given the timing correlation — investigate that first, not randomly across every dependency.
- **Evidence to pull:** deploy diff/changelog for what changed, checkout service logs around the error onset, load balancer/ingress logs for the 502 pattern specifically (which requests, which backend Pods), and payments API health (since checkout depends on it).
- **Why Running/Ready doesn't rule out the app layer:** readiness only reflects what the probe checks — a shallow probe can pass while the app is throwing errors on the actual checkout logic path (e.g. a bad code path introduced by the deploy, or a broken call to the payments API) that the probe never exercises.
- **Mitigation decision:** given strong timing correlation with a recent deploy and a safe rollback available, the right call is usually to roll back immediately rather than debug forward while checkout — a revenue-critical path — continues failing for real customers. Investigate root cause after stability is restored.
- **Root cause investigation:** diff exactly what the deploy changed, reproduce in staging if possible, check whether it touched the payments API integration or introduced a code path that only fails for actual checkout logic, not covered by the readiness probe.
- **Prevention action item:** a concrete, ownable fix — e.g. deepen the readiness/health check to actually exercise the payments API call path, add a canary/automatic rollback gate keyed to error-rate spikes immediately post-deploy, or require a manual verification step for checkout-service deploys specifically given its criticality.

---
