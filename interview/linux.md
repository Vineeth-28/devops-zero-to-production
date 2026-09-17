# Linux Interview Questions

Based on `../01-linux/` (commands/, troubleshooting/, labs/). For a fast refresh instead of drilling through these, see `../01-linux/README.md`.

---

## Q1. A production server suddenly shows very high CPU usage. Walk me through your investigation.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you have a structured, layer-by-layer approach rather than randomly running commands, and whether you can distinguish "what's using CPU" from "why."

### Expected Answer
Start with `top`/`htop` to see load average and which process is consuming CPU. Check if it's one process (application bug, infinite loop, runaway job) or system-wide (too much traffic, cron overlap, noisy neighbor). Use `ps aux --sort=-%cpu` to confirm the top consumer, then look at what that process is actually doing — application logs, `strace -p <pid>` for syscalls if needed. Check load average trend against number of cores (`nproc`) to know if it's actually overloaded or just busy.

### Strong Interview Answer
"First I'd run `top` to see the load average and identify whether it's one runaway process or broad system load. If it's one process, I'd confirm with `ps aux --sort=-%cpu` and check what that process is — is it a legitimate spike in traffic, a stuck job, or a bug like an infinite loop. I'd cross-check load average against `nproc` to know if we're actually CPU-bound. Then I'd pull that service's logs around the same timestamp to correlate with a deploy or traffic spike, rather than just killing the process blind."

### Follow-up Questions
- What's the difference between load average and CPU usage percentage?
- How would you find out if a spike started right after a deployment?
- When would you restart the process vs let it run and investigate live?

### Key Points
- Confirm before acting: identify the process, don't guess.
- Correlate with recent changes (deploys, cron, traffic).
- Load average is relative to core count — always check `nproc`.

---

## Q2. Explain the difference between `df` and `du`. Have you ever seen them disagree?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Real hands-on experience with disk troubleshooting, not just textbook definitions.

### Expected Answer
`df` reports filesystem-level disk usage (what the kernel believes is used on the block device). `du` walks the directory tree and sums file sizes. They can disagree when a file is deleted but still held open by a running process — the inode isn't freed, so `df` still shows the space as used, but `du` (which only sees the directory tree) won't count it because the file no longer has a path.

### Strong Interview Answer
"`df` shows disk usage at the filesystem level, `du` sums up file sizes under a path. They usually match, but I've hit a case where `df` showed a disk nearly full while `du /` didn't account for all of it — turned out a log file had been deleted while a process still had the file descriptor open, so the space wasn't released. `lsof | grep deleted` found the process, and restarting it released the space."

### Follow-up Questions
- How do you find which process is holding a deleted-but-open file?
- What's the safe way to free that space without stopping the whole service?
- What does `df -i` show, and why would you need it?

### Key Points
- `df` = filesystem-level, `du` = directory-tree file sizes.
- Mismatch usually means a deleted file is still open (`lsof | grep deleted`).
- `df -i` checks inode exhaustion, a separate failure mode from byte usage.

---

## Q3. What's the difference between `systemctl` and `journalctl`, and when do you use each?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Baseline Linux service-management fluency — do you know the boundary between managing a service and reading its logs.

### Expected Answer
`systemctl` manages the state of a systemd service (start/stop/restart/enable/status). `journalctl` reads the structured logs systemd collects, including output from those services. `systemctl status` gives a short recent log tail plus state; `journalctl -u <service>` gives the full log history for deeper investigation.

### Strong Interview Answer
"`systemctl` is for controlling and checking a service's state — is it running, restart it, enable it on boot. `journalctl` is for reading logs. In practice I use `systemctl status <service>` first for a quick health + recent-log snapshot, and if I need more history or want to filter by time or severity I go to `journalctl -u <service> --since '10 min ago'` or `journalctl -u <service> -p err`."

### Follow-up Questions
- How do you tail logs for a service live?
- How do you check logs only since the last boot?
- How would you find out why a service failed to start at all?

### Key Points
- `systemctl` = control/state, `journalctl` = logs.
- `journalctl -u <service> -f` for live tailing.
- `systemctl status` gives a quick combined view for first response.

