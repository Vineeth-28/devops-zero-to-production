# Production Terraform Workflow — Full Stack View

## The Complete Chain

```
Developer
    ↓
GitHub
    ↓
Pull Request
    ↓
terraform fmt
    ↓
terraform validate
    ↓
terraform plan
    ↓
Code Review
    ↓
Approval
    ↓
terraform apply
    ↓
Infrastructure
    ↓
Monitoring
```

## Where Terraform Sits in the Broader DevOps Stack

```
GitHub
    ↓
CI/CD
    ↓
Terraform
    ↓
AWS Infrastructure
    ↓
Docker
    ↓
Kubernetes
    ↓
Helm
    ↓
Application
    ↓
Prometheus
    ↓
Grafana
```

Terraform's scope ends at "AWS Infrastructure" — everything from Docker
downward is a different tool's responsibility layered on top of what
Terraform provisioned. If Terraform builds the EKS cluster, Kubernetes
and Helm take over running workloads inside it; if Terraform builds
EC2/VPC/RDS for a more traditional setup, Ansible typically takes over
server configuration from there (see
`../concepts/terraform-overview.md` for the Terraform-vs-Ansible split).

## Monitoring Feedback Loop

Once infrastructure exists and applications are running on it,
Prometheus/Grafana monitor the *running system* — that's outside
Terraform's job, but Terraform can (and often does) provision the
monitoring infrastructure itself (e.g. a managed Prometheus workspace,
CloudWatch alarms, an EC2 instance running Grafana) as just another set
of resources in the same configuration.

## Full-Stack Mental Model to Keep in Mind

```
Terraform
    ↓
Desired Infrastructure
    ↓
Provider
    ↓
Plan
    ↓
State
    ↓
Apply
    ↓
Cloud Infrastructure
```

Every workflow in this handbook — local, AWS-specific, module-based, or
CI/CD — is ultimately just a different lens on this same loop.
