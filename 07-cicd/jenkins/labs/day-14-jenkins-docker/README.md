# Day 14 — Jenkins + Docker

**Status:** ⬜ Not started

## Objectives
- Use Docker containers as build agents (ephemeral, clean environments)
- Build and push Docker images from a pipeline
- Understand Docker-in-Docker (DinD) vs mounting the host socket
- Deploy a container as the final pipeline stage

## Lab Steps

1. **Install Docker Pipeline plugin**
   - Manage Jenkins → Plugins → search "Docker Pipeline"

2. **Use a Docker agent for a build**
   - `agent { docker { image 'node:20-alpine' } }`
   - Confirm the build runs isolated, with no leftover state between runs

3. **Build and push an image**
   - Use `jenkinsfiles/docker/Jenkinsfile` from this repo
   - Configure Docker Hub credentials in Jenkins
   - Build, tag with `${BUILD_NUMBER}` and `latest`, push both tags

4. **Docker socket vs Docker-in-Docker**
   - Compare mounting `/var/run/docker.sock` into the Jenkins container (simpler, shares host daemon)
     vs running a full DinD sidecar (more isolated, more complex)
   - Discuss security implications of socket mounting

5. **Deploy stage**
   - Add a `when { branch 'main' }` deploy stage that stops/removes the old container and runs the new image

## Key Takeaways
- Docker agents give reproducible, disposable build environments
- Mounting the Docker socket is the common (if imperfect) approach for Jenkins-in-Docker setups
- Always tag images with a unique build identifier, not just `latest`

## Checklist
- [ ] Docker Pipeline plugin installed
- [ ] Pipeline runs inside a Docker agent successfully
- [ ] Image built, tagged, and pushed to a registry
- [ ] Deploy stage runs only on `main` branch
