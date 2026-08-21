# Jenkins — Agent (Node) Troubleshooting

## Agent shows offline
- Check the agent connection method: SSH, JNLP, or Docker
- For SSH agents: verify SSH key/credential, host key verification setting, and connectivity
  ```bash
  ssh -i /path/to/key agent-user@agent-host
  ```
- For JNLP agents: confirm the agent port (default 50000) is open and reachable, and the secret matches

## "Java not found" on agent
- Agents need a compatible JRE/JDK installed — Jenkins can auto-install via Tool Configuration, or install manually:
```bash
sudo apt install -y openjdk-17-jre
```

## Builds stuck in queue ("Waiting for next available executor")
- No agent matches the required label — check the job's "Restrict where this project can run" field
- All executors on matching agents are busy — add more executors or agents
- Check `Manage Jenkins → Nodes` for the agent's executor count

## Docker agent fails to start
```bash
docker ps -a | grep jenkins
docker logs <container-id>
```
- Confirm the Jenkins controller can reach the Docker daemon (socket mounted or DOCKER_HOST set)
- Check image pull succeeded — private registries need credentials configured on the Docker Cloud config

## Workspace conflicts between concurrent builds
- Use `disableConcurrentBuilds()` in pipeline options, or
- Use per-build workspaces: `options { skipDefaultCheckout(); ws("workspace/${env.BUILD_TAG}") }`

## Agent disconnects mid-build
- Check agent host resource pressure (OOM killer, disk full)
```bash
dmesg | grep -i "killed process"
df -h
```
- Network flakiness between controller and agent — check firewall/NAT timeout settings for long-lived JNLP connections
