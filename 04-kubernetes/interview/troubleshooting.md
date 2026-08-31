# Interview Questions — Troubleshooting

**Q1. A Pod is stuck `Pending` — walk through your investigation.**
Expected answer points:
- `kubectl describe pod` -> read Events.
- Check for insufficient CPU/memory, PVC Pending, nodeSelector/affinity
  mismatch, taints without matching tolerations, or no nodes at all.

**Q2. A Pod is in `CrashLoopBackOff` — what do you check, in order?**
Expected answer points:
- `kubectl logs` (current), then `kubectl logs --previous` (last crash),
  then `kubectl describe pod` for Events.
- Look for application bugs, wrong/missing env vars, missing
  ConfigMap/Secret, dependency connection failures, wrong start command.

**Q3. What causes `ImagePullBackOff`, and how do you confirm the exact
cause?**
Expected answer points:
- Wrong image name/tag, missing/incorrect registry credentials
  (`imagePullSecrets`), or network/registry access issues.
- `kubectl describe pod` shows the exact pull error message.

**Q4. What does OOMKilled mean, and what would you check before just
raising the memory limit?**
Expected answer points:
- Container exceeded its memory `limits` and was killed by the OOM killer.
- Check actual usage trend with `kubectl top pod` — could be a real memory
  leak rather than a limit that's simply too low.

**Q5. A Pod is `Running` but shows `0/1 Ready` — what's happening, and how
do you debug it?**
Expected answer points:
- Readiness probe is failing — container is alive but not considered ready
  for traffic.
- Check probe path/port correctness, real dependency availability, and
  timing (`initialDelaySeconds` vs actual startup time).

**Q6. Walk through the master production troubleshooting flow from memory.**
Expected answer points:
- `get pods` -> identify abnormal Pods -> `describe pod` -> `logs` ->
  `logs --previous` -> `get events` -> check Service -> check
  EndpointSlices -> check ConfigMaps/Secrets -> check PVC -> check Nodes.
- Emphasize working top-to-bottom rather than jumping to a guess.
