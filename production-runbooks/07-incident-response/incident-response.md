# Incident Response Framework

## Incident Severity
Exact definitions vary by organization, but a common four-tier model:

| Severity | Definition | Example |
|---|---|---|
| SEV-1 | Full outage or critical data-loss risk, affecting all/most users | Site down, payments failing entirely |
| SEV-2 | Major functionality degraded or a significant subset of users affected | One key feature broken, one region down |
| SEV-3 | Minor functionality impaired, workaround available, limited user impact | Non-critical feature slow/broken for some users |
| SEV-4 | Cosmetic or negligible impact, no urgent action required | UI glitch, minor logging noise |

Severity determines paging urgency, communication cadence, and whether a
formal postmortem is required — always confirm your organization's actual
definitions rather than assuming this table applies verbatim.

## Incident Lifecycle
```
Detection
   |
Triage
   |
Mitigation
   |
Investigation
   |
Recovery
   |
Verification
   |
Communication
   |
Postmortem
```

- **Detection** — an alert fires, or a human notices/reports the issue
- **Triage** — confirm it's real, assess severity and blast radius
- **Mitigation** — stop the bleeding (rollback, scale, failover) even
  before the root cause is fully understood, if safe to do so
- **Investigation** — find the actual root cause, now that impact is contained
- **Recovery** — apply the permanent fix, or confirm the mitigation is
  sufficient and stable
- **Verification** — confirm against the original signal that the system
  is genuinely healthy, not just "looks fine"
- **Communication** — update stakeholders throughout, not just at the end
- **Postmortem** — document what happened and what changes as a result

## During an Incident

- **Establish impact** — what's actually affected, and how many
  users/requests, before deciding how urgently to act
- **Assign ownership** — one clear incident commander/owner avoids
  duplicated or conflicting actions
- **Communicate** — regular, brief updates to stakeholders reduce
  interruption ("any update?" pings) and build trust that it's being handled
- **Record timeline** — timestamp key observations and actions as you go;
  reconstructing this after the fact from memory is unreliable and slow
- **Preserve evidence** — capture logs/state before a fix might overwrite
  or lose them, especially if the fix involves restarting something
- **Mitigate first when necessary** — for a severe, ongoing outage,
  restoring service (even via rollback without full understanding yet)
  usually outranks fully understanding the cause first
- **Investigate systematically** — once impact is controlled, follow the
  standard flow (identify layer → collect evidence → root cause) rather
  than jumping between hypotheses

## Root Cause Analysis

### 5 Whys
Ask "why" repeatedly against the previous answer until you reach an
actionable, systemic cause rather than stopping at the first surface-level
explanation.
```
Why did users see 502s?          -> Upstream pods weren't ready
Why weren't pods ready?          -> Readiness probe was failing
Why was the readiness probe failing? -> It checked a path that was renamed in the new release
Why wasn't that caught before deploy? -> No CI check validates probe paths against actual routes
Why is there no such CI check?   -> Not previously identified as a gap
```
The actionable fix here is the CI check, not just "fix the probe path" —
that's the difference 5 Whys is meant to surface.

### Timeline analysis
Reconstruct the sequence of events precisely — deploys, config changes,
alerts, and human actions in time order — often reveals the actual trigger
that a symptom-only view misses.

### Recent changes
The majority of incidents correlate with *something* that changed
recently — a deploy, a config edit, a dependency version bump, a scaling
event, a manual infrastructure change. Always check "what changed" before
assuming a spontaneous failure.

### Dependency analysis
Map what the affected system depends on (and what depends on it) — a
failure can originate upstream (a dependency) or manifest downstream (a
consumer failing because of you) from where the symptom was first observed.

### Contributing factors
Distinguish the root cause from contributing factors that made it worse
or harder to catch — e.g. the root cause might be a bad config value, but
a contributing factor could be "no alert existed for this condition" or
"the rollback process took longer than it should have."

## Postmortem Template

```
Incident:
Date:
Duration:
Severity:
Impact:
Detection:
Timeline:
Root Cause:
Contributing Factors:
Mitigation:
Resolution:
What Went Well:
What Went Wrong:
Action Items:
Owner:
Due Date:
```

Notes on filling it out well:
- **Impact** should be specific and quantified where possible (e.g. "15%
  of checkout requests failed for 22 minutes"), not just "site was down."
- **Root Cause** should be the systemic cause (per 5 Whys), not just the
  immediate trigger.
- **Action Items** should be concrete, owned, and dated — a postmortem
  without assigned action items rarely prevents recurrence.
- Postmortems should be blameless — the goal is fixing the system and
  process, not assigning fault to an individual.

## Interview-ready summary
"I think about incident response as a lifecycle: detect, triage, mitigate
first if the impact is severe, then investigate properly once things are
stable, verify against the original signal, and always close with a
blameless postmortem that produces concrete action items — not just a
description of what happened. For root cause analysis specifically, I use
5 Whys to make sure I land on a systemic, actionable cause rather than
stopping at the first surface-level explanation."
