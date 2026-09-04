# Charts

A **Chart** is a Helm package — a collection of files describing a related set of Kubernetes resources.

```
Chart = Blueprint / Package
```

## What a Chart Contains

- Metadata (`Chart.yaml`)
- Default configuration (`values.yaml`)
- Templated Kubernetes manifests (`templates/`)
- Optional sub-charts / dependencies (`charts/`)
- Optional helper functions (`_helpers.tpl`)
- Optional post-install message (`NOTES.txt`)

## Where Charts Come From

1. **You create one** — `helm create <name>`
2. **From a public repo** — e.g. Bitnami, `helm repo add bitnami https://...`
3. **From a packaged `.tgz`** file

## Chart vs Release (again — this distinction is asked constantly in interviews)

```
Chart    → the package (reusable, versioned, no runtime state)
Release  → a specific installed instance of that chart in a cluster,
           with specific values, and its own upgrade/rollback history
```

Example: the same `backend` chart can be installed as:

- `backend-dev` (release 1, in `dev` namespace)
- `backend-staging` (release 1, in `staging` namespace)
- `backend-prod` (release 7, in `prod` namespace)

One chart. Three independent releases.
