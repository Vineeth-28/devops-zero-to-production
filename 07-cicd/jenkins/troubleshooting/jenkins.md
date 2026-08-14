# Jenkins Troubleshooting — Day 11

## Jenkins not starting
```bash
sudo systemctl status jenkins
sudo journalctl -u jenkins -f
java -version
```

## Build failure
Start with **Console Output** and identify whether the problem is:
- Source code
- Dependencies
- Build command
- Tests
- Credentials
- Agent environment
- Network
- Docker permissions

## Agent offline
Investigate:
- Agent availability
- Network
- Authentication
- Runtime/Java
- Disk space

## Git checkout failure
Check:
- Repository URL
- Branch
- Credentials
- Network
- Repository permissions

## Docker permission failure
Investigate whether the Jenkins agent can access the Docker daemon.

## Production troubleshooting flow
```text
Observe → Read Logs → Identify Failure → Check Configuration → Test Smallest Failing Component → Fix → Re-run → Verify
```
