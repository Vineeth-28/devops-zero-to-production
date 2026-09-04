# Interview: Helm Basics

### What is Helm?
**Expected answer:** A package manager and release management tool for Kubernetes — it templates and tracks the deployment of Kubernetes resources.
**Key points:** Package manager analogy (npm/apt); adds templating + release tracking on top of raw YAML.
**Common mistake:** Saying Helm "runs" or "manages" the application at runtime — it doesn't; Kubernetes does.

### Why use Helm instead of raw Kubernetes YAML?
**Expected answer:** Raw YAML duplicates config across environments with no versioning or rollback; Helm templates one chart and tracks every install/upgrade as a revision.
**Key points:** Reusability, environment-specific values, release history, one-command rollback.
**Common mistake:** Claiming raw YAML "can't" be used in production — it can, Helm just makes it more maintainable at scale.

### What is a Chart?
**Expected answer:** A Helm package — a directory of files (Chart.yaml, values.yaml, templates/) describing a set of Kubernetes resources.
**Key points:** Blueprint, reusable, versioned independently of any specific deployment.
**Common mistake:** Confusing Chart with Release.

### What is a Release?
**Expected answer:** A specific installed instance of a Chart in a cluster, with its own values and revision history.
**Key points:** One chart → many possible releases (dev, staging, prod, or multiple installs of the same chart).
**Common mistake:** Thinking a release name must match the chart name.

### Chart vs Release?
**Expected answer:** Chart = package (static, reusable). Release = an installed, running instance of that package, tracked over time.
**Key points:** Analogy: Chart is like a Docker image, Release is like a running container from that image.
**Common mistake:** Treating them as interchangeable terms in conversation — interviewers listen for this distinction specifically.

### What is `Chart.yaml`?
**Expected answer:** Metadata file describing the chart itself — name, version, appVersion, description, dependencies.
**Key points:** `version` = chart version, `appVersion` = version of the app it deploys (these are independent).
**Common mistake:** Confusing chart `version` with `appVersion`.

### What is `values.yaml`?
**Expected answer:** Default configuration values for the chart, referenced in templates via `.Values`.
**Key points:** Can be overridden with `-f` (other values files) or `--set` (inline).
**Common mistake:** Thinking `values.yaml` alone does anything — it only matters when templates reference it.

### What are Helm templates?
**Expected answer:** Kubernetes YAML files with Go template syntax (`{{ }}`) instead of hardcoded values, rendered into plain YAML at install/upgrade time.
**Key points:** Located in `templates/`; rendered output is what's actually sent to Kubernetes.
**Common mistake:** Thinking Kubernetes understands `{{ }}` syntax directly — it never sees it; Helm renders first.
