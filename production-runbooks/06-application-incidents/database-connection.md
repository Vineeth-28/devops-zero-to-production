# Incident: Database Connection Failure

## 1. Incident Summary
The application can't connect to its database — but "the database is
down" is often the *last* correct hypothesis, not the first. Most
connection failures are network, configuration, or credential issues
sitting between the application and a perfectly healthy database.

## 2. Symptoms
- Application errors referencing connection timeouts, refused connections,
  or authentication failures to the database
- Readiness probes failing (if readiness checks DB connectivity), possibly
  causing 503s across every replica simultaneously (see 503 runbook)
- Connection pool exhaustion errors under load, distinct from an outright
  inability to connect at all

## 3. Impact
Can range from total application outage (no DB access at all means
nothing works) to partial degradation (some queries/features fail while
others relying on cache continue working).

## 4. Possible Causes
- Wrong hostname/port in application configuration (especially after an
  environment promotion or a DB migration to a new instance)
- DNS resolution failure for the database hostname
- Security group/firewall/NetworkPolicy blocking the application's network path to the DB
- Wrong credentials, or credentials rotated without updating the application's secret
- Database itself down, restarting, or failing over
- Connection pool exhausted (too many connections held, or pool size
  misconfigured relative to real concurrency)
- Database at its own max-connections limit from other clients

## 5. Traffic Path
```
Application
  |
DNS
  |
Network
  |
Security (firewall / security group / NetworkPolicy)
  |
Database
  |
Authentication
  |
Query
```
Work through this path from the top — most "database is down" reports
resolve to a failure in DNS, network, or security, well before the
database itself is even reached.

## 6. Avoiding the instinct to blame the database first
The database is usually the most heavily monitored, most operationally
mature component in the stack — which paradoxically means it's less
likely to be silently broken than the newer, less-observed layers around
it (a recent config change, a security group edit, a credential rotation).
Confirm the database's own health independently before assuming it's the
cause, rather than starting an investigation there by default.

## 7. Troubleshooting Flow
```
DB connection failure
      |
Confirm the DB is actually reachable/healthy independently
(check DB's own monitoring/dashboard, or connect with a DB client directly)
      |
Is the DB itself healthy? ------------------+
      |                                     |
   Yes (DB is fine)                         No -> DB-side incident;
      |                                     escalate/investigate there directly
Check app's DNS resolution for DB hostname
      |
Check network path (security group / NetworkPolicy / firewall)
      |
Check credentials match current DB configuration
      |
Check connection pool metrics (exhausted vs available)
      |
Find root cause
```

## 8. Commands

```bash
# From the application host/pod, resolve the DB hostname
dig <db-hostname>
```
**What it checks:** DNS resolution for the configured database hostname.
**Why we run it:** a surprisingly common cause — a DNS record change or a
typo in the app's config that only breaks in one environment.
**What to look for:** doesn't resolve, or resolves to an unexpected IP
(e.g. still pointing at an old/decommissioned DB instance).

```bash
nc -zv <db-host> <db-port>
```
**What it checks:** basic TCP reachability to the database port from the application's network location.
**Why we run it:** distinguishes a network/firewall problem from an
application-config or credentials problem.
**What to look for:** connection refused/timeout (network/security group
issue) vs successful connection (network is fine — look at credentials/DB itself next).

```bash
psql -h <host> -p <port> -U <user> -d <dbname>   # or mysql -h ... equivalent
```
**What it checks:** whether a direct client connection with the same
credentials the app uses actually succeeds.
**Why we run it:** isolates whether it's an application-specific
connection-handling issue or a genuine credentials/network/DB-availability problem.
**What to look for:** the exact same error the app reports (confirms it's
not app-specific) vs a successful connection (points back at the app's
own configuration or connection-pool behavior).

```bash
kubectl logs <app-pod> | grep -i "connection"
```
**What it checks:** application-level error detail around the failure.
**Why we run it:** the app's own error message often distinguishes
"connection refused" (network) from "authentication failed" (credentials)
from "too many connections" (pool/limit exhaustion).
**What to look for:** the specific error text — treat it as the primary clue.

## 9. How to Interpret the Output
- DNS resolves correctly, `nc` succeeds, but `psql`/`mysql` fails with an
  auth error → credentials mismatch — check for a recent rotation the app
  wasn't updated for.
- `nc` times out/refuses → network-layer problem (security group,
  NetworkPolicy, firewall) — investigate there, not the database itself.
- Direct client connection succeeds fine, but the app still fails → the
  problem is in the application's own connection handling (pool exhaustion,
  wrong config value used only by the app, TLS mismatch).
- Database's own metrics show it's near its max-connections limit → other
  clients (or an app connection leak) are consuming the pool; not
  necessarily this application's direct fault.

## 10. Root Cause Examples
- A database credential was rotated as part of routine security hygiene,
  but the application's secret wasn't updated in the same change
- A security group rule was tightened during an unrelated hardening pass,
  inadvertently blocking the application's subnet
- A connection pool leak (connections opened but never released) slowly
  exhausted the pool under normal traffic over hours
- The application's config still pointed at a read-replica that was
  decommissioned during a database topology change

## 11. Fix / Recovery
**Immediate mitigation:**
- Update the application's credentials/secret if a rotation is confirmed as the cause
- Correct the security group/NetworkPolicy rule if confirmed as the blocker
- Restart the application to release a leaked/exhausted connection pool as
  a stopgap while the leak itself is investigated

**Permanent fix:**
- Fix the actual connection-leak bug in application code
- Automate credential rotation so application secrets update in lockstep
  with the database (e.g. via a secrets manager with rotation hooks)
- Add explicit tests/alerts for connectivity after infrastructure changes
  affecting network rules or DB topology

## 12. Verification
- Application successfully connects and serves DB-dependent requests
- Connection pool metrics show healthy headroom, not near-exhaustion
- No repeat connection errors over a sustained observation window

## 13. Prevention
- Alert on connection pool utilization trending toward exhaustion, not
  just outright connection failures
- Tie credential rotation automation to application secret updates so they
  can't drift out of sync
- Include database connectivity checks in post-deploy/post-infra-change
  verification steps
- Document DB topology changes (replicas, failover targets) and update all
  application configs in the same change

## 14. Interview Explanation
"With a database connection failure, my instinct is specifically to *not*
assume the database is broken first, since it's usually the most
monitored, most mature part of the stack. I confirm the database's own
health independently, then walk the path from the application outward:
DNS resolution for the hostname, then raw network reachability to the
port, then a direct client connection with the same credentials the app
uses. That sequence tells me clearly whether I'm dealing with DNS, a
network/security-group block, bad credentials, or an application-side
connection-pool problem — each of which needs a completely different fix."
