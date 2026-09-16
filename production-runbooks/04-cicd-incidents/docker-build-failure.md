# Incident: Docker Build Failure

## 1. Incident Summary
A `docker build` fails, blocking the CI/CD pipeline from producing a
deployable image. The failure could be in any Dockerfile instruction, the
build context, or the base image itself.

## 2. Symptoms
- `docker build` exits non-zero with an error pointing at a specific instruction step
- Pipeline blocked at the build stage
- Sometimes builds succeed locally but fail in CI (or vice versa)

## 3. Impact
Blocks shipping a new image entirely — no deploy can happen until resolved.

## 4. Possible Causes
- Base image tag doesn't exist or was removed/deprecated
- A `RUN` step (dependency installation) fails due to a version conflict,
  missing system package, or network issue reaching a package registry
- `COPY`/`ADD` references a path that doesn't exist in the build context
  (often due to `.dockerignore` excluding it, or a wrong relative path)
- Permission errors (writing to a directory without appropriate ownership/USER context)
- Build cache serving a stale layer that masks/misrepresents the current failure
- Build context too large or missing required files because `.dockerignore` is too aggressive

## 5. Isolating the failing instruction
Docker builds execute Dockerfile instructions sequentially, each producing
a layer. The build log shows exactly which numbered step failed — always
start there. If the failure is unclear, build with `--progress=plain` (or
add a temporary `RUN` command to inspect intermediate state) to get full,
unbuffered output rather than Docker's collapsed default view.

```bash
docker build --no-cache --progress=plain -t debug-image .
```
**What it checks:** the build with caching disabled and full, unbuffered
output.
**Why we run it:** `--no-cache` rules out a stale-cache masking issue;
`--progress=plain` gives full output for the exact failing command instead of a summary.
**What to look for:** the specific shell command and its full stderr output
at the failing step.

## 6. Troubleshooting Flow
```
docker build fails
      |
Which numbered step failed? (from build log)
      |
FROM step? -----------------> base image tag missing/removed
      |
COPY/ADD step? -------------> check .dockerignore and relative paths
      |
RUN step (install deps)? ---> reproduce that exact command in a
                               container from the same base image
      |
RUN step (build app)? -------> check for missing build tools in base image,
                               or a genuine application build error
      |
Find root cause
```

## 7. Commands

```bash
docker build --no-cache --progress=plain -t debug-image .
```
(see above)

```bash
docker run -it --rm <base-image> sh
```
**What it checks:** an interactive shell in the exact base image, to
manually reproduce a failing `RUN` step.
**Why we run it:** isolates whether the failure is due to the base image
itself (missing tool, wrong OS package manager) vs your specific commands.
**What to look for:** whether the same install command that fails in the
build succeeds or fails identically here.

```bash
cat .dockerignore
```
**What it checks:** which files/paths are excluded from the build context.
**Why we run it:** a `COPY` failure ("file not found") is very often
caused by `.dockerignore` excluding something you actually need, not a
wrong path in the Dockerfile.
**What to look for:** an overly broad pattern (e.g. `*.json` accidentally
excluding a required config file).

```bash
docker build -t debug-image . --target <stage-name>
```
**What it checks:** build only up to a specific stage in a multi-stage Dockerfile.
**Why we run it:** isolates which stage of a multi-stage build is failing,
rather than debugging the whole thing at once.
**What to look for:** the specific stage where output stops being produced correctly.

## 8. How to Interpret the Output
- Failure at `FROM <image>:<tag>` with "manifest not found" → the base
  image tag doesn't exist (deprecated, deleted, or typo).
- Failure at a `COPY` step with "no such file or directory" → check
  `.dockerignore` first, then the relative path itself.
- Failure at a `RUN npm install`/`pip install` step → reproduce in an
  interactive container from the same base image; often a version
  conflict or missing system dependency (e.g. a C compiler for native modules).
- Build succeeds locally but fails in CI → check for build-context
  differences (files present locally but gitignored/not checked out in CI)
  or platform/architecture differences (e.g. building on ARM locally, CI runs on AMD64).

## 9. Root Cause Examples
- Base image tag `node:18` got a new patch release that dropped a system
  package your `RUN apt-get install` step depended on
- `.dockerignore` includes `*.env` which accidentally also excludes a
  required `config.env.example` file needed at build time
- A native npm package needs a C compiler toolchain not present in the
  slim base image used for this build stage
- Build context includes a huge, unnecessary directory (e.g. `node_modules`
  not excluded), making the build slow and occasionally timing out in CI

## 10. Fix / Recovery
**Immediate mitigation:**
- Pin the base image to a known-working digest/tag instead of a floating tag
- Add the missing system dependency to the Dockerfile explicitly

**Permanent fix:**
- Pin base image versions deliberately (avoid `latest` or unpinned minor tags in production builds)
- Fix `.dockerignore` to exclude only what's truly unnecessary
- Add a lightweight local pre-build check (or CI cache) that catches these
  earlier and faster than a full CI run

## 11. Verification
- `docker build` succeeds locally and in CI with `--no-cache`
- Resulting image runs correctly (`docker run` smoke test) before being pushed

## 12. Prevention
- Pin base image tags/digests explicitly
- Keep `.dockerignore` reviewed alongside Dockerfile changes
- Use multi-stage builds to keep final images lean and reduce surface
  area for build-time dependency issues
- Cache dependency-install layers deliberately (ordering `COPY
  package.json` before `COPY . .`) so unrelated code changes don't
  invalidate the dependency-install cache unnecessarily

## 13. Post-Incident Checklist
- [ ] Identified the exact failing Dockerfile instruction from the build log
- [ ] Reproduced locally with `--no-cache --progress=plain`
- [ ] Root cause confirmed (base image, COPY path, dependency, or permissions)
- [ ] Fix applied and verified with a clean build
- [ ] Base image pinning/`.dockerignore` reviewed if relevant

## 14. Interview Explanation
"Docker build failures are usually easiest to solve by isolating the
exact instruction that failed from the build log, then reproducing just
that step — either with `--no-cache --progress=plain` for full output, or
by dropping into an interactive shell from the same base image to run the
failing command manually. That tells me quickly whether it's a base-image
problem, a `.dockerignore`/build-context problem, or a genuine dependency/
application build error, rather than guessing across the whole Dockerfile
at once."
