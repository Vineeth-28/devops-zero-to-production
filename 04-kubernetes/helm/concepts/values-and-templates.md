# Values and Templates

## values.yaml

```yaml
replicaCount: 3

image:
  repository: myrepo/backend
  tag: "1.0.0"

service:
  type: ClusterIP
  port: 80
```

This file defines the **configurable knobs** of the chart. It has no effect on its own — it only matters when referenced inside `templates/`.

## Accessing Values in Templates

| YAML path | Template reference |
|---|---|
| `replicaCount` | `{{ .Values.replicaCount }}` |
| `image.repository` | `{{ .Values.image.repository }}` |
| `image.tag` | `{{ .Values.image.tag }}` |

## How Values Become Kubernetes YAML

**Template (`templates/deployment.yaml`):**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: {{ .Values.replicaCount }}
  template:
    spec:
      containers:
        - name: backend
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```

**Rendered output (after `helm template` / `helm install`):**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: backend
          image: "myrepo/backend:1.0.0"
```

## Mental Model

```
values.yaml (data)
     +
templates/*.yaml (structure with placeholders)
     ↓
   Helm engine
     ↓
Plain Kubernetes YAML
     ↓
kubectl apply (done internally by Helm)
```

Helm never sends `{{ }}` syntax to Kubernetes — by the time the API server sees anything, it's 100% valid plain YAML.
