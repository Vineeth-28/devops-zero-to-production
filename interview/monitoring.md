# Monitoring Interview Questions (Prometheus, Grafana, Alertmanager)

Based on `../08-monitoring/` (prometheus/, promql/, grafana/, alerting/). For a fast refresh, see `../08-monitoring/interview/` and `../08-monitoring/README.md`.

---

## Q1. Explain Prometheus's pull model. Why pull instead of push?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Core architectural understanding — a frequently asked Prometheus fundamentals question.

### Expected Answer
Prometheus scrapes (pulls) metrics from targets at configured intervals via HTTP, rather than targets pushing metrics to it. Pull gives Prometheus centralized control over scrape frequency and makes it trivial to tell if a target is down (a failed scrape is directly observable) — with push, a silent target and a healthy-but-quiet target look the same.

### Strong Interview Answer
"Prometheus reaches out and scrapes metrics from targets on its own schedule, rather than targets pushing data to it. That gives Prometheus centralized control over scrape intervals and, importantly, makes target health directly observable — if a scrape fails, Prometheus knows immediately that something's wrong with that target. With a push model, you can't easily tell the difference between 'this service is down' and 'this service just has nothing new to report,' because either way, nothing arrives. Push does exist for short-lived jobs via the Pushgateway, but the default and preferred model is pull."

### Follow-up Questions
- When would you use the Pushgateway instead of a normal scrape?
- How does Prometheus know a target is 'down' vs just slow to respond?
- What's the `up` metric, and how is it automatically generated?

### Key Points
- Pull = Prometheus scrapes targets on its own schedule via HTTP.
- Failed scrape directly signals target health — push can't distinguish "down" from "quiet."
- Pushgateway exists as an exception for short-lived/batch jobs that can't be scraped normally.

---

## Q2. What is a "target" and a "job" in Prometheus, and how do labels relate to them?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Config-level vocabulary needed before discussing PromQL or alerting meaningfully.

### Expected Answer
A job is a logical grouping of instances being scraped (e.g. "api-server"), configured in `scrape_configs`. A target is one specific instance/endpoint within that job (a specific host:port being scraped). Every scraped metric automatically gets `job` and `instance` labels identifying which job/target it came from, plus any additional labels defined via relabeling or service discovery.

### Strong Interview Answer
"A job is the logical name for a group of things I'm scraping, like `api-server`, configured under `scrape_configs`. A target is one specific instance within that job — one actual host:port endpoint being scraped. Every metric Prometheus collects automatically gets tagged with `job` and `instance` labels so I can always tell which job and which specific target a data point came from, and I can layer on additional labels through relabeling rules or service discovery metadata."

### Follow-up Questions
- How would you use service discovery instead of statically listing targets?
- What's relabeling, and why would you use it?
- How would two targets in the same job but different instances show up differently in a query?

### Key Points
- Job = logical grouping of scrape targets; Target = one specific instance/endpoint.
- Every metric gets `job`/`instance` labels automatically.
- Service discovery + relabeling let you avoid manually listing every target.

---

## Q3. Compare Counter, Gauge, and Histogram metric types with a real example of each.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you know which metric type fits which measurement — a very common practical question.

### Expected Answer
Counter: monotonically increasing value, only resets on restart — e.g. total HTTP requests served. Use `rate()`/`increase()` to get meaningful per-second/per-window rates from it, never read the raw value directly for trends. Gauge: a value that can go up or down — e.g. current memory usage, number of active connections. Histogram: buckets observations into configurable ranges and tracks counts + sum, used for things like request latency, enabling percentile calculations via `histogram_quantile()`.

### Strong Interview Answer
"Counter only ever goes up — like total requests served — and resets to zero only if the process restarts. You never read the raw counter value for a trend, you wrap it in `rate()` to get requests-per-second. Gauge can go up or down freely — current memory usage or number of open connections are classic gauges, and you read those directly. Histogram is for distributions — request latency is the textbook case — it buckets observations into ranges and tracks a count and sum, which lets you compute percentiles like p95 or p99 later with `histogram_quantile()`, rather than just an average that hides outliers."

### Follow-up Questions
- Why is a raw counter value on its own not directly useful for graphing?
- What's a Summary, and how is it different from a Histogram?
- Why would p95 latency matter more than average latency for user experience?

