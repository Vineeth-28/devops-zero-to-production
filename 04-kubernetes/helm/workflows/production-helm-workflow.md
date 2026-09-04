# Production Helm Workflow (End-to-End)

```
GitHub
 ↓
CI/CD
 ↓
Docker Image
 ↓
Container Registry
 ↓
Helm Chart
 ↓
Kubernetes
 ↓
Deployment
 ↓
Pods
```

## The Three-Layer Split

```
Docker      → packages the application (code + runtime)
Helm        → packages/templates the Kubernetes deployment configuration
Kubernetes  → runs the application (scheduling, networking, scaling, self-healing)
```

This is the single most important distinction to be able to explain clearly in an interview: **Helm never runs anything** — it only produces the configuration that Kubernetes then acts on.

## End-to-End Steps

1. Code merged to `main`
2. CI runs tests
3. CI builds Docker image, tags with commit SHA
4. CI pushes image to registry
5. CI runs `helm upgrade --install` with `values-production.yaml` + the new image tag
6. Helm renders manifests and applies them via the Kubernetes API
7. Kubernetes performs a rolling update
8. Readiness probes gate traffic to new pods
9. Old pods terminated once new ones are healthy
10. `helm history` records the new revision for future rollback if needed
