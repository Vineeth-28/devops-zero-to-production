# Helm Hooks

Hooks let you run Kubernetes resources (usually Jobs) at specific points in a release's lifecycle.

```
pre-install    → before resources are created
post-install   → after resources are created
pre-upgrade    → before an upgrade is applied
post-upgrade   → after an upgrade is applied
pre-delete     → before resources are deleted
post-delete    → after resources are deleted
```

## Why Hooks Exist

Common real-world uses:
- Running a database migration Job before a new app version starts (`pre-upgrade`)
- Sending a Slack notification after a successful install (`post-install`)
- Cleaning up external resources before uninstall (`pre-delete`)

## Example

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migrate
  annotations:
    "helm.sh/hook": pre-upgrade
spec:
  template:
    spec:
      containers:
        - name: migrate
          image: myrepo/backend:{{ .Values.image.tag }}
          command: ["npm", "run", "migrate"]
      restartPolicy: Never
```

## Caution

Hooks add complexity and a new failure mode (a hook Job can hang or fail and block the whole release). **Use them intentionally, not by default** — many teams handle migrations as a separate CI/CD step instead of a Helm hook, precisely to keep the release logic simple.