### Key Points
- Counter: only increases, use `rate()`/`increase()` for meaningful values — never graph raw.
- Gauge: freely goes up/down, read directly (memory, connection count, etc.).
- Histogram: bucketed observations, enables percentile calculation via `histogram_quantile()`.

---

## Q4. What does `rate()` actually compute, and why can't you just subtract two raw counter values yourself?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Deeper PromQL understanding beyond "rate gives you a rate" — handling counter resets.

### Expected Answer
`rate()` calculates the per-second average rate of increase of a counter over a given time range, and — critically — automatically handles counter resets (e.g. when a process restarts and the counter goes back to zero), extrapolating correctly instead of producing a nonsensical negative spike. Manually subtracting two raw values would break silently across a reset.

### Strong Interview Answer
"`rate()` computes the average per-second increase of a counter over the time window you give it, and it specifically accounts for counter resets — if the process restarted and the counter dropped back to zero mid-window, `rate()` detects that and adjusts the calculation instead of producing a huge negative number, which is exactly what you'd get if you naively subtracted an earlier raw value from a later one across a restart. That's why you should basically never do raw arithmetic on a counter yourself — always go through `rate()` or `increase()`."

### Follow-up Questions
- What's the difference between `rate()` and `increase()`?
- Why does `rate()` need a minimum time range, and what happens if the range is too short?
- How would a restart show up if you graphed the raw counter without `rate()`?

### Key Points
- `rate()` = per-second average increase, automatically handles counter resets.
- Manual subtraction across a restart produces a false negative spike — never do raw counter math.
- `increase()` gives total increase over the range instead of per-second rate — related but different use.

---

## Q5. How would you write a PromQL query for the 95th percentile request latency?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Practical PromQL fluency for one of the most commonly needed production queries.

### Expected Answer
Assuming a histogram metric like `http_request_duration_seconds_bucket`, the query is `histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))` — rate the bucket counters over a window, sum across instances grouped by the `le` (less-than-or-equal) bucket label, then compute the quantile from those bucket rates.

### Strong Interview Answer
"For a histogram like `http_request_duration_seconds_bucket`, I'd write `histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))`. The `rate()` gets the per-second rate of observations falling into each bucket over 5 minutes, the `sum by (le)` aggregates that across all instances while preserving the bucket boundaries — the `le` label — and `histogram_quantile` then estimates the 95th percentile value from that bucketed distribution. It's an estimate, not exact, because histogram buckets are discrete ranges, so bucket boundary choice affects precision."

### Follow-up Questions
- Why do you need to preserve the `le` label when summing across instances?
- What happens to accuracy if your histogram buckets are too coarse?
- How would you get p50, p95, and p99 all from the same underlying metric?

### Key Points
- `histogram_quantile(0.95, sum(rate(metric_bucket[5m])) by (le))` is the standard pattern.
- Must preserve the `le` label when aggregating — it's what defines the buckets.
- It's an estimate — bucket boundary granularity directly affects accuracy.

---

## Q6. How do you compute an error rate (percentage of failed requests) in PromQL?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Combining two counters into a meaningful derived ratio — a very common real dashboard/alert query.

### Expected Answer
Something like `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100` — rate of error-status requests divided by rate of all requests, expressed as a percentage. Using `rate()` on both numerator and denominator keeps the ratio meaningful even as raw traffic volume changes.

### Strong Interview Answer
"I'd write `sum(rate(http_requests_total{status=~\"5..\"}[5m])) / sum(rate(http_requests_total[5m])) * 100` — the rate of 5xx-status requests over the rate of all requests, times 100 for a percentage. Using `rate()` on both sides matters, because it keeps the ratio stable and meaningful regardless of whether overall traffic is high or low — a raw count ratio would be misleading if traffic volume itself is changing during the window."

### Follow-up Questions
- Why use `rate()` on both the numerator and denominator instead of just the numerator?
- How would you alert if this error rate exceeds 5% for 5 minutes straight?
- What status code range would you include for "errors" and why might you exclude some 4xx codes?

### Key Points
- Error rate = `rate(errors) / rate(total) * 100`.
- `rate()` on both sides keeps the ratio meaningful independent of traffic volume changes.
- Deciding which status codes count as "errors" (5xx typically, sometimes specific 4xx) is a judgment call.

---

## Q7. What's the difference between Prometheus and Grafana — why do you need both?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Whether you understand the storage/query engine vs. visualization split — commonly conflated by beginners.

