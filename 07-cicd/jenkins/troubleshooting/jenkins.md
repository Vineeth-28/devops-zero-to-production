# Jenkins — General Troubleshooting

## Jenkins won't start
```bash
sudo systemctl status jenkins
journalctl -u jenkins -n 100 --no-pager
```
Common causes:
- Port 8080 already in use → change port in `/etc/default/jenkins` (`HTTP_PORT`)
- Java version mismatch → Jenkins LTS requires Java 11 or 17 depending on version
- Corrupt `config.xml` → restore from backup, or move it aside and let Jenkins regenerate

## "Jenkins is loading" hangs forever
- Check disk space: `df -h` — a full disk on `/var/lib/jenkins` is a very common cause
- Check for a plugin causing a load loop — start with `-Djenkins.install.runSetupWizard=false` and inspect logs

## Forgot admin password
```bash
sudo systemctl stop jenkins
# Temporarily disable security in config.xml
sudo sed -i 's/<useSecurity>true<\/useSecurity>/<useSecurity>false<\/useSecurity>/' /var/lib/jenkins/config.xml
sudo systemctl start jenkins
# Log in without auth, recreate an admin user, then re-enable security
```

## Out of disk space
```bash
du -sh /var/lib/jenkins/jobs/*/builds/* | sort -h | tail -20
```
- Configure `buildDiscarder` on jobs to limit retained builds
- Clean old workspaces: `Manage Jenkins → Workspace Cleanup`

## Plugin dependency conflicts
- `Manage Jenkins → Plugins → Advanced` → check for incompatible versions
- Update all plugins together rather than one at a time to avoid cross-version breakage
- Keep a snapshot/backup before major plugin updates

## Slow UI / high memory usage
- Check `Manage Jenkins → System Information` for heap usage
- Increase JVM heap: edit `JAVA_ARGS="-Xmx2g"` in `/etc/default/jenkins`
- Reduce number of jobs shown on dashboard / disable unused views
