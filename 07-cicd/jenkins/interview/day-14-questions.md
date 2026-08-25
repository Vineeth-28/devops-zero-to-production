# Day 14 — Interview Questions: Jenkins + Docker

1. What are the benefits of using Docker containers as Jenkins build agents?
2. Explain "Docker-outside-of-Docker" (socket mounting) vs "Docker-in-Docker" (DinD). What are the trade-offs of each?
3. Why is mounting `/var/run/docker.sock` into a Jenkins container considered a security consideration, not just a convenience?
4. How do you authenticate to a private Docker registry from a pipeline without hardcoding credentials?
5. What's a sensible image tagging strategy for CI-built images, and why avoid relying solely on `latest`?
6. How would you keep a Jenkins host from running out of disk space due to Docker image buildup?
7. Describe a deploy stage that safely replaces a running container with a newly built image.
8. How would you scan a built image for vulnerabilities as part of the pipeline?

<details><summary>Answer notes</summary>

- Q3: Mounting the socket effectively gives root-equivalent access to the host — any job that can run `docker` commands can escape its "container" isolation. Mitigate with RBAC on who can edit pipeline code, and consider dedicated build hosts for untrusted jobs.
- Q5: Tag with a unique, traceable identifier (build number, git SHA) in addition to `latest`, so any deployed version can be pinned and rolled back precisely.
- Q6: Schedule `docker system prune` periodically, or use ephemeral build agents that are destroyed after each build.
</details>