### Expected Answer
Prometheus is the time-series database and query engine — it scrapes, stores, and lets you query metrics via PromQL, and it also handles alert rule evaluation. Grafana is a visualization layer — it queries data sources (including Prometheus, but also others) to build dashboards, graphs, and panels; it doesn't collect or store metrics itself.

### Strong Interview Answer
"Prometheus collects, stores, and lets you query the actual metric data via PromQL — it's the database and query engine, and it also evaluates alert rules. Grafana doesn't store any metrics itself; it's a visualization layer that queries data sources — Prometheus being a common one, but it can also pull from other sources — to build dashboards and graphs. You need both because Prometheus alone gives you raw query results with no polished visualization, and Grafana alone has nothing to visualize without a data source behind it."

### Follow-up Questions
- Could you use Grafana with a data source other than Prometheus?
- Does Grafana ever generate its own alerts, separately from Alertmanager?
- Where does Alertmanager fit relative to Prometheus and Grafana?

### Key Points
- Prometheus = storage + PromQL query engine + alert rule evaluation.
- Grafana = visualization layer querying data sources, doesn't store metrics itself.
- Grafana can visualize multiple data source types, not just Prometheus.

---

## Q8. What is Alertmanager's specific job, separate from Prometheus's alert rule evaluation?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you understand the division between "detecting" an alert condition and "handling" the resulting alert.

### Expected Answer
Prometheus evaluates alert rules and fires alerts when a condition is met, sending them to Alertmanager. Alertmanager then handles what happens with those firing alerts: deduplication, grouping related alerts together, routing to the correct notification channel (Slack, PagerDuty, email) based on labels, silencing, and inhibition (suppressing lower-priority alerts when a related higher-priority one is already firing).

### Strong Interview Answer
"Prometheus's job stops at deciding a condition is met and firing the alert — it sends that to Alertmanager. Alertmanager takes it from there: it deduplicates identical alerts firing from multiple sources, groups related alerts into a single notification instead of spamming ten separate pages for what's really one incident, routes alerts to the right channel — Slack for a warning, PagerDuty for critical — based on label matching, and supports silencing during planned maintenance and inhibition, where a critical alert firing suppresses related lower-priority alerts that are just noise at that point."

### Follow-up Questions
- What's inhibition, with a concrete example of when you'd configure it?
- How does Alertmanager route different severities to different notification channels?
- How would you silence alerts during a planned maintenance window without disabling the underlying alert rule?

### Key Points
- Prometheus evaluates rules and fires alerts; Alertmanager handles what happens next.
- Alertmanager: dedup, grouping, label-based routing, silencing, inhibition.
- Inhibition suppresses noisy downstream alerts when a related root-cause alert is already firing.

---

## Q9. How would you design an alert to avoid being too noisy (frequent false positives) or too quiet (missing real incidents)?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Real alerting design judgment — a mark of production maturity, not just knowing PromQL syntax.

### Expected Answer
Use a `for:` duration so a brief blip doesn't immediately fire (require the condition to hold for several minutes), pick thresholds based on actual historical data/SLOs rather than arbitrary numbers, alert on symptoms that actually affect users (error rate, latency) rather than every possible internal metric, and route by severity so non-urgent issues don't page someone at 3am.

### Strong Interview Answer
"I always add a `for:` duration so a brief, self-resolving blip doesn't immediately page someone — requiring the condition to hold for, say, 5 minutes filters out a lot of noise. I set thresholds based on actual historical data and what genuinely affects users, ideally tied to an SLO, rather than picking a round number that feels right. I try to alert on user-facing symptoms — error rate, latency, availability — rather than every internal metric that could theoretically indicate a problem, since too many low-value alerts train people to ignore all alerts, including the real ones. And severity routing matters: something that can wait until morning shouldn't page someone at 3am the same way something actively breaking production does."

### Follow-up Questions
- What's "alert fatigue" and why is it dangerous beyond just being annoying?
- How would you tie an alert threshold to an actual SLO instead of a gut-feel number?
- Give an example of a symptom-based alert vs. a cause-based alert, and which you'd generally prefer.

### Key Points
- `for:` duration filters transient blips from triggering immediate pages.
- Base thresholds on real historical data/SLOs, not arbitrary round numbers.
- Prefer symptom-based (user-facing) alerts over exhaustive cause-based internal alerts — reduces fatigue.

---
