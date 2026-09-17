# Docker Interview Questions

Based on `../03-docker/` (commands/, dockerfiles/, troubleshooting/, workflows/).

---

## Q1. What's the precise difference between an image and a container?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Foundational Docker vocabulary — surprisingly often answered vaguely.

### Expected Answer
An image is a read-only, layered template — the packaged filesystem and metadata needed to run something. A container is a running (or stopped) instance of that image, with its own writable layer on top and its own process/network namespace. One image can spin up many containers.

### Strong Interview Answer
"An image is the static, read-only blueprint — layers of filesystem changes plus metadata like the entrypoint. A container is what you get when you run that image: a live instance with a thin writable layer on top, its own process space, and its own network namespace. The image doesn't change when the container runs; any writes go into the container's own layer, which disappears with the container unless you've mounted a volume."

### Follow-up Questions
- What happens to data written inside a container if you don't use a volume?
- How many containers can you run from one image?
- What's in an image's metadata besides the filesystem layers?

### Key Points
- Image = static read-only template; container = running instance with a writable layer.
- Container writes are ephemeral unless persisted via a volume.
- One image → many independent containers.

---

## Q2. A `docker build` fails partway through. How do you debug it?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you understand layer caching and can isolate which instruction failed instead of re-running the whole build blind.

### Expected Answer
Read the exact error and which `RUN`/step it failed on — Docker prints the failing instruction. Use the last successful cached layer's image ID to run an interactive container from that point (`docker run -it <layer-id> sh`) to reproduce the failure manually. Common causes: missing dependency, wrong base image, network-blocked package install, wrong build context/path.

### Strong Interview Answer
"Docker tells you exactly which instruction failed, so first I read that output carefully rather than assuming. Then I usually run an interactive container from the last cached layer before the failure — `docker run -it <cached-layer-id> sh` — and manually run the failing command to see the real error, since build logs sometimes truncate output. Common causes I've hit: a package that needs network access being blocked mid-build, a COPY referencing a path outside the build context, or a base image version mismatch."

### Follow-up Questions
- How does Docker's layer cache actually work, and how can it hide a stale dependency?
- What's the build context, and how can it cause a `COPY` to fail?
- How would you force a build to ignore cache and rebuild everything?

### Key Points
- Docker's error output names the exact failing instruction — read it first.
- Reproduce interactively from the last good cached layer to get the full error.
- Common causes: network-blocked installs, bad COPY paths, base image drift.

---

## Q3. A container exits immediately after starting. How do you find out why?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Practical debugging flow for one of the most common Docker issues.

### Expected Answer
Check `docker ps -a` for the exit code, then `docker logs <container>` for the actual error output. Common causes: the main process crashes immediately (bad config, missing env var), the entrypoint/CMD is wrong so there's nothing keeping the container alive, or it's a foreground-only image but was misconfigured to background.

### Strong Interview Answer
"First `docker ps -a` to see the exit code — that alone narrows things down, like 137 usually means OOM-killed. Then `docker logs <container>` for the actual stdout/stderr the process printed before dying. If logs are empty, it's often that the entrypoint command itself is wrong or missing, so there's no long-running foreground process to keep the container alive. I'll also try `docker run -it <image> sh` to get an interactive shell and manually run the intended start command to see the real error live."

### Follow-up Questions
- What does exit code 137 specifically indicate?
- Why does a container need a foreground process to stay running?
- How would you keep a container running to debug it even if the app crashes?

### Key Points
- `docker ps -a` for exit code, `docker logs` for the actual error.
- Exit code 137 = OOM-killed (SIGKILL); 1 = generic app error; 0 = clean exit (unexpected for a service).
- Containers exit when their main foreground process exits — no process, no container.

---

## Q4. How does container-to-container networking and DNS work with Docker Compose or a custom bridge network?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Real understanding of Docker's embedded DNS, not just "they can talk to each other."

