# Upgrade & Rollback Commands

### `helm upgrade <release> <chart>`
- **Purpose:** Apply a new revision to an existing release.
- **Syntax:** `helm upgrade <release-name> <chart-path> [-f values.yaml]`
- **Example:** `helm upgrade backend ./charts/backend -f values-production.yaml`
- **Production use:** Deploying a new version to an already-installed service. Fails if release doesn't exist.

### `helm upgrade --install`
- **Purpose:** Upgrade if the release exists, install if it doesn't.
- **Syntax:** `helm upgrade --install <release-name> <chart-path> [-f values.yaml]`
- **Example:**
  ```bash
  helm upgrade --install backend ./charts/backend \
    -f values-production.yaml \
    --set image.tag=$CI_COMMIT_SHA
  ```
- **Production use:** The standard command in CI/CD pipelines — idempotent, works on first deploy and every deploy after.

### `helm upgrade --install --atomic`
- **Purpose:** Automatically roll back if the upgrade fails.
- **Syntax:** `helm upgrade --install <release> <chart> --atomic`
- **Example:** `helm upgrade --install backend ./charts/backend --atomic --timeout 5m`
- **Production use:** Prevents a broken deploy from leaving the release in a half-applied state — recommended for production pipelines.

### `helm history <release>`
- **Purpose:** List revisions with status.
- **Syntax:** `helm history <release-name>`
- **Example:** `helm history backend`
- **Production use:** Find the revision number to roll back to.

### `helm rollback <release> <revision>`
- **Purpose:** Revert a release to a previous revision.
- **Syntax:** `helm rollback <release-name> <revision-number>`
- **Example:** `helm rollback backend 2`
- **Production use:** Fast recovery from a bad production deploy.
