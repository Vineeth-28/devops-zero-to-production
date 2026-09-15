# Monitoring Troubleshooting — Decision Trees

Each scenario follows: Symptom -> Likely cause -> What to check -> Useful
command/UI check -> Fix -> Verification.

---

## 1. Target DOWN
- **Symptom**: `up{job="x", instance="y"} == 0`
- **Likely cause**: process/pod not running, wrong port, network blocked
- **What to check**: process status, port binding, security group/NetworkPolicy
- **Command/UI**: `curl http://<target>:<port>/metrics`; `/api/v1/targets` in Prometheus UI
- **Fix**: restart process, correct port in scrape config, open firewall rule
- **Verification**: target shows `up == 1` on next scrape

## 2. Prometheus cannot scrape target
- **Symptom**: target listed but scrape errors in Prometheus UI
- **Likely cause**: DNS resolution failure, TLS mismatch, timeout
- **What to check**: `scrape_timeout` vs actual response time, DNS from Prometheus pod/host
- **Command/UI**: `/api/v1/targets` shows the exact scrape error message
- **Fix**: fix DNS/network path, increase timeout, fix TLS config
- **Verification**: error clears, `up == 1`

## 3. /metrics unavailable
- **Symptom**: `curl target:port/metrics` returns 404/connection refused
- **Likely cause**: app not exposing the endpoint, wrong path, app crashed
- **What to check**: app logs, correct `metrics_path` in scrape config
- **Command/UI**: direct curl to the endpoint, bypassing Prometheus
- **Fix**: fix app instrumentation/routing, correct `metrics_path`
- **Verification**: curl returns metric text

## 4. Node Exporter unavailable
- **Symptom**: `up{job="node"} == 0`
- **Likely cause**: process not running, port 9100 blocked
- **What to check**: systemd/pod status, port 9100 reachability
- **Command/UI**: `curl target:9100/metrics`
- **Fix**: restart Node Exporter, open port/NetworkPolicy
- **Verification**: `up == 1`, metrics visible

## 5. Wrong target address
- **Symptom**: scrape errors referencing an unexpected host/port
- **Likely cause**: stale static config, IP changed (common with dynamic infra)
- **What to check**: `prometheus.yml` static_configs, or SD relabeling rules
- **Command/UI**: `/api/v1/targets` shows resolved address
- **Fix**: correct address, or move to service discovery to avoid this class of bug
- **Verification**: correct target appears and is `up`

## 6. Network/security-group issue
- **Symptom**: connection refused/timeout only from Prometheus's network, works locally on the host
- **Likely cause**: security group / firewall / NetworkPolicy blocking the scrape port
- **What to check**: SG rules, K8s NetworkPolicy, VPC routing
- **Command/UI**: `curl` from inside the Prometheus pod/host specifically
- **Fix**: open the required port between Prometheus and target
- **Verification**: scrape succeeds

## 7. Prometheus configuration error
- **Symptom**: Prometheus fails to start, or reload fails
- **Likely cause**: invalid YAML, duplicate job names, bad regex
- **What to check**: syntax and structure of `prometheus.yml`
- **Command/UI**: `promtool check config prometheus.yml`
- **Fix**: correct YAML per promtool's error output
- **Verification**: `promtool check config` passes, reload succeeds

## 8. Prometheus not reloading configuration
- **Symptom**: config file changed but behavior unchanged
- **Likely cause**: no reload triggered, or `--web.enable-lifecycle` not set
- **What to check**: whether `/-/reload` is enabled; whether SIGHUP was sent
- **Command/UI**: `curl -X POST http://localhost:9090/-/reload`
- **Fix**: enable lifecycle flag, or restart the process/pod
- **Verification**: new config reflected in `/api/v1/status/config`

## 9. Missing metrics
- **Symptom**: expected metric name doesn't appear in Prometheus at all
- **Likely cause**: app not instrumented for it, exporter version mismatch, metric renamed
- **What to check**: raw `/metrics` output from the target directly
- **Command/UI**: `curl target/metrics | grep <metric_name>`
- **Fix**: fix instrumentation, update metric name in queries/dashboards
- **Verification**: metric appears in raw scrape output and in Prometheus

