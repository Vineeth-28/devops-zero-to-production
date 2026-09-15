# Full Workflow: Prometheus + Grafana (and the Rest of the Stack)

## Core monitoring workflow
```
Linux Server
    |
Node Exporter
    |
Prometheus
    |
PromQL
    |
Grafana
    |
Dashboard
```
Grafana queries Prometheus (via PromQL through the Prometheus datasource);
Prometheus handles collection, storage, and querying; Grafana is purely
the visualization layer.

## Full DevOps stack integration

```
Developer
    |
GitHub
    |
Jenkins / GitHub Actions
    |
Docker
    |
Container Registry
    |
Kubernetes
    |
Helm
    |
Application
    |
Prometheus
    |
Grafana
    |
Alerts / Alertmanager

Infrastructure:

Terraform
    |
AWS
    |
EC2 / VPC / etc.
    |
Ansible
    |
Configuration
    |
Monitoring
```

## Responsibility of each tool
| Tool | Responsibility |
|---|---|
| Terraform | Infrastructure provisioning (VPC, EC2, EKS, IAM, etc.) |
| Ansible | Configuration/automation on provisioned infrastructure |
| Docker | Containerization of the application |
| Kubernetes | Container orchestration, scheduling, scaling |
| Helm | Kubernetes packaging and release management |
| Jenkins / GitHub Actions | CI/CD — build, test, scan, deploy |
| Prometheus | Metrics collection, storage, querying, alert rule evaluation |
| Grafana | Visualization/dashboards |
| Alertmanager | Alert routing/grouping/notification |

## How this maps to a real deploy
1. Terraform provisions the VPC/EKS cluster
2. Ansible (or Terraform provisioners/user-data) configures base nodes
3. CI (Jenkins/GitHub Actions) builds and pushes a Docker image on every commit
4. Helm deploys the app to Kubernetes, including its own `/metrics` endpoint
5. Prometheus (via Kubernetes service discovery, often the Prometheus
   Operator's ServiceMonitor CRD) automatically starts scraping the new pods
6. Grafana dashboards already pointed at Prometheus immediately show the
   new service's metrics — no manual wiring needed if labels/conventions
   are consistent
7. Alert rules already defined fire against the new service the same way
   they do for existing ones, routed through Alertmanager

## Why this matters for interviews
Interviewers often ask you to "draw the pipeline end to end" — the value
is in explaining *why* each tool sits where it does (provisioning vs
configuration vs orchestration vs observability), not just naming them in
order.

## Interview-ready answer
"The DevOps stack layers cleanly: Terraform provisions infrastructure,
Ansible configures it, Docker packages the app, Kubernetes orchestrates
containers, Helm manages releases, CI/CD automates build-test-deploy, and
Prometheus/Grafana/Alertmanager provide observability across all of it.
Because Kubernetes-native monitoring uses service discovery, a new service
deployed through this pipeline gets scraped and alertable automatically
without manual Prometheus reconfiguration."