### Expected Answer
Containers on the same user-defined bridge network can reach each other by service/container name — Docker runs an internal DNS server that resolves those names to the container's IP on that network. This doesn't work on the default bridge network without explicit linking; it's why user-defined networks (which Compose creates automatically) are preferred.

### Strong Interview Answer
"On a user-defined bridge network — which is what Compose sets up by default — Docker runs its own embedded DNS, so containers can reach each other just by service name, like the app container connecting to `db:5432` instead of a hardcoded IP. That only works on user-defined networks; the old default bridge network doesn't do automatic name resolution, so containers there would need explicit `--link` or an IP address, which is why user-defined networks are the standard now."

### Follow-up Questions
- Why doesn't the default bridge network support name-based resolution?
- How would you connect containers across two different Compose projects?
- What happens to that internal DNS resolution if you scale a service to multiple replicas?

### Key Points
- User-defined bridge networks give automatic DNS resolution by container/service name.
- Default bridge network lacks this — legacy behavior, avoid relying on it.
- Compose creates a user-defined network automatically per project.

---

## Q5. `depends_on` says a service started, but the app still fails to connect to the database on startup. Why?

**Difficulty:** 🔴 Production

### What the interviewer is testing
A very common real-world gotcha — knowing that `depends_on` (without a health check) only waits for the container process to start, not for the service inside to be ready.

### Expected Answer
`depends_on` alone waits for the dependency container to be running, not for the application inside it to actually be ready to accept connections (e.g. Postgres takes a few seconds to initialize after its process starts). The fix is `depends_on` with `condition: service_healthy`, backed by a proper `HEALTHCHECK`, or an application-level retry/backoff on the connection.

### Strong Interview Answer
"That's a classic gap — plain `depends_on` only guarantees the dependency's container has started, not that the service inside it is actually accepting connections yet. Postgres, for example, might take a couple seconds after its process starts before it's ready for connections. The fix is using `depends_on` with `condition: service_healthy`, paired with a real `HEALTHCHECK` on the database image that checks readiness, not just that the process is running. I'd also add connection retry logic in the app itself as a second layer of defense, since network blips happen even after startup."

### Follow-up Questions
- How do you write a `HEALTHCHECK` for a database container?
- What's the difference between a container being "running" and being "ready"?
- Why is app-level retry logic still valuable even with health checks configured?

### Key Points
- `depends_on` alone = container started, not "ready."
- `condition: service_healthy` + a real `HEALTHCHECK` closes that gap.
- App-level retry/backoff is a good second layer even with health checks.

---

## Q6. What are multi-stage builds, and why do you use them beyond just reducing image size?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you know the security angle, not just "smaller image" — a deeper answer signals real production experience.

### Expected Answer
Multi-stage builds let you use one stage with build tools (compilers, dev dependencies) to build the artifact, then copy only the final artifact into a clean, minimal final stage. Beyond size, this reduces attack surface — build tools, source code, and secrets used during build (like private registry credentials) don't end up in the final image that ships to production.

### Strong Interview Answer
"Multi-stage builds let me separate 'build' from 'run.' The build stage can have compilers, dev dependencies, even build-time secrets, and none of that ends up in the final image — I only `COPY --from=build` the compiled artifact into a clean, minimal base like `alpine` or `distroless`. The size reduction is nice, but the real value in production is security: fewer packages means smaller attack surface, and critically, build-time secrets or source code that shouldn't ship don't leak into what's actually deployed."

### Follow-up Questions
- How would you securely pass a build-time secret without it ending up in a layer?
- What's a `distroless` image and why would you choose it for the final stage?
- Can you name the stages in a multi-stage Dockerfile and what each is typically responsible for?

### Key Points
- Build stage has tooling/dependencies; final stage only gets the compiled artifact.
- Security benefit: reduced attack surface, no leaked build secrets/source in production image.
- Also reduces image size and pull/deploy time.

---

## Q7. An application works fine locally in Docker but fails in production. What are your hypotheses?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Systematic thinking about environment drift — a very common real interview scenario.

