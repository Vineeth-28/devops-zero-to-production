# Day 16 — GitHub Actions Fundamentals Lab

## Objective
Build and run a working GitHub Actions workflow from scratch, and understand
how a push event turns into a running pipeline.

## Mental Model
```
Developer
  -> git push
  -> GitHub
  -> GitHub Actions
  -> Workflow
  -> Job
  -> Runner
  -> Steps
```

## Tasks

1. **Create the workflow directory**
   ```
   mkdir -p .github/workflows
   ```

2. **Add a basic workflow**
   Copy `../../workflows/basic-ci.yml` into `.github/workflows/basic-ci.yml`.

3. **Trigger it**
   Push a commit to `main` and open the **Actions** tab on GitHub to watch
   the workflow run.

4. **Inspect the run**
   - Identify the workflow, job, runner, and steps in the UI.
   - Note the `runs-on` value and confirm which OS the runner used.
   - Expand a step log and find `GITHUB_WORKSPACE`, `GITHUB_REF_NAME`.

5. **Break it on purpose**
   Change `run: echo "Build step goes here"` to an invalid command (e.g.
   `run: exit 1`) and push again. Observe the red X and read the failure log.

6. **Compare to Jenkins**
   Write 3-4 lines comparing this run to a Jenkins pipeline run you've done
   before (see `../../../07-cicd/jenkins/` notes if available): where is the
   server, who manages the agent/runner, how are credentials handled.

## Success Criteria
- [ ] Workflow runs automatically on push
- [ ] You can identify workflow / job / runner / step in the Actions UI
- [ ] You've seen both a passing and a failing run
- [ ] You can explain triggers, jobs, steps, and runners without notes
