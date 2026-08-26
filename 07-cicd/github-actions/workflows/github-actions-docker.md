# Workflow Notes — Docker Integration

Reference notes for `docker-ci.yml`.

## The Docker CI flow

```
Checkout -> Docker Login -> Docker Build -> Docker Tag -> Docker Push
```

## Key structural pieces

```yaml
permissions:
  contents: read
  packages: write
```
- Explicit least-privilege permissions instead of relying on the default
  `GITHUB_TOKEN` scope (which is broader unless configured otherwise).

```yaml
- uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}
```
- Always use the official login action instead of scripting
  `docker login -u ... -p ...` directly — it handles credential masking
  correctly and avoids the password appearing in a `run:` command line.

```yaml
docker build -t myapp:${{ github.sha }} .
docker tag myapp:${{ github.sha }} myapp:latest
```
- Tagging with `github.sha` gives every image traceability back to the
  exact commit that produced it — critical when debugging "which code is
  actually running in prod."
- `latest` is a convenience floating tag, not a traceability tag — never
  rely on it alone in production.

## Registry authentication options

| Registry | Typical auth |
|---|---|
| Docker Hub | Username + access token (not account password) |
| GitHub Container Registry (ghcr.io) | `GITHUB_TOKEN` with `packages: write`, or a PAT |
| AWS ECR | OIDC role assumption (preferred) or IAM access keys |
| Azure ACR | Service principal or OIDC |

## Common mistakes

- Hardcoding credentials directly in the workflow file (never do this).
- Pushing only `latest` with no SHA tag — makes rollbacks and audits
  impossible.
- Not scoping `permissions:` — defaults can be more permissive than needed.
