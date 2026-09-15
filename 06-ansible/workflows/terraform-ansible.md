# Terraform + Ansible

**The clear boundary:**

| | Terraform | Ansible |
|---|---|---|
| Job | Provision/manage **infrastructure** | Configure **machines and services** |
| Model | Declarative resources + state file | Ordered, idempotent tasks |
| Targets | Cloud APIs (AWS/GCP/Azure) | Servers reachable over SSH/WinRM |
| Answers | "What infrastructure should exist?" | "What should be configured on it?" |

**Mental model:**
```
Terraform
    ↓
AWS
    ↓
Create VPC
    ↓
Create EC2
    ↓
EC2 available
    ↓
Ansible
    ↓
Install Docker
    ↓
Install/configure Nginx
    ↓
Deploy application
    ↓
Start services
```

## When Terraform is enough

Pure infrastructure changes with no in-instance configuration needed — e.g., a managed RDS instance, an S3 bucket, a load balancer, an autoscaling group using a pre-baked AMI that already has everything installed.

## When Ansible is enough

Configuration/software changes on machines that already exist — patching, deploying a new app release, changing a config file, rotating a service — where the underlying infrastructure isn't changing.

## When both are useful

The common production pattern: Terraform provisions the VPC/EC2/security groups/DNS, then hands off to Ansible (via a dynamic inventory sourced from Terraform outputs or a cloud inventory plugin) to install Docker, configure Nginx, and deploy the application onto the freshly provisioned instances.

## Why they complement each other

They operate at different layers and have different state models: Terraform's state file tracks *infrastructure* existence and drift; Ansible has no persistent state file and instead re-checks *configuration* idempotently on every run. Using Terraform to also hand-roll shell provisioners for app config (or Ansible to try to manage cloud resources long-term) tends to fight each tool's strengths — better to let each own its layer.

**Production use:** Trigger the Ansible run automatically after `terraform apply` in CI/CD, feeding it a dynamic inventory (e.g., the `amazon.aws.aws_ec2` inventory plugin) instead of a hand-maintained static file, so newly provisioned instances are configured without manual inventory edits.

**Common mistakes:** Using Terraform `provisioner "remote-exec"` for complex app configuration instead of handing off to Ansible (fragile, no idempotency, no re-run safety); letting Ansible playbooks create/destroy cloud resources ad hoc, causing drift Terraform doesn't know about.

**Troubleshooting:** If Ansible can't reach newly created instances, check whether the dynamic inventory plugin is actually picking up the new Terraform-tagged resources (tag-based inventory filtering is the usual culprit).

**Interview-ready answer:** "Terraform owns infrastructure provisioning and its state; Ansible owns configuration and application deployment on top of what's provisioned. In practice, Terraform creates the VPC/EC2/security groups, then Ansible — fed by a dynamic inventory from Terraform's output or a cloud inventory plugin — installs and configures everything on those instances. Keeping that boundary clean avoids fighting either tool's model."
