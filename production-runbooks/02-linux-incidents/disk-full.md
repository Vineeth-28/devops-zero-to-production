# Incident: Disk Full

## 1. Incident Summary
A filesystem has run out of available space (or inodes), which can block
writes, crash applications, prevent logging, or in severe cases stop the
whole host from functioning correctly.

## 2. Symptoms
- Application errors writing to disk (logs, temp files, database writes)
- Alert on low disk space
- Kubernetes node shows `DiskPressure` condition, may start evicting pods
- Services crash-looping with disk-write errors in logs

## 3. Impact
Ranges from log-writing failures (annoying but non-fatal) to full
application/database crashes if writes are blocked, up to node-level
instability if the root filesystem fills.

## 4. Possible Causes
- Application/access logs growing unbounded without rotation
- A large temp/cache directory never cleaned up
- Database growing faster than provisioned storage
- Docker image/container layer buildup (`docker system df`)
- Core dumps or crash artifacts accumulating
- A deleted-but-still-open file held by a running process, so `df` shows
  full while `du` doesn't show where the space went

## 5. First 5 Minutes
1. Confirm which filesystem/mount is full: `df -h`
2. Check inode usage too, not just space: `df -i`
3. Identify what's consuming the space: `du -sh /path/* | sort -rh`
4. Check for deleted-but-open files holding space
5. Check if this is one host or system-wide (shared storage, all nodes)

## 6. Troubleshooting Flow
```
Disk full alert
      |
df -h (confirm which filesystem)
      |
df -i (rule out inode exhaustion)
      |
du -sh /path/* | sort -rh (find biggest consumers)
      |
Is it logs? -----------------------------+
      |                                  |
   Yes                                   No
      |                                  |
Rotate/compress/ship logs           Check for deleted-but-open files
                                     lsof | grep deleted
                                          |
                                     Check Docker/container disk usage
                                          |
                                     Find root cause
```

## 7. df vs du
**`df`** reports filesystem-level space usage — how much space the kernel
believes is used/free on a given mount, based on actual block allocation.
**`du`** reports directory/file-level space usage — walks the filesystem
tree and sums file sizes. They can disagree: if a process has a file open
that was already deleted, `du` won't see it (it's unlinked from the
directory tree) but `df` still shows the space as used, because the
kernel doesn't reclaim it until the file descriptor is closed. This is a
very common "where did my disk space go" trap.

## 8. Commands

```bash
df -h
```
**What it checks:** space usage per mounted filesystem, human-readable.
**Why we run it:** confirms which filesystem is actually full — root, a data volume, or something else.
**What to look for:** `Use%` at or near 100% for the affected mount.

```bash
df -i
```
**What it checks:** inode usage per filesystem.
**Why we run it:** a filesystem can report available space but still fail
writes if it's out of inodes (common with huge numbers of small files).
**What to look for:** `IUse%` near 100%.

```bash
du -sh /var/log/* | sort -rh | head -20
```
**What it checks:** which directories/files are consuming the most space, sorted largest first.
**Why we run it:** finds the actual culprit instead of guessing.
**What to look for:** an unexpectedly large log file or directory.

```bash
lsof +L1
```
**What it checks:** open files with a link count of 0 — i.e. deleted but
still held open by a process.
**Why we run it:** explains a `df`/`du` mismatch where `df` shows full but
`du` can't find the space.
**What to look for:** a large file size next to a process still holding it open.

```bash
docker system df
```
**What it checks:** disk usage breakdown for images, containers, volumes,
and build cache.
**Why we run it:** Docker layer/image buildup is a very common silent
disk consumer on hosts running containers.
**What to look for:** large "reclaimable" totals under images/build cache.

## 9. How to Interpret the Output
- `df -h` at 100% but `du -sh /` doesn't add up to that total → check
  `lsof +L1` for a deleted-but-open file.
- `df -i` near 100% while space (`df -h`) looks fine → inode exhaustion,
  usually from an application generating huge numbers of tiny files
  (e.g. per-request temp files never cleaned up).
- `docker system df` shows large reclaimable image/build-cache size →
  routine image/layer accumulation, safe to prune with care.

## 10. Root Cause Examples
- Application log rotation was never configured (or broke silently),
  letting a single log file grow to fill the disk
- A crashed process left a multi-GB core dump in a data directory
- A restarted service kept its old log file handle open after the file was
  rotated/deleted externally, so space was never actually freed
- CI runners accumulating old Docker images/build cache with no cleanup policy

## 11. Fix / Recovery
**Immediate mitigation:**
- Rotate/compress/truncate the offending log file (`truncate -s 0
  <file>` only if you're certain nothing needs the current content, or
  better: use `logrotate` properly) — ⚠️ DANGEROUS if done on the wrong
  file or without confirming it's safe
- Remove clearly disposable artifacts (old core dumps, stale temp files)
- Restart the process holding a deleted-but-open file handle, once you've
  confirmed it's safe, to actually reclaim that space

**Permanent fix:**
- Configure/repair log rotation (`logrotate`, or the application's own
  rotation config)
- Set up scheduled cleanup for temp/cache directories
- Add disk-usage alerting with enough lead time to act before it's critical
- Establish a Docker image/build-cache pruning policy on hosts and CI runners

## 12. Verification
- `df -h` shows usage back to a healthy margin (well below alert threshold)
- `df -i` inode usage also healthy
- Application writes (logs, DB) succeeding without errors
- No repeat alert over a sustained observation window

## 13. Prevention
- Alert at a lead-time threshold (e.g. 80%) rather than only at 100%
- Automate log rotation and temp-file cleanup as a standard part of every
  service's deployment, not an afterthought
- Regularly review and prune Docker images/build cache on long-lived hosts/runners
- Monitor inode usage alongside space usage

## 13a. Kubernetes Node Disk Pressure Note
When a node hits `DiskPressure`, the kubelet begins evicting pods to
reclaim space (starting with the least-critical ones by its own
heuristics). This can look like unrelated pods being killed with no
application-level cause — always check `kubectl describe node` for
conditions before assuming an application bug when pods are evicted
unexpectedly.

## 14. Interview Explanation
"I start with `df -h` to confirm which filesystem is actually full, and
`df -i` in the same breath since inode exhaustion looks identical to
space exhaustion from the outside but needs a different fix. Then `du -sh`
to find the actual biggest consumer — usually logs. If the numbers from
`df` and `du` don't add up, that's a strong signal there's a
deleted-but-open file being held by a running process, which `lsof +L1`
confirms. The fix is almost always either fixing log rotation or reclaiming
space held by a process that needs restarting."
