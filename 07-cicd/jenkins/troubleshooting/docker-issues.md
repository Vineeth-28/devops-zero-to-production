# Jenkins — Docker Troubleshooting

## "permission denied" on /var/run/docker.sock
- The `jenkins` user (or the Jenkins container's user) isn't in the `docker` group
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```
- If running Jenkins itself in Docker, mount the socket and match GIDs:
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock --group-add $(stat -c '%g' /var/run/docker.sock) ...
```

## "docker: command not found" inside pipeline
- The Docker CLI isn't installed on the agent (only the daemon is, on the host)
- Install `docker-ce-cli` on the agent, or use a Jenkins agent image that bundles the Docker CLI

## Image build fails with "no space left on device"
```bash
docker system df
docker system prune -af --volumes   # careful: removes unused images/containers/volumes
```
- Add periodic pruning to a maintenance job, or configure a larger disk for the Docker data root

## Push fails with "unauthorized: authentication required"
- Credential expired or wrong scope — re-check `docker login` succeeded before `docker push`
- For Docker Hub, ensure the access token has "Read & Write" permission, not just "Read"

## Docker-in-Docker (DinD) networking issues
- Containers started inside a DinD build can't be reached by sibling containers by default
- Prefer the "socket mounting" (Docker-outside-of-Docker) pattern for most CI use cases — simpler networking, shares image cache with the host

## Container immediately exits after `docker run` in deploy stage
```bash
docker logs <container-name>
```
- Usually an application crash on startup, not a Jenkins issue — check app logs and environment variables passed in
