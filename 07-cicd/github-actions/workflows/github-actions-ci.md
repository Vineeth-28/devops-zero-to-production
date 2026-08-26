# Workflow Notes — CI (Fundamentals)

Reference notes for `basic-ci.yml` and `node-ci.yml`.

## What "CI" means here
Continuous Integration in this module = automatically checkout, install,
lint, and test on every push/PR, so broken code is caught before merge.

## Key structural pieces

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```
- `on:` defines the trigger events.
- Restricting `branches:` avoids running CI on every throwaway branch.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
```
- Each job gets a fresh, isolated runner.
- `ubuntu-latest` is the most common hosted runner; also available:
  `windows-latest`, `macos-latest`.

```yaml
steps:
  - uses: actions/checkout@v4
```
- `uses:` runs a pre-built Action (reusable unit); `run:` runs a shell
  command directly on the runner.
- `actions/checkout` is required in almost every job — without it, the
  runner has no copy of your repository code.

## Node-specific notes (`node-ci.yml`)

- `actions/setup-node@v4` installs the requested Node version and can cache
  npm/yarn/pnpm dependencies via `with: cache:`.
- `matrix: node-version: [18.x, 20.x]` runs the whole job once per version —
  useful for confirming compatibility across supported runtimes.
- `npm ci` (not `npm install`) in CI — it installs exactly what's in the
  lockfile and fails if the lockfile is out of sync, which is what you want
  in an automated pipeline.

## Common mistakes

- Forgetting `actions/checkout` — steps run against an empty workspace.
- Using `npm install` instead of `npm ci` — non-deterministic installs.
- Not pinning Action versions (`@v4` vs `@main`) — `@main` can change
  behavior under you without warning.
