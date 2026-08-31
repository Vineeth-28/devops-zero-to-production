# Autoscaling

## What it is
The Horizontal Pod Autoscaler (HPA) automatically adjusts the number of
Pod replicas in a Deployment based on observed metrics like CPU or memory
usage.

## Why we use it
Manually scaling up/down for traffic spikes doesn't react fast enough —
HPA continuously monitors and adjusts replica count automatically.

## How it works

- The HPA controller periodically checks the configured metric (e.g. CPU
  utilization) against Pods matching a target Deployment.
- If average usage is above the target, it scales replicas up (up to
  `maxReplicas`); if below, it scales down (not below `minReplicas`).
- Requires the Metrics Server (or a custom metrics pipeline) to be running
  in the cluster.

## Example

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: backend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: backend
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

```bash
kubectl get hpa
kubectl describe hpa backend-hpa
```

## Common mistakes

- Manually running `kubectl scale` on a Deployment that also has an HPA —
  the HPA will override manual changes on its next evaluation.
- Setting `requests` too low/high, since HPA CPU targets are calculated
  relative to `requests`, not absolute values.

## Production considerations

- Combine HPA with a Cluster Autoscaler (node-level) so scaling Pods
  doesn't just leave them Pending due to lack of node capacity.

## Interview questions

- What does HPA scale, and what does it need to function?
- What happens if you manually scale a Deployment that has an HPA attached?
- Why are CPU requests relevant to how HPA percentage targets behave?
