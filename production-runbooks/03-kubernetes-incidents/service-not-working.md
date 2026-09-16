# Incident: Service Not Working

## 1. Incident Summary
A Kubernetes Service exists but traffic isn't reaching the intended pods —
even though the pods themselves may be perfectly healthy. "Pod is Running"
does not mean "Service can route to it."

## 2. Symptoms
- Requests to the Service (or anything routed through it) fail or hang
- `kubectl get endpoints` shows fewer endpoints than expected, or none
- Pods show `Running` and even `Ready`, yet traffic doesn't arrive

## 3. Impact
Traffic can't reach a functioning application — from the user's
perspective indistinguishable from the app being down, even though the
app itself may be fine.

## 4. Possible Causes
- Service `selector` doesn't match the pod's actual labels (typo, label
  changed in a manifest refactor)
- Pods are Running but not Ready (readiness probe failing) — Endpoints
  only include Ready pods
- Service `targetPort` doesn't match the container's actual listening
  `containerPort`
- DNS resolution issue for the Service name (rare, but possible with
  CoreDNS problems)
- Wrong namespace — Service and pods exist in different namespaces
  without appropriate cross-namespace routing

## 5. Traffic Path
```
Client
  |
Service
  |
Selector
  |
Endpoints
  |
Pod
```
Every layer here can independently break the path. The Service's
`selector` determines which pods are candidates; only **Ready** pods
matching that selector actually appear in `Endpoints`; and `Endpoints`
is what kube-proxy actually uses to route traffic.

## 6. Troubleshooting Flow
```
Service not working
      |
kubectl get endpoints <service>
      |
Empty? ------------------------------------+
      |                                    |
   Yes                                     No (endpoints exist, still broken)
      |                                    |
kubectl get pods --show-labels             Check targetPort vs containerPort
kubectl get svc <service> -o yaml               |
(compare selector to pod labels)           Test directly: kubectl exec + curl
      |                                    to pod IP:containerPort
Labels mismatch? -> fix selector/labels          |
      |                                    Works directly but not via Service?
Pods Ready?                                -> check kube-proxy/CNI issue
      |
No -> check readiness probe (see CrashLoopBackOff / 503 runbooks)
      |
Find root cause
```

## 7. Commands

```bash
kubectl get svc <service> -o yaml
```
**What it checks:** the Service's `selector` and `targetPort` configuration.
**Why we run it:** the selector is the first thing to verify against actual pod labels.
**What to look for:** `selector: {app: myapp}` — note it exactly for comparison.

```bash
kubectl get pods --show-labels
```
**What it checks:** actual labels on running pods.
**Why we run it:** directly compares against the Service's selector to
spot a mismatch.
**What to look for:** a pod you expect to be routed to, missing the exact
label/value the Service selector requires.

```bash
kubectl get endpoints <service>
```
**What it checks:** the resolved list of pod IP:port pairs the Service will route to.
**Why we run it:** this is the ground truth — if it's empty or wrong, that
explains the symptom directly regardless of what looks fine elsewhere.
**What to look for:** `<none>`, or an unexpectedly short list.

```bash
kubectl exec -it <pod> -- curl localhost:<containerPort>
```
**What it checks:** whether the application inside the pod is actually
listening and responding on the expected port, independent of the Service.
**Why we run it:** isolates "the app itself is fine" from "the Service
routing is broken."
**What to look for:** a successful response here combined with a broken
Service points squarely at Service config (selector/targetPort), not the app.

## 8. How to Interpret the Output
- Endpoints empty, pod labels don't match selector → straightforward
  labeling bug; fix the Deployment's pod template labels or the Service selector.
- Endpoints empty, labels match, pods just not Ready → this is a readiness
  problem, not a Service problem — see the 503/CrashLoopBackOff runbooks.
- Endpoints populated and correct, but traffic still fails → check
  `targetPort` matches the container's actual listening port; also check
  for a CNI/kube-proxy issue if this is isolated to specific nodes.

## 9. Root Cause Examples
- A manifest refactor changed `app: my-app` to `app: myapp` in the
  Deployment template but not in the Service selector
- Service `targetPort: 8080` but the container actually listens on `3000`
  after an app config change
- Readiness probe checks a path that was renamed, so pods never register as Ready
- Service and Deployment accidentally deployed into different namespaces
  by a templating mistake

## 10. Fix / Recovery
**Immediate mitigation:**
- Correct the Service selector or pod labels to match, and reapply
- Fix `targetPort` to match the container's real listening port

**Permanent fix:**
- Add a CI check that validates Service selectors match Deployment pod-template labels
- Standardize label conventions across manifests to reduce refactor-induced mismatches
- Fix the underlying readiness issue if that's the actual cause

## 11. Verification
- `kubectl get endpoints <service>` shows the expected, healthy pod IPs
- Traffic through the Service succeeds (`curl` from another pod, or externally if applicable)
- No change needed on the application side confirms it was a routing issue, not an app bug

## 12. Prevention
- CI validation of selector/label consistency between Service and Deployment manifests
- Dashboards that specifically show endpoint count per Service, so a
  zero-endpoint state is visible before it's reported by users
- Keep readiness probes accurate and tested

## 13. Post-Incident Checklist
- [ ] Confirmed endpoints list (empty vs populated) as the starting diagnostic
- [ ] Compared Service selector to actual pod labels
- [ ] Verified targetPort vs containerPort alignment
- [ ] Fix applied and endpoints confirmed healthy
- [ ] Root cause documented (label, port, or readiness)

## 14. Interview Explanation
"'Pod is Running' doesn't mean the Service can route to it — Endpoints
only include pods that are both label-matched by the selector AND Ready.
So my first command is always `kubectl get endpoints`, since that's the
ground truth of what the Service will actually route to. If it's empty, I
compare the Service selector against actual pod labels next; if labels
match but endpoints are still empty, the pods aren't passing their
readiness probe, which is really a different runbook. If endpoints look
correct and it's still broken, I check for a targetPort/containerPort
mismatch."
