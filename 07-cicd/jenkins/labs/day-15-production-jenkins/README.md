# Day 15 — Production Jenkins

**Status:** ⬜ Not started

## Objectives
- Harden Jenkins for production use: security, RBAC, backups
- Understand scaling strategies (static agents vs dynamic/cloud agents)
- Introduce Shared Libraries for reusable pipeline code
- Plan for high availability and disaster recovery

## Lab Steps

1. **Security hardening**
   - Enable Role-based Authorization Strategy, define roles (admin, developer, viewer)
   - Enable CSRF protection (enabled by default in modern Jenkins — verify)
   - Restrict "Script Approval" for Groovy sandbox usage
   - Put Jenkins behind a reverse proxy (Nginx/Traefik) with TLS

2. **Backups**
   - Install the `thinBackup` plugin or script a `JENKINS_HOME` tarball backup
   - Test a full restore into a fresh instance

3. **Scaling agents**
   - Compare static SSH agents vs dynamic Docker agents vs Kubernetes plugin agents
   - Set executor limits per node appropriately (avoid overloading the controller)

4. **Shared Libraries**
   - Create a `vars/` shared library with a reusable `standardPipeline()` step
   - Reference it from a Jenkinsfile with `@Library('my-shared-library') _`

5. **Monitoring & alerting**
   - Install the Prometheus plugin to expose Jenkins metrics
   - Configure build failure notifications (Slack/email)

6. **Disaster recovery drill**
   - Simulate a controller failure, restore from backup, verify jobs and history are intact

## Key Takeaways
- Never run builds directly on the controller in production — use agents
- RBAC + credential scoping limits blast radius of a compromised job
- Shared libraries stop teams from copy-pasting Jenkinsfile boilerplate
- Backups are only as good as your last successful restore test

## Checklist
- [ ] RBAC configured with least-privilege roles
- [ ] Automated backup in place and restore tested
- [ ] At least one dynamic/cloud agent type configured
- [ ] Shared library created and used by a pipeline
- [ ] Build notifications wired up
