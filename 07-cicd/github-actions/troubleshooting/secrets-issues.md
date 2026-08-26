# Secrets & Configuration Issues

## Secret shows up empty (`***` never even appears)

- Secret name mismatch — `${{ secrets.API_TOKEN }}` is case-sensitive and
  must match exactly what's configured in the repo/org settings.
- Secret defined at the wrong level — an organization secret may be
  restricted to specific repositories; a repo-level secret won't be visible
  to workflows in a different repo.
- Using a secret in a `pull_request` workflow triggered from a fork — forked
  PRs do not get access to repository secrets by default (security
  boundary). Use `pull_request_target` carefully, or split the secret-using
  steps into a separate workflow triggered after merge.

## Secret appears masked but the step still fails

- The masked value (`***`) confirms GitHub is redacting it — the failure is
  in how the value is *used* (wrong format, expired token, wrong registry
  URL), not in the secret handling itself.

## Environment-scoped secrets not available

- Secrets scoped to a GitHub **Environment** (e.g. `production`) are only
  available to jobs that declare `environment: production` — a job without
  that key cannot read them, even in the same workflow.

## General secret hygiene

- Never `echo` a secret directly — even though GitHub masks known secret
  values in logs, echoing defeats the purpose and can leak derived values.
- Rotate tokens regularly and scope them to the minimum required permission
  (e.g. a registry push-only token instead of a full account token).
- Prefer OIDC (`permissions: id-token: write`) over long-lived cloud
  credentials when deploying to AWS/Azure/GCP — no static secret to leak.
