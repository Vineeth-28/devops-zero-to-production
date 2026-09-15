# Monitoring Interview Questions (Beginner -> Scenario-Based)

## Beginner

1. What is monitoring, and why do we need it?
2. What's the difference between monitoring and observability, at a high level?
3. What is Prometheus?
4. What is the pull model, and why does Prometheus use it instead of push?
5. What is a target? What is a job?
6. What is the `/metrics` endpoint?
7. What is `scrape_interval`?
8. What are the four Prometheus metric types?
9. What's the difference between a Counter and a Gauge?
10. What is Node Exporter used for?

## Intermediate

11. What is a label, and why does it matter for cardinality?
12. Why would you use `rate()` instead of graphing a Counter directly?
13. What's the difference between `rate()` and `increase()`?
14. What's the difference between `by` and `without` in aggregation?
15. What is a Histogram, and how does `histogram_quantile()` work?
16. Why is Histogram preferred over Summary when aggregating across
    replicas?
17. What is PromQL, and what are instant vectors vs range vectors?
18. What is Grafana's relationship to Prometheus — does Grafana store data?
19. What is an alert rule's `for:` duration, and why does it matter?
20. What's the difference between Prometheus and Alertmanager
    responsibilities?
21. What is alert grouping in Alertmanager, and why is it useful?
22. What is alert inhibition?
23. What is a silence in Alertmanager?
24. What does `promtool check config` do, and when should you run it?
25. What's the difference between `/-/healthy` and `/-/ready`?

## Production

26. How would you calculate application error rate in PromQL?
27. How would you calculate p95 latency from a Histogram?
28. Why might you alert on p95/p99 latency instead of average latency?
29. What's a cardinality explosion, and how would you detect one?
30. How would you design alert severity levels and routing?
31. What is a recording rule, and when would you use one?
32. How would you structure Prometheus scrape configs in Kubernetes
    (static vs service discovery)?
33. What's the role of `kube-state-metrics` vs `cAdvisor` vs Node Exporter?
34. How would you avoid alert fatigue on a noisy metric like CPU?
35. What retention strategy would you use for long-term metrics storage?
36. Why should `/metrics` endpoints not be publicly exposed without controls?
37. How does Grafana's `access: proxy` datasource mode differ from `direct`,
    and why does it matter?
38. How would you provision Grafana dashboards and datasources as code?
39. What's the value of tagging alerts with `severity` labels consistently?
40. How would you connect Terraform, Ansible, Docker, Kubernetes, Helm,
    CI/CD, and monitoring into one coherent pipeline description?

## Scenario-based

41. A target shows `up == 0`. Walk through your troubleshooting steps.
42. A Grafana panel shows "No data" but the dashboard used to work. What do
    you check first?
43. An alert is supposed to be firing but nothing has notified. Where do
    you look, in order?
44. Prometheus's memory usage keeps climbing. What's your first hypothesis
    and how do you confirm it?
45. Your error-rate alert keeps flapping (firing and resolving repeatedly).
    How would you fix the alert definition?
46. A new microservice was deployed to Kubernetes but isn't showing up in
    Prometheus. What's likely missing?
47. You're asked to design alerting for a new production API from scratch.
    What signals do you alert on first, and why?
48. During an incident, dozens of unrelated alerts fire at once. How would
    inhibition/grouping have helped, and how would you configure it?
49. A dashboard shows p95 latency looking fine, but users are reporting
    slowness. What could explain the disconnect?
50. You need to monitor a Postgres database for the first time. What would
    you add, and what would you alert on?