---

## Q4. A developer says they can't SSH into a server. How do you troubleshoot it?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you troubleshoot in layers (network → service → auth → authorization) instead of guessing.

### Expected Answer
Work outward-in: can you reach the host at all (`ping`, security group/firewall rules)? Is the SSH port open (`nc -zv host 22` or `telnet host 22`)? Is `sshd` running on the target (`systemctl status sshd`)? Is the failure at authentication (wrong key, permissions on `~/.ssh`, `authorized_keys`) or authorization (user doesn't exist, account locked, shell disabled)? Check `/var/log/auth.log` or `journalctl -u sshd` on the server for the actual rejection reason.

### Strong Interview Answer
"I go layer by layer. First, network — can I even reach the host on port 22, ruling out security groups or firewalls. Then service — is `sshd` actually running. Then authentication — is the right key being offered, and are permissions correct on `.ssh` and `authorized_keys` (`chmod 700`/`600`, they're strict about that). Then authorization — does the user account exist and is it not locked. The fastest way to cut through guessing is checking `/var/log/auth.log` on the server itself, which tells you exactly why it was rejected instead of me guessing client-side."

### Follow-up Questions
- What permissions does `~/.ssh` and `authorized_keys` need to work?
- What's the difference between an authentication failure and an authorization failure here?
- How would you debug this if you don't have console/out-of-band access to the server?

### Key Points
- Troubleshoot in layers: network → service → authentication → authorization.
- Server-side `auth.log`/`journalctl -u sshd` gives the real reason — don't guess client-side.
- Strict permission requirements on `.ssh` (700) and keys (600) are a common silent failure.

---

## Q5. The disk is full on a production server. Walk me through recovery.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Safe, methodical incident response under pressure — not "just delete stuff."

### Expected Answer
First confirm impact and which mount is full (`df -h`). Find what's consuming space (`du -sh /* | sort -rh` narrowing down). Common culprits: log files, old Docker images/containers, core dumps, apt/yum caches. Clear safely — rotate/truncate logs rather than deleting mid-write, `docker system prune`, clear package caches. Avoid deleting anything you don't understand. After recovery, address the root cause (log rotation missing, no monitoring alert) to prevent recurrence.

### Strong Interview Answer
"First I check `df -h` to see which mount is actually full — sometimes it's not `/` but a specific volume. Then I narrow down with `du -sh` on likely directories, often `/var/log` or Docker's storage. I don't blindly `rm` — for an actively-written log I'd truncate it with `> file.log` rather than delete it, since deleting a file a process still has open doesn't free space until the process is restarted. Once space is recovered, I set up log rotation or a disk-usage alert so this doesn't recur silently."

### Follow-up Questions
- Why is truncating a live log file safer than deleting it?
- What tools would you use to prevent this from happening again?
- How would you check if it's actually inode exhaustion rather than byte usage?

### Key Points
- Confirm mount and cause before acting — don't delete blindly.
- Truncate (`> file`) live logs instead of `rm` to avoid orphaned open file descriptors.
- Fix root cause afterward: log rotation, disk alerts, cleanup cron.

---

## Q6. What's the difference between `chmod` and `chown`?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Basic Linux permissions fluency, and whether you understand the numeric permission model.

### Expected Answer
`chmod` changes what actions are allowed (read/write/execute) for owner/group/others. `chown` changes who owns the file (user and/or group). They solve different problems: a "permission denied" can be because the permission bits are wrong, or because the wrong user/group owns the file entirely.

### Strong Interview Answer
"`chmod` controls what you're allowed to do with a file — read, write, execute — for the owner, group, and everyone else, expressed either symbolically (`u+x`) or numerically (`755`). `chown` controls who owns it. If a deploy script can't write to a directory, I check both: is it owned by the right user (`chown`), and does that user have write permission (`chmod`)? They're often confused because both show up as 'Permission denied,' but the fix is different."

### Follow-up Questions
- What does `755` mean in numeric permissions?
- What's the difference between `chown user:group` and `chgrp`?
- What's the risk of `chmod 777` in production?

### Key Points
- `chmod` = what you can do; `chown` = who owns it.
- Both can cause "Permission denied" — check both, not just one.
- `chmod 777` is a red flag in production — overly permissive, not a real fix.

---

## Q7. Logs show errors right after a deployment. How do you confirm the deploy caused it?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Correlation discipline — using timestamps and change history rather than assuming causation.

### Expected Answer
Line up the deployment timestamp against when errors started appearing in logs (`journalctl --since`). Check what actually changed in the deploy (config, code, dependency version). If unclear, compare error rate before/after in monitoring, and check if rolling back resolves it — that's the strongest confirmation.

### Strong Interview Answer
"I pull the exact deploy timestamp and grep or `journalctl --since` around that window to see if the error onset lines up. Then I look at what actually changed — a diff of the deploy, config changes, new dependency versions. If it's still ambiguous, the most reliable test is a rollback: if the errors stop immediately after rollback, that's strong confirmation it was the deploy, not something coincidental like a traffic spike."

### Follow-up Questions
- What if the errors started a few minutes after the deploy, not immediately?
- How do you rule out a coincidental cause like increased traffic?
- What would you check in the deploy pipeline itself for evidence?

### Key Points
- Correlate exact timestamps, don't assume.
- A clean rollback that stops the errors is the strongest evidence.
- Rule out coincidental causes (traffic, unrelated infra change) before concluding.

---

## Q8. What's the difference between `ps` and `top`?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Whether you know when to use a snapshot tool vs a live monitoring tool.

### Expected Answer
`ps` gives a point-in-time snapshot of processes, good for scripting and precise filtering (`ps aux --sort=-%mem`). `top` (or `htop`) is an interactive, continuously refreshing view, good for watching behavior over time and sorting live by CPU/memory.

### Strong Interview Answer
"`ps` is a one-time snapshot — I use it when I want to grep or script against specific processes, like `ps aux | grep java`. `top` or `htop` is live and interactive, so I use it when I actually want to watch what's happening over the next few seconds — is CPU climbing, is one process consistently at the top. In practice I start with `top` to spot the problem, then use `ps` to script a precise check or automate an alert."

### Follow-up Questions
- How would you sort `ps` output by memory usage?
- What advantage does `htop` have over `top`?
- How would you use `ps` in a monitoring script?

### Key Points
- `ps` = snapshot, scriptable; `top`/`htop` = live, interactive.
- Use `top` to spot the issue, `ps` to precisely query/script it.
- `ps aux --sort=-%cpu` / `-%mem` for quick top-consumer checks.

---

## Q9. How do you troubleshoot SSH failures when the error message alone isn't clear (e.g. "Connection refused" vs "Connection timed out" vs "Permission denied")?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you understand that different SSH error messages point to entirely different layers of the stack.

### Expected Answer
"Connection timed out" usually means a network/firewall problem — the packet never got a response. "Connection refused" means the network path is fine but nothing is listening on that port (sshd down, wrong port). "Permission denied" means you reached sshd and it processed the request, but authentication failed (wrong key, wrong user, bad permissions). Each message points you to a different layer, so you shouldn't treat them the same way.

### Strong Interview Answer
"Those three messages map to different layers, so I don't troubleshoot them the same way. Timeout means the network path itself is blocked — security group, firewall, routing — nothing is answering at all. Refused means the network is fine but nothing's listening on that port, usually `sshd` is down or on a different port. Permission denied means the connection succeeded and we got as far as authentication, so now it's about the key, the user, or file permissions. Reading the exact error tells me which layer to start at instead of checking everything."

### Follow-up Questions
- What network-level check would you run first for a timeout?
- If sshd is running but "Connection refused" still happens, what else could cause that?
- Where would you look server-side to see why a permission-denied happened?

### Key Points
- Timeout → network/firewall layer.
- Refused → service not listening (down, wrong port).
- Permission denied → reached the service, auth-layer failure.

---

## Q10. `df -h` shows plenty of free space, but you still get "No space left on device" errors. What's happening?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Knowledge of a real production gotcha — inode exhaustion — that catches people who only check byte usage.

### Expected Answer
The filesystem can run out of inodes (metadata entries for files) even if there's plenty of free byte-space, typically caused by huge numbers of small files (e.g. session files, cache files, logs split per request). Check with `df -i`. Fix by finding and cleaning up the directory generating excessive small files, and addressing the root cause (misconfigured cache, no cleanup job).

### Strong Interview Answer
"That's inode exhaustion — the filesystem has a fixed number of inodes, and each file, even a 0-byte one, uses one. If something is generating huge volumes of tiny files, like a cache or session directory that never cleans up, you can hit `df -i` at 100% while `df -h` still shows free space. I'd run `df -i` to confirm, then find the directory with an enormous file count, usually with `find /path -xdev | wc -l` per subdirectory, and clean it up along with fixing whatever process isn't cleaning after itself."

### Follow-up Questions
- How would you find which directory has the most files quickly?
- Why can't you just add more inodes without reformatting?
- What kind of application behavior commonly causes this?

### Key Points
- `df -h` checks bytes, `df -i` checks inodes — separate resources.
- Massive small-file counts (cache/session dirs) are the usual cause.
- Inode count is set at filesystem creation — fixing it live usually means cleanup, not resizing.

---

## Q11. When would you use `command` and when `shell` module type behavior in a shell script, or explain the reasoning behind read-only diagnostics first in an incident?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Production discipline — using safe, non-destructive commands first when investigating a live incident.

### Expected Answer
In a live incident, always prefer read-only/diagnostic commands (`ps`, `top`, `df`, `journalctl`, `netstat`/`ss`) before anything that changes state (restart, kill, delete). This preserves evidence for root-cause analysis and avoids making an already-bad situation worse or masking the real cause.

### Strong Interview Answer
"My default is read-only first — `ps`, `df`, `journalctl`, `ss -tulpn` — because those don't change anything, so I can safely gather evidence without risking making the incident worse or destroying the evidence I'd need for a postmortem. Only once I understand what's actually happening do I reach for something destructive like restarting a service or killing a process, and even then I try to capture a snapshot (like a `top` output or thread dump) right before I act, in case I need it later."

### Follow-up Questions
- Give an example of a "destructive" command you'd avoid running early in an incident.
- Why does evidence preservation matter for a postmortem?
- How do you balance moving fast during an incident vs. being careful?

### Key Points
- Diagnostics before destructive actions, always.
- Preserve evidence (snapshots/logs) before changing state.
- Speed matters, but not at the cost of losing the ability to find root cause.

---

## Q12. What does load average actually mean, and how do you interpret `1.5, 2.0, 1.2` on a 4-core machine?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you understand load average isn't a raw percentage and needs context (core count) to interpret.

### Expected Answer
Load average represents the average number of processes waiting for or using the CPU over 1, 5, and 15-minute windows. It must be read relative to the number of cores — a load of 4 on a 4-core machine means the system is fully utilized (not necessarily bad), while the same number on a 1-core machine means heavy queuing. On `1.5, 2.0, 1.2` with 4 cores, the system is comfortably under capacity.

### Strong Interview Answer
"Load average is the average number of processes wanting CPU time, over the last 1, 5, and 15 minutes, and you always have to divide it by the core count to know what it means. On a 4-core box, `1.5, 2.0, 1.2` means we're using roughly half our CPU capacity — that's healthy, not concerning. If I saw `8.0` on that same 4-core box I'd be worried, because it means work is queuing up well beyond what the machine can process at once. I'd also look at the trend across the three numbers — rising from 1.2 to 2.0 to 1.5 suggests a spike that's already settling, not a sustained problem."

### Follow-up Questions
- How do you check the number of cores on a machine?
- What's the difference between CPU-bound load and I/O-wait-driven load?
- At what load-to-core ratio would you start investigating?

### Key Points
- Load average is process queue length, not a percentage — divide by core count.
- Always check `nproc` alongside load average.
- Trend across 1/5/15-min windows tells you if it's a spike or sustained.

---