### Expected Answer
Common causes: environment variable/config differences, different image tag (`:latest` drifting between environments), resource limits in production causing OOM that don't exist locally, network/DNS differences (service names, security groups), file permission differences (running as non-root in prod), or a dependency on local-only state (bind-mounted files not present in prod).

### Strong Interview Answer
"I'd work through the differences between the two environments systematically. First, is it actually the same image — if we're using `:latest` there's a real chance production pulled a different build than what I tested locally, which is exactly why I push for immutable tags. Then I'd check environment variables and secrets — are they actually set the same way. Then resource limits — locally there's often no memory/CPU cap, but production might have limits causing an OOM kill. Then networking — service names and DNS resolution can differ between Compose locally and an orchestrator in production. And finally permissions — many production images run as non-root, which can break something that assumed root access locally."

### Follow-up Questions
- Why is `:latest` risky for reproducing a bug between environments?
- How would you confirm it's an OOM issue rather than an app bug?
- What would you check first if it's a networking-related difference?

### Key Points
- Never trust `:latest` — pin immutable tags to guarantee "same image" between environments.
- Check resource limits (OOM), environment/config drift, network/DNS differences, and non-root permission differences.
- Systematic elimination beats guessing.

---

## Q8. How do you safely clean up disk space used by Docker without breaking anything running?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Awareness of the destructive potential of cleanup commands and how to scope them safely.

### Expected Answer
`docker system df` to see what's using space first. `docker image prune` removes only dangling (untagged) images — safe. `docker system prune` removes stopped containers, unused networks, and dangling images — check what's running first. `docker system prune -a` additionally removes all unused (not just dangling) images, which can be aggressive if you're about to redeploy something you just cleaned up.

### Strong Interview Answer
"I start with `docker system df` to see the actual breakdown of what's using space — images, containers, volumes, build cache. Then I clean up in order of safety: `docker image prune` for dangling/untagged images first, that's low-risk. `docker system prune` goes further, removing stopped containers and unused networks too, so I check `docker ps -a` first to make sure nothing stopped-but-needed gets swept up. I'm cautious with `-a` on prune, since it removes any image not currently backing a running container, which could force an unnecessary re-pull later."

### Follow-up Questions
- What's the difference between a dangling image and an unused image?
- Would `docker system prune` ever remove a volume by default?
- How would you clean up build cache specifically?

### Key Points
- `docker system df` first, to see what's actually consuming space.
- Prune in increasing order of aggressiveness; check `docker ps -a` before broad prunes.
- Volumes aren't removed by default prune — need `--volumes` explicitly, and that's genuinely destructive.

---

## Q9. A container can't reach the database. Walk me through your troubleshooting, layer by layer.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Layered troubleshooting discipline applied specifically to container networking.

### Expected Answer
Check if the containers are on the same network (`docker network inspect`). Check DNS resolution from inside the app container (`getent hosts db` or similar). Check if the database container is actually up and healthy (`docker ps`, `docker logs db`). Check the port the app is trying vs the port the DB is actually listening on. Check credentials/connection string last, once network path is confirmed working.

### Strong Interview Answer
"I go network out to application in. First, are both containers even on the same Docker network — `docker network inspect` confirms that. Then, from inside the app container, can it resolve the DB hostname at all, using something like `getent hosts db` or a quick `nslookup`. Then, is the DB container actually running and healthy — `docker ps` and `docker logs db` for startup errors. Then I check the port matches — sometimes the app is configured for the wrong port. Only once the network path is confirmed working do I look at credentials, because a lot of 'connection refused' issues get mistaken for auth issues when it's really that the app never reached the DB at all."

### Follow-up Questions
- How would you get an interactive shell inside a running container to test connectivity?
- What tool would you use to test a TCP connection from inside a container without extra installs?
- Why check network reachability before credentials?

### Key Points
- Layer order: same network → DNS resolution → DB container health → port match → credentials.
- `docker network inspect` and `docker logs` are the first diagnostic stops.
- Don't jump to "wrong password" before confirming the network path actually works.

---

