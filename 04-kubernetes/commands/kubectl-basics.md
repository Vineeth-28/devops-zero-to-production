# kubectl Basics

## What it is
`kubectl` is the CLI used to talk to the Kubernetes API Server — every action
(create, read, update, delete, debug) goes through it.

## Why we use it
It is the primary interface between a DevOps engineer and a cluster. Almost
all cluster operations in this handbook use `kubectl`.

## Core syntax

```bash
kubectl <verb> <resource> <name> [flags]
```

## Cluster & context

```bash
kubectl cluster-info
kubectl config get-contexts
kubectl config current-context
kubectl config use-context <context-name>
kubectl version --short
```

## Basic resource operations

```bash
kubectl get <resource>
kubectl get <resource> -o wide
kubectl get <resource> -n <namespace>
kubectl get <resource> --all-namespaces
kubectl describe <resource> <name>
kubectl create -f file.yaml
kubectl apply -f file.yaml
kubectl delete -f file.yaml
kubectl delete <resource> <name>
kubectl edit <resource> <name>
```

## Output formats

```bash
kubectl get pods -o yaml
kubectl get pods -o json
kubectl get pods -o wide
kubectl get pods -o name
```

## Common mistakes

- Running commands against the wrong namespace (forgetting `-n`).
- Using `create` on a resource that already exists instead of `apply`
  (`apply` is idempotent, `create` is not).
- Editing a live resource with `kubectl edit` instead of updating the YAML
  and re-applying — changes get lost the next time someone applies the file.

## Production considerations

- Always confirm `kubectl config current-context` before running destructive
  commands — running against the wrong cluster is a common incident cause.
- Prefer `kubectl apply -f` (declarative) over `kubectl create`/`kubectl
  edit` (imperative) so the YAML in Git stays the source of truth.

## Interview questions

- What's the difference between `kubectl apply` and `kubectl create`?
- How do you switch between clusters/contexts?
- Why is declarative management (`apply`) preferred over imperative commands
  in production?
