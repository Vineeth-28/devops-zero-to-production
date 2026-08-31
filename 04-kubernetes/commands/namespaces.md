# Namespace Commands

## What it is
Commands to create and work with Namespaces — logical partitions inside a
single cluster.

## Why we use it
Namespaces isolate resources between teams/environments (e.g. `staging` vs
`production`) inside one cluster.

## Commands

```bash
kubectl get namespaces
kubectl create namespace <name>
kubectl apply -f namespace.yaml
kubectl delete namespace <name>

kubectl get pods -n <namespace>
kubectl get all -n <namespace>

kubectl config set-context --current --namespace=<namespace>
```

## Example

```bash
kubectl config set-context --current --namespace=production
kubectl get pods
```
Switches the default namespace for the current context so you stop typing
`-n production` on every command.

## Common mistakes

- Forgetting which namespace is currently "active" and running commands
  against the wrong one.
- Deleting a namespace without realizing it deletes every resource inside
  it.

## Production considerations

- Namespaces are not a hard security boundary by themselves — combine with
  RBAC and NetworkPolicies for real isolation.

## Interview questions

- What is the purpose of Namespaces?
- Does deleting a Namespace delete everything inside it?
- Are Namespaces a security boundary on their own?
