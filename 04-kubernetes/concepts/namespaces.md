# Namespaces

## What it is
A Namespace is a logical partition inside a single Kubernetes cluster —
a way to divide cluster resources between multiple teams, environments, or
applications.

## Why we use it
Without Namespaces, every object in a cluster shares one flat name space —
naming collisions and blast radius grow with cluster size. Namespaces group
related resources and scope names within that group.

## How it works

- Every Namespace-scoped object (Pods, Services, ConfigMaps, etc.) lives in
  exactly one Namespace.
- Cluster-scoped objects (Nodes, PersistentVolumes, Namespaces themselves)
  do **not** belong to a Namespace.
- `default` is used when none is specified; `kube-system` holds core
  cluster components.
- Typical production usage: `production`, `staging`, `development`
  namespaces, or one namespace per team/service.

## Example

```bash
kubectl create namespace staging
kubectl get pods -n staging
kubectl config set-context --current --namespace=staging
```

## Common mistakes

- Assuming Namespaces provide network isolation by default — they don't;
  Pods in different Namespaces can reach each other unless a NetworkPolicy
  says otherwise.
- Forgetting `-n <namespace>` and being confused why a resource "doesn't
  exist" (it's just in a different namespace).

## Production considerations

- Combine Namespaces with RBAC (`Role`/`RoleBinding`) and ResourceQuotas to
  get real isolation and prevent one team from starving cluster resources.

## Interview questions

- What isolation does a Namespace provide, and what doesn't it provide?
- What's the difference between Namespace-scoped and cluster-scoped
  resources?
- How would you limit resource usage per Namespace?
