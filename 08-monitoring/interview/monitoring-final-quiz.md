# Monitoring Final Quiz (20 Questions)

Answer first, then check against the notes in the rest of `08-monitoring/`.
Answers are provided at the bottom — don't peek early.

1. Why does Prometheus use a pull model instead of push?
2. What is a target, in one sentence?
3. What is a job, in one sentence?
4. Why are labels important in Prometheus's data model?
5. What's the practical difference between a Counter and a Gauge?
6. Why do we apply `rate()` to Counters before graphing them?
7. What's the difference between `rate()` and `increase()`?
8. What does "p95 = 300ms" mean, in plain language?
9. In one sentence, what's the difference between Prometheus and Grafana's
   responsibilities?
10. In one sentence, what's the difference between Prometheus and
    Alertmanager's responsibilities?
11. Why do we deploy Node Exporter alongside application instrumentation?
12. **Troubleshooting scenario**: A target shows `up == 0`. What are your
    first two checks?
13. **Troubleshooting scenario**: A Grafana panel shows no data, but the
    underlying Prometheus query works fine in the Prometheus UI. What's a
    likely cause?
14. **Alerting scenario**: An alert rule's condition has been true for 30
    seconds but hasn't fired. Why not (assuming `for: 5m`)?
15. **Grafana scenario**: A dashboard needs to serve 10 different services
    without creating 10 separate dashboards. What Grafana feature solves this?
16. **Production scenario**: How would you design alerts so a full-cluster
    outage doesn't create 50 separate pages?
17. **Architecture scenario**: How would you monitor a Kubernetes cluster
    at the node, container, and cluster-object levels — name the tool for
    each.
18. Write (in words, not necessarily exact PromQL) how you'd compute HTTP
    error rate as a percentage.
19. Write (in words) how you'd compute p95 latency from a Histogram metric.
20. Why is Histogram generally preferred over Summary for latency in a
    multi-replica production service?

---

## Answers

1. Because it gives Prometheus centralized control over scrape cadence and
   makes target health trivial to detect (a failed scrape means the target
   is down), without requiring targets to manage delivery/retry logic.
2. A single scrapable endpoint (e.g. `10.0.1.10:9100`).
3. A named, logical grouping of targets scraped the same way.
4. Labels turn a single metric name into many distinct time series (e.g.
   per method, per status code), enabling filtering and aggregation.
5. A Counter only increases (resets on restart); a Gauge can go up or down
   and represents a current value.
6. Because a raw Counter graph is just an ever-climbing line — `rate()`
   converts it into a meaningful per-second trend and handles counter
   resets automatically.
7. `rate()` gives the per-second average rate of increase; `increase()`
   gives the total increase over the window.
8. Approximately 95% of observed requests completed in 300ms or less (the
   slowest 5% took longer).
9. Prometheus collects, stores, and queries metrics; Grafana visualizes
   query results and doesn't store data itself.
10. Prometheus evaluates alert rules and decides something is wrong;
    Alertmanager receives firing alerts and handles grouping, routing, and
    notification.
11. Application instrumentation only covers the app's own metrics — Node
    Exporter fills the gap for host-level (CPU/memory/disk/network) visibility.
12. Check whether the process/pod is actually running, and whether the
    target port is reachable from Prometheus (network/security group).
13. The panel's query, time range, or template variable differs from what
    you ran directly in the Prometheus UI — check those first.
14. The condition hasn't been continuously true for the full `for: 5m`
    duration yet — it's in Pending state, not Firing.
15. Template variables (e.g. `$service`), so one dashboard can be
    parameterized across services/environments.
16. Use Alertmanager grouping (batch related alerts into one notification)
    and inhibition (suppress lower-priority alerts once a related
    higher-priority one, like a full outage, is already firing).
17. Node level: Node Exporter. Container level: cAdvisor. Cluster-object
    level: kube-state-metrics.
18. Take the rate of 5xx responses over a window, divide by the rate of
    total responses over the same window, multiply by 100 for a percentage.
19. Take the rate of each histogram bucket's counter over a window,
    aggregate with `sum by (le)` across instances, then apply
    `histogram_quantile(0.95, ...)` to interpolate the 95th percentile.
20. Histogram bucket counts can be correctly aggregated (summed) across
    instances before computing a quantile; Summary quantiles are computed
    client-side per instance and can't be validly averaged together.
