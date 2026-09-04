# Releases

## What is a Release?

A **Release** is a specific installed instance of a Chart in a Kubernetes cluster.

```
Chart    → the package
Release  → chart + specific values, installed and tracked over time
```

## How Releases Are Tracked

Every time you `helm install` or `helm upgrade`, Helm stores a new **revision** for that release (as a Secret in the cluster by default).

```
backend
  revision 1 → v1  (initial install)
  revision 2 → v2  (upgrade: new image tag)
  revision 3 → v3  (upgrade: config change)
```

Each revision is a full snapshot — this is what makes `helm rollback` possible.

## Inspecting Releases

```bash
helm history backend
```
Shows every revision, when it happened, and its status (deployed, superseded, failed, rolled back).

```bash
helm status backend
```
Shows the **current** state of the release: status, revision number, notes (from `NOTES.txt`).

## Key Takeaway

Think of a release like a Git branch with commit history — `helm history` is `git log`, `helm rollback` is `git revert` to a prior state, and `helm status` is "what does HEAD look like right now."
