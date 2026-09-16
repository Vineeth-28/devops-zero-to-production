# Incident: Pod Pending

## 1. Incident Summary
A pod has been created but the scheduler cannot place it on any node, so
it stays in `Pending` state indefinitely — never even starting a container.

## 2. Symptoms
- `kubectl get pods` shows `Pending` with 0/1 Ready, no restarts (it hasn't
  even started)
- New deployments/scale-ups don't come online
- May affect only new pods while existing ones keep running fine

## 3. Impact
No new capacity comes online — during a scale-up or rolling deploy this
can mean the service can't handle load or a rollout gets stuck partway.

## 4. Possible Causes
- Insufficient CPU/memory available on any node to satisfy the pod's requests
- No node matches a required `nodeSelector` or `affinity` rule
- A `taint` on all candidate nodes with no matching `toleration` on the pod
- An unbound PersistentVolumeClaim (no PV available/provisionable)
- Pod requests exceed the largest node's total capacity (will never schedule, ever)

## 5. First 5 Minutes
1. Confirm scope: is it one pod or every new pod in the cluster/namespace?
2. `kubectl describe pod <pod>` and read the Events section — the
   scheduler explains the reason directly
3. Check cluster capacity: `kubectl top nodes` / `kubectl describe nodes`
4. Check for recent changes to resource requests, node selectors, or
   taints/tolerations
5. Check PVC status if the pod uses persistent storage

## 6. Troubleshooting Flow
```
Pod Pending
      |
kubectl describe pod (read Events)
      |
Scheduler event says what?
      |
   "Insufficient cpu/memory" --------------------+
      |                                          |
Check node capacity vs pod requests        "node(s) didn't match
      |                                     node selector/affinity"
Scale cluster or reduce requests                 |
                                            Check nodeSelector/affinity
                                            rules vs actual node labels
                                                  |
   "node(s) had taints..."                       |
      |                                          |
Check tolerations vs node taints                 |
                                                  |
                              "pod has unbound immediate PVCs"
                                                  |
                                   Check PVC/StorageClass/PV availability
                                                  |
                                          Find root cause
```

## 7. Commands

```bash
kubectl describe pod <pod>
```
**What it checks:** scheduler events explaining exactly why placement failed.
**Why we run it:** this is the single most useful command for Pending pods
— the scheduler tells you the reason in plain text.
**What to look for:** `FailedScheduling` events with a specific reason
(`Insufficient cpu`, `node(s) didn't match Pod's node affinity/selector`,
`node(s) had untolerated taint`, `pod has unbound immediate PersistentVolumeClaims`).

```bash
kubectl get nodes
kubectl describe nodes
```
**What it checks:** node status, capacity, allocatable resources, and taints.
**Why we run it:** confirms whether there's genuinely enough capacity/
matching nodes cluster-wide.
**What to look for:** `Allocatable` resources close to fully consumed
across all nodes; taints not matched by your pod's tolerations.

```bash
kubectl top nodes
```
**What it checks:** current real-time resource usage per node.
**Why we run it:** distinguishes "nodes report enough allocatable capacity
on paper" from "nodes are actually full right now".
**What to look for:** nodes near 100% CPU/memory usage already.

```bash
kubectl get pvc
kubectl describe pvc <pvc>
```
**What it checks:** PersistentVolumeClaim binding status.
**Why we run it:** an unbound PVC (no matching PV, or StorageClass
misconfigured/absent) blocks scheduling for pods that reference it.
**What to look for:** `Pending` status on the PVC itself, with an event
explaining why (no matching PV, provisioner error).

## 8. How to Interpret the Output
- Event: `0/5 nodes are available: 5 Insufficient cpu` → literally not
  enough CPU capacity anywhere; either scale the cluster or reduce the
  pod's requests.
- Event: `didn't match Pod's node affinity/selector` → check the exact
  label the pod requires against `kubectl get nodes --show-labels`.
- Event: `had untolerated taint {key: value: effect}` → the pod needs a
  matching `tolerations` entry, or you need a node without that taint.
- PVC stuck `Pending` with `waiting for a volume to be created` → check
  the StorageClass provisioner and cloud-provider quota/permissions.

## 9. Root Cause Examples
- A new deployment requests more CPU per replica than any single node has
  allocatable, and no autoscaler is configured to add larger nodes
- A pod's `nodeSelector` references a label (`disktype: ssd`) that no
  current node actually has
- Cluster autoscaler is disabled or hit its max node count during a legitimate scale-up
- StorageClass references a provisioner that lost cloud IAM permissions to create new volumes

## 10. Fix / Recovery
**Immediate mitigation:**
- Reduce the pod's resource requests temporarily if they were set too high by mistake
- Manually scale the node group if the autoscaler can't/won't add capacity fast enough
- Correct an obviously wrong `nodeSelector`/`affinity` value

**Permanent fix:**
- Right-size resource requests based on real usage data
- Fix cluster autoscaler configuration/limits so it can respond to genuine demand
- Correct StorageClass/provisioner configuration and permissions
- Align `tolerations` with the intended taint strategy, or fix mistaken taints

## 11. Verification
- `kubectl get pods` shows the pod transitions to `Running`/`Ready`
- `kubectl describe nodes` shows healthy allocatable headroom
- No further `FailedScheduling` events for new pods

## 12. Prevention
- Alert on sustained Pending pod count, not just individual pod state
- Keep cluster autoscaler limits ahead of realistic peak demand
- CI validation that resource requests are reasonable relative to node sizes
- Regularly audit node labels/taints against what workloads actually expect

## 13. Post-Incident Checklist
- [ ] Identified exact scheduler reason from `describe pod` events
- [ ] Confirmed cluster capacity or scheduling constraint as root cause
- [ ] Applied fix (capacity, selector, taint, or PVC)
- [ ] Confirmed pod reached Running/Ready
- [ ] Documented and, if resource-request-related, right-sized for the future

## 14. Interview Explanation
"Pending means the scheduler hasn't been able to place the pod on any
node at all — it hasn't even started. `kubectl describe pod` and reading
the Events section is the fastest path to the answer because the
scheduler states its reason directly: insufficient resources, an
unsatisfied node selector or affinity rule, an untolerated taint, or an
unbound PVC. From there the fix is specific to that reason — add
capacity, fix a label mismatch, add a toleration, or fix storage
provisioning."