## 10. PromQL returns no data
- **Symptom**: query in Grafana/Prometheus UI returns empty
- **Likely cause**: wrong label value, metric doesn't exist for that selector, time range issue
- **What to check**: query the bare metric name first, then add filters incrementally
- **Command/UI**: Prometheus UI's Table view; Grafana's Explore
- **Fix**: correct label/selector, widen time range
- **Verification**: query returns expected series

## 11. Incorrect labels
- **Symptom**: query returns series but grouped/filtered wrong
- **Likely cause**: typo in label name/value, case sensitivity, unexpected relabeling
- **What to check**: actual label set on the raw metric (Prometheus UI, click a series)
- **Command/UI**: `<metric_name>` with no filter, inspect labels shown
- **Fix**: correct the selector or relabel_config
- **Verification**: expected series returned

## 12. Grafana datasource failure
- **Symptom**: "Datasource Error" banner in Grafana
- **Likely cause**: wrong URL, network unreachable, auth failure
- **What to check**: datasource config, network path from Grafana to Prometheus
- **Command/UI**: Grafana's "Test" button on datasource settings page
- **Fix**: correct URL/credentials, fix network path
- **Verification**: "Test" succeeds, panels load

## 13. Grafana dashboard shows no data
- **Symptom**: panels blank, no error shown
- **Likely cause**: wrong time range, query returns nothing, variable mismatch
- **What to check**: run the panel's query directly in Explore; check selected time range
- **Command/UI**: Grafana Explore view with the exact panel query
- **Fix**: correct query/time range/variable value
- **Verification**: panel renders data

## 14. Incorrect time range
- **Symptom**: dashboard looks empty or shows old data unexpectedly
- **Likely cause**: dashboard default time range set far outside when data exists
- **What to check**: top-right time picker
- **Command/UI**: reset to "Last 1h" / "Last 6h" and confirm data appears
- **Fix**: correct default dashboard time range in dashboard settings
- **Verification**: correct data shown for the intended window

## 15. Alert not firing
- **Symptom**: condition is clearly true but no alert/notification
- **Likely cause**: `for:` duration not yet elapsed, rule file not loaded, expr typo
- **What to check**: Prometheus UI's Alerts page (Pending vs Firing state)
- **Command/UI**: `promtool check rules rules.yml`; Prometheus `/alerts` page
- **Fix**: fix expr, wait for `for:` duration, ensure rule_files path is correct
- **Verification**: alert transitions Pending -> Firing as expected

## 16. Alert firing unexpectedly
- **Symptom**: alert fires when nothing seems wrong
- **Likely cause**: threshold too sensitive, missing `for:` buffer, bad query logic
- **What to check**: the exact PromQL expression against real data at the time
- **Command/UI**: re-run `expr` manually in Prometheus UI for the alert's timeframe
- **Fix**: adjust threshold/`for:` duration, fix query logic
- **Verification**: alert no longer fires on normal conditions, still fires on real ones

## 17. Alertmanager notification failure
- **Symptom**: alert shows Firing in Prometheus but no Slack/PagerDuty message arrives
- **Likely cause**: routing tree doesn't match alert labels, receiver misconfigured (bad webhook/API key)
- **What to check**: Alertmanager's routing tree against the alert's actual labels; receiver config
- **Command/UI**: Alertmanager UI shows the alert and which route it matched
- **Fix**: correct route matchers or receiver credentials
- **Verification**: test alert successfully notifies the intended channel

## Interview-ready answer
"My troubleshooting approach for monitoring issues always starts at the
source and works downstream: first confirm the target is scrapeable
(`/api/v1/targets`, direct curl to `/metrics`), then confirm Prometheus has
the data (PromQL in the Prometheus UI directly), then confirm Grafana's
query/time range/variables are correct, and only then look at
alerting/Alertmanager routing. Isolating which layer is broken first saves
a lot of time versus guessing."
