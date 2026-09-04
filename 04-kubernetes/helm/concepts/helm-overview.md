# Helm Overview

## What is Helm?

Helm is a **package manager and release management tool for Kubernetes**.

Just like:
- `apt` / `yum` manage packages on Linux
- `npm` manages packages for Node.js

**Helm manages "packages" of Kubernetes resources**, called **Charts**.

## Why Does Helm Exist?

Without Helm, deploying an app to Kubernetes means writing and maintaining many raw YAML files:

```
deployment.yaml
service.yaml
configmap.yaml
secret.yaml
ingress.yaml
```

Problems this creates:

- Duplicated YAML across dev / staging / production
- Manual find-and-replace of image tags, replica counts, env vars
- No versioning of "what was deployed when"
- No easy rollback
- Hard to share/reuse across teams or projects

Helm solves this by introducing **templating + configuration + release tracking**.

## Raw Kubernetes YAML vs Helm Charts

| Raw YAML | Helm Chart |
|---|---|
| Static, hardcoded values | Templated, driven by `values.yaml` |
| Manually duplicated per environment | One chart, many values files |
| No release history | `helm history` tracks every revision |
| `kubectl apply` each file manually | `helm upgrade --install` handles everything |
| Manual rollback (re-apply old YAML) | `helm rollback <release> <revision>` |

## Core Terminology

```
Chart   = Blueprint / Package
Release = Installed instance of a Chart
```

A single Chart can be installed **multiple times** with different names/values — each installation is a separate **Release**.

```
Chart
    ↓
helm install
    ↓
Release
    ↓
Kubernetes resources
```

## Key Takeaway

Helm does not change *how* Kubernetes runs your app. It changes *how you manage the configuration* that describes your app to Kubernetes.
