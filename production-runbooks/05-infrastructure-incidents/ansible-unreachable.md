# Incident: Ansible UNREACHABLE

## 1. Incident Summary
Ansible reports a host as `UNREACHABLE` — meaning it couldn't even
establish a connection to run any task. This is fundamentally different
from a task/module failing after a successful connection.

## 2. Symptoms
- Playbook run shows `UNREACHABLE!` for one or more hosts, before any task output
- Error typically mentions SSH connection failure, timeout, or auth failure

## 3. Impact
No configuration/automation can run against the affected host(s) at all —
ranges from one host being skipped (if others succeed) to a full playbook
run failing if connectivity is broadly broken.

## 4. Possible Causes
- Wrong hostname/IP in inventory (stale entry, host was replaced/re-IP'd)
- Host is genuinely down or unreachable on the network
- SSH service not running or listening on an unexpected port
- Security group/firewall blocking the control node's IP
- Wrong SSH user or key in inventory/vars
- SSH key permissions too open (SSH refuses keys with overly permissive file permissions)
- `become` (privilege escalation) misconfigured — this is usually a
  *different* error class (task failure, not UNREACHABLE), but worth
  ruling out if error messages are ambiguous

## 5. UNREACHABLE vs task/module failure
**UNREACHABLE** means Ansible's control node could not establish a
connection to the target at all — the problem is in the transport layer
(network, SSH, credentials) before any Ansible module ever runs.
**Task/module failure** (`FAILED!`) means the connection succeeded and
Ansible successfully ran a module on the host, but that specific task
returned an error (e.g. a package didn't install, a file operation
failed). These need entirely different troubleshooting — UNREACHABLE is a
connectivity problem; FAILED is a logic/environment problem on an already-reachable host.

## 6. Troubleshooting Flow
```
UNREACHABLE
      |
Inventory
      |
Hostname/IP correct? (ansible-inventory --list)
      |
   No -> fix inventory
      |
   Yes
      |
Network reachable? (ping / nc -zv <host> 22)
      |
   No -> investigate network path / security group / firewall
      |
   Yes
      |
SSH works manually? (ssh -i <key> user@host)
      |
   No -> check SSH service, port, key, user
      |
   Yes but Ansible still fails -> check ansible.cfg / inventory vars
      (ansible_user, ansible_ssh_private_key_file, ansible_port)
      |
Find root cause
```

## 7. Commands

```bash
ansible-inventory --list
```
**What it checks:** the resolved inventory Ansible is actually using —
hostnames/IPs, groups, and variables.
**Why we run it:** confirms Ansible has the correct target information
before blaming the network or SSH.
**What to look for:** a stale IP, wrong group membership, or missing connection variables.

```bash
ansible all -m ping
```
**What it checks:** basic Ansible connectivity (SSH + Python interpreter
availability) to every host in inventory.
**Why we run it:** the standard first diagnostic — narrower and faster
than running a full playbook.
**What to look for:** which specific hosts fail, and the exact error text
returned (timeout vs auth failure vs connection refused).

```bash
ssh -i <key> <user>@<host>
```
**What it checks:** whether a plain SSH connection succeeds outside Ansible entirely.
**Why we run it:** isolates whether the problem is Ansible-specific
(wrong inventory vars) or a genuine SSH/network/credentials problem
that would fail for anyone.
**What to look for:** the exact same failure reproduced manually confirms
it's not Ansible-specific; a successful manual SSH but failing Ansible
ping points at inventory variable misconfiguration.

```bash
nc -zv <host> 22
```
**What it checks:** basic TCP reachability to the SSH port.
**Why we run it:** distinguishes "host unreachable on the network" from
"host reachable but SSH/auth is the problem."
**What to look for:** connection refused/timeout (network/firewall) vs
successful connection (network is fine, look at SSH/auth next).

```bash
chmod 600 <private-key-file>
```
**What it checks:** N/A — this is a fix for a common, specific cause.
**Why we run it:** SSH refuses to use private keys with overly permissive
file permissions; this is a very common and easy-to-miss cause of
"UNREACHABLE" that looks like a connectivity problem but is actually local
file permissions.
**What to look for:** an SSH error explicitly mentioning "UNPROTECTED
PRIVATE KEY FILE" when run manually with `-v`.

## 8. How to Interpret the Output
- `nc -zv host 22` times out/refuses → network-layer problem (firewall,
  security group, host down) — look there before touching Ansible config at all.
- `nc` succeeds but manual `ssh` fails with auth error → wrong user/key/credentials.
- Manual `ssh` succeeds, but `ansible all -m ping` still fails → check
  `ansible_user`, `ansible_ssh_private_key_file`, `ansible_port` in
  inventory/group_vars — Ansible may be using different connection
  parameters than your manual test.

## 9. Root Cause Examples
- An inventory entry still points at a host's old IP after infrastructure was recreated
- A security group rule was tightened, no longer allowing the control node's IP on port 22
- The SSH private key file's permissions were reset to 644 by a file sync tool, and SSH now refuses to use it
- `ansible_user` in inventory was set to a user that no longer exists on the target hosts

## 10. Fix / Recovery
**Immediate mitigation:**
- Correct the stale inventory entry
- Fix the security group/firewall rule to allow the control node
- Fix SSH key file permissions (`chmod 600`)

**Permanent fix:**
- Automate inventory generation from your source of truth (cloud provider
  API, Terraform outputs) instead of maintaining it by hand, to prevent staleness
- Document and enforce required security group rules for the control node/CI runner
- Standardize key management (correct permissions enforced by the
  provisioning process, not manual fixes)

## 11. Verification
- `ansible all -m ping` succeeds for all previously-unreachable hosts
- Full playbook run completes without UNREACHABLE errors
- SSH connectivity confirmed stable across a couple of repeated checks, not just once

## 12. Prevention
- Automate/derive inventory from infrastructure state instead of hand-maintained files
- Alert on inventory/infrastructure drift (a host in inventory that no longer resolves, or vice versa)
- Document required firewall/security-group rules as part of infrastructure-as-code, not a manual step

## 13. Post-Incident Checklist
- [ ] Confirmed inventory hostname/IP is current
- [ ] Confirmed network reachability independently (`nc`/`ping`)
- [ ] Confirmed manual SSH works with the same credentials Ansible is configured to use
- [ ] Root cause identified (inventory, network, SSH, or key permissions)
- [ ] Fix applied and `ansible -m ping` verified across all hosts

## 14. Interview Explanation
"UNREACHABLE means Ansible never even got a working connection, so I
never start by looking at playbook logic — I start at the transport
layer. I check the inventory is pointing at the right host, then test raw
network reachability, then plain SSH manually with the same credentials
Ansible is configured to use. If manual SSH works but Ansible still fails,
that narrows it specifically to inventory connection variables, not the
network or credentials themselves. It's important to keep this separate
from a task-level FAILED error, which means the connection worked fine
and the problem is in a specific module/task instead."
