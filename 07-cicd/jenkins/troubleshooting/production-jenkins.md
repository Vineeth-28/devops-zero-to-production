# Jenkins — Production Troubleshooting

## Controller performance degrading over time
- Check heap usage trend: `Manage Jenkins → System Information` → `Load Statistics`
- Enable GC logging and review for excessive full GCs
- Move builds off the controller entirely — set the controller's executor count to 0

## Config changes not taking effect
```bash
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token reload-configuration
```
- Some changes (e.g., security realm) require a full restart, not just a config reload

## Backup restore fails / instance won't start after restore
- Ensure file ownership matches the Jenkins service user after restore:
```bash
sudo chown -R jenkins:jenkins /var/lib/jenkins
```
- Version mismatch between backup source and restore target Jenkins version can cause plugin incompatibilities — restore into a matching version first, then upgrade

## RBAC misconfiguration locks everyone out
- Boot Jenkins with the setup wizard disabled and security temporarily off (see `jenkins.md` → "Forgot admin password") to regain access, then fix roles

## High availability / failover
- Jenkins controller itself isn't natively HA (no built-in multi-controller clustering) — standard approach is:
  - Fast, tested backup/restore process (RTO measured in minutes)
  - `JENKINS_HOME` on durable/replicated storage (EBS + snapshots, NFS, etc.)
  - Infrastructure-as-code for the controller itself so it can be rebuilt quickly

## Audit / "who ran this build" questions
- Install the "Audit Trail" plugin to log configuration changes and job triggers with user attribution
- Combine with RBAC so build/trigger actions are tied to real user accounts, not a shared service account

## Certificate / TLS issues behind reverse proxy
- Ensure `Manage Jenkins → System → Jenkins URL` matches the externally accessible HTTPS URL
- Set `X-Forwarded-*` headers correctly in the reverse proxy config so Jenkins generates correct webhook/callback URLs
