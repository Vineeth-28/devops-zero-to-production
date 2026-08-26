# Runner Issues

## Job stuck in "Queued"

- **GitHub-hosted runners**: usually a transient GitHub capacity issue, or
  you've hit your plan's concurrent job limit — wait or check org/repo
  Actions usage limits.
- **Self-hosted runners**: no runner is currently online for the `runs-on`
  label you specified. Check the runner's status under
  **Settings -> Actions -> Runners**.
- **Label mismatch**: `runs-on: [self-hosted, gpu]` requires a runner
  registered with *both* labels, not just one.

## Runner disconnects mid-job

- Self-hosted runner machine ran out of disk/memory — add cleanup steps or
  increase resources.
- Long-running job exceeded the default 6-hour job timeout — set
  `timeout-minutes:` deliberately and split long jobs where possible.
- Network interruption on a self-hosted runner — check the runner's local
  service logs (`_diag/` folder in the runner install directory).

## "This job was not started because the workflow uses an unsupported label"

- The label in `runs-on:` doesn't match any hosted or self-hosted runner
  configuration. Check for typos (`ubuntu-latst`) or a missing self-hosted
  runner group scope.

## Choosing GitHub-hosted vs self-hosted

| | GitHub-hosted | Self-hosted |
|---|---|---|
| Setup | Zero setup | You provision and maintain the machine |
| Cost | Billed per minute (free tier for public repos) | Your own infrastructure cost |
| Custom software/hardware | Limited to provided images | Full control (GPU, internal network access) |
| Security surface | Ephemeral, isolated per job | Persistent — must be hardened and patched |
