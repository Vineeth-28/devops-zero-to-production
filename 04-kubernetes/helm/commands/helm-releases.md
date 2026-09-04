# Release Commands

### `helm install <release> <chart>`
- **Purpose:** Install a chart as a new release.
- **Syntax:** `helm install <release-name> <chart-path> [-f values.yaml]`
- **Example:** `helm install backend ./charts/backend -f values-dev.yaml`
- **Production use:** First-ever deploy of a service (afterward, prefer `upgrade --install`).

### `helm list` (`helm ls`)
- **Purpose:** List releases in the current (or all) namespace(s).
- **Syntax:** `helm list [-n <namespace>] [-A]`
- **Example:** `helm list -n production`
- **Production use:** Quick check of what's currently deployed and its status/revision.

### `helm status <release>`
- **Purpose:** Show current state of a release (status, revision, notes).
- **Syntax:** `helm status <release-name>`
- **Example:** `helm status backend`
- **Production use:** First command to run when investigating "is this deployed correctly?"

### `helm uninstall <release>`
- **Purpose:** Remove a release and its Kubernetes resources.
- **Syntax:** `helm uninstall <release-name>`
- **Example:** `helm uninstall backend`
- **Production use:** Decommissioning a service — use carefully, this deletes resources.

### `helm history <release>`
- **Purpose:** Show all revisions of a release.
- **Syntax:** `helm history <release-name>`
- **Example:** `helm history backend`
- **Production use:** Identify which revision number to roll back to.

### `helm get values <release>`
- **Purpose:** Show the values currently in effect for a release.
- **Syntax:** `helm get values <release-name>`
- **Example:** `helm get values backend`
- **Production use:** Confirm exactly what config is live, without guessing from files.

### `helm get manifest <release>`
- **Purpose:** Show the fully rendered Kubernetes YAML actually applied for a release.
- **Syntax:** `helm get manifest <release-name>`
- **Example:** `helm get manifest backend`
- **Production use:** Ground-truth check of what Kubernetes objects Helm created.

### `helm get all <release>`
- **Purpose:** Show values, manifest, hooks, and notes together.
- **Syntax:** `helm get all <release-name>`
- **Example:** `helm get all backend`
- **Production use:** Full-picture debugging in one command.
