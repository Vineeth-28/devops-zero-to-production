# Docker-in-CI Issues

## Docker build fails

- **Dockerfile not found**: confirm the build context and `-f` path match
  where the Dockerfile actually lives relative to `$GITHUB_WORKSPACE`.
- **COPY fails / file not found**: build context doesn't include the files
  you're copying — check `.dockerignore` isn't excluding something needed.
- **Base image pull fails**: registry rate limit (common with unauthenticated
  Docker Hub pulls) — log in even for pulling public images to raise limits.

## Docker login fails

- Secret name typo — `${{ secrets.DOCKERHUB_TOKEN }}` must exactly match the
  name configured in **Settings -> Secrets and variables -> Actions**.
- Using a password instead of an access token — most registries require a
  scoped token, not your account password.
- Token expired or revoked — regenerate and update the repository secret.

## Docker push fails

- **"denied: requested access to the resource is denied"**: the logged-in
  account doesn't have push rights to that repository/namespace.
- **Tag mismatch**: pushing `myapp:latest` without having built/tagged that
  exact name first — tags must be created locally before `docker push`.
- **Multi-arch build issues**: pushing a `buildx` multi-platform image
  requires `--push` as part of the build command, not a separate push step.

## Good practices baked into the workflows in this module

- Always tag with `${{ github.sha }}` for traceability, in addition to any
  floating tag like `latest`.
- Use `docker/login-action` instead of raw `docker login` with inline
  credentials.
- Scope workflow `permissions:` to only what's needed (e.g.
  `packages: write` when pushing to GitHub Container Registry).