## Q10. What's the difference between a volume and a bind mount, and when would you use each?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Whether you understand Docker-managed storage vs directly mapping host paths, and the tradeoffs.

### Expected Answer
A named volume is managed by Docker, stored in Docker's own area, portable and decoupled from host filesystem layout — good for persistent app data like databases. A bind mount maps a specific host path directly into the container — good for local development (live code reload) but ties you to the host's filesystem structure and isn't portable across machines.

### Strong Interview Answer
"A volume is Docker-managed storage — I don't need to know or care where it physically lives on the host, and it's portable between environments, which makes it the right choice for something like a database's data directory in production. A bind mount maps an exact host directory into the container, which is great for local development — I mount my source code directory in so changes show up live without rebuilding — but it ties the container to that host's specific filesystem layout, so it's not something I'd rely on for production persistence."

### Follow-up Questions
- Why would a bind mount be a bad choice for a production database's data directory?
- How do you back up a named volume?
- What's a `tmpfs` mount and when would that be useful?

### Key Points
- Named volume = Docker-managed, portable, right for production persistent data.
- Bind mount = direct host path mapping, great for local dev live-reload, not portable.
- Production persistence generally favors volumes over bind mounts.

---

## Q11. What does `.dockerignore` do and why does it matter for build performance and security?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Whether you understand build context and its performance/security implications.

### Expected Answer
`.dockerignore` excludes files/directories from being sent to the Docker daemon as part of the build context, similar to `.gitignore`. This speeds up builds (smaller context to transfer) and prevents accidentally copying sensitive files (`.env`, `.git`, credentials) into an image layer via a broad `COPY . .`.

### Strong Interview Answer
"When you run `docker build`, the entire build context — everything in that directory — gets sent to the Docker daemon, and anything not excluded can end up copied into a layer with `COPY . .`. `.dockerignore` excludes things like `.git`, `node_modules`, and critically `.env` files or credentials, from that context entirely. Beyond keeping images lean and builds fast, it's a real security control — I've seen `.env` files with secrets accidentally baked into an image layer because there was no `.dockerignore`, and that layer persists in the image history even if a later step deletes the file."

### Follow-up Questions
- Why doesn't deleting a file in a later Dockerfile step remove it from the image entirely?
- What files do you always put in `.dockerignore`?
- How does a large build context slow down `docker build` even before any instruction runs?

### Key Points
- `.dockerignore` excludes files from the build context sent to the daemon.
- Prevents accidental secret leakage via broad `COPY . .`.
- Deleting a file in a later layer doesn't remove it from earlier layers in image history.

---

## Q12. What's the risk of using the `latest` tag in production, with a concrete scenario?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Whether you've actually been burned by this or understand the real operational risk, not just "it's bad practice."

### Expected Answer
`latest` is a mutable, floating tag — it can point to a different image tomorrow than it does today. In production this means you lose reproducibility: a redeploy or a new node pulling the image can silently get a different version than what's currently running elsewhere, causing inconsistent behavior across replicas, and rollbacks become guesswork since you don't know exactly what "latest" was at any past point.

### Strong Interview Answer
"The core problem is `latest` isn't a version, it's just whatever was pushed last — it's mutable. So imagine a rolling deployment: three pods are running, one gets rescheduled onto a new node and pulls the image fresh — if someone pushed a new `latest` in between, that one pod is now running different code than its siblings, silently, with no deploy event to explain it. It also breaks rollback: if something goes wrong, I can't just 'go back to latest' because I don't actually know what version that referred to an hour ago. I always use immutable tags — a git SHA or semantic version — so what's running is exactly reproducible and traceable."

### Follow-up Questions
- How would immutable tagging change your rollback process?
- What tagging scheme have you used or would you recommend (SHA, semver, both)?
- How does `imagePullPolicy` in Kubernetes interact with this risk?

### Key Points
- `latest` is mutable — not a version, just "whatever was last pushed."
- Causes silent version drift between replicas/nodes on redeploy or rescheduling.
- Immutable tags (git SHA, semver) make deployments reproducible and rollback reliable.

---
