# Day 12 — Jobs & Pipelines

**Status:** ⬜ Not started

## Objectives
- Understand Freestyle vs Pipeline jobs
- Write a Declarative Jenkinsfile with multiple stages
- Use parameters, environment variables, and post-build actions
- Understand Scripted pipeline basics for comparison

## Lab Steps

1. **Create a Pipeline job**
   - New Item → Pipeline named `pipeline-basics`
   - Use the `jenkinsfiles/basic/Jenkinsfile` from this repo as a starting point

2. **Add parameters**
   - Add a `choice` parameter for environment (staging/production)
   - Add a `boolean` parameter to toggle running tests

3. **Add environment variables**
   - Set `APP_ENV` from the parameter
   - Reference it inside a shell step

4. **Post-build actions**
   - Add `post { success {} failure {} always {} }` blocks
   - Archive a dummy artifact

5. **Scripted pipeline comparison**
   - Rewrite the same pipeline using `node { }` + `stage()` scripted syntax
   - Note the differences in error handling (`try/catch` vs `post`)

## Key Takeaways
- Declarative pipelines are linted before running — catches syntax errors early
- `when` blocks control conditional stage execution (branch, expression, environment)
- Parameters make jobs reusable across environments

## Checklist
- [ ] Pipeline job created from Jenkinsfile in SCM
- [ ] Parameters and environment variables working
- [ ] Post-build success/failure/always blocks tested
- [ ] Scripted pipeline equivalent written for comparison
