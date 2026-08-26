# Final GitHub Actions Quiz — Days 16-18

A mixed, harder-difficulty pass across the whole module. Try to answer
without looking at your notes first.

1. What's the execution order in this snippet, and why?
   ```yaml
   jobs:
     a:
       runs-on: ubuntu-latest
       steps: [...]
     b:
       needs: a
       runs-on: ubuntu-latest
       steps: [...]
     c:
       needs: a
       runs-on: ubuntu-latest
       steps: [...]
   ```
   *(a runs first; b and c both wait for a, then run in parallel with each
   other since neither needs the other.)*

2. Why might a workflow show "Invalid workflow file" with zero steps run?
   *(YAML syntax error — GitHub can't even parse the workflow to schedule
   jobs.)*

3. You need 4 jobs to only deploy if ALL prior jobs succeeded, but you also
   want a notification job that fires even if something failed. What `if:`
   expressions do you use?
   *(Deploy jobs: default behavior, needs: [...] with no `if:` needed since
   a failed dependency skips downstream jobs automatically. Notify job:
   `needs: [...]` plus `if: always()` or `if: failure()`.)*

4. What's the risk of `uses: some/action@main` vs `uses: some/action@v3`?
   *(`@main` is a mutable branch — behavior can change without notice.
   `@v3` is a fixed tag; pinning to a commit SHA is even safer.)*

5. Two jobs both need the same compiled binary. What's the correct
   mechanism, and why can't job B just read job A's filesystem?
   *(`upload-artifact` / `download-artifact` — each job runs on an isolated,
   ephemeral runner with no shared filesystem.)*

6. A secret is correctly named and scoped but the job still can't read it.
   What environment-related setting could be missing?
   *(The job doesn't declare `environment: <name>` matching the environment
   the secret is scoped to.)*

7. What does `hashFiles('**/package-lock.json')` accomplish in a cache key?
   *(Automatically invalidates the cache whenever dependencies change,
   without needing to manually bump a cache version.)*

8. Why does a production deploy job typically declare `environment:
   production` even without protection rules configured yet?
   *(It establishes the deployment target and makes it easy to add
   protection rules — required reviewers, wait timers — later without
   restructuring the workflow.)*

9. What's the single biggest structural difference between Jenkins and
   GitHub Actions in terms of where pipeline definitions live and how
   infrastructure is provided?
   *(GitHub Actions workflows live as YAML in the repo itself and can use
   fully managed hosted runners; Jenkins pipelines run on a
   self-hosted/self-managed server and agent infrastructure you maintain.)*

10. Name the full production flow from commit to deployed container, in
    order.
    *(git push -> GitHub Actions triggered -> build -> test -> Docker
    build -> Docker tag with SHA -> Docker push to registry -> production
    environment -> manual approval -> deploy.)*
