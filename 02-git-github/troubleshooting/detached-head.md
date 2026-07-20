# Detached HEAD

## Symptoms

git status

HEAD detached at <commit>

## Why It Happens

HEAD points directly to a commit instead of a branch.

## Common Causes

- git checkout <commit_hash>
- Inspecting previous versions

## Recovery

git checkout main

or

git switch main

## Production Use Cases

- Investigating production failures
- Comparing old deployments
- Testing previous releases

## Best Practice

Avoid making permanent commits while in Detached HEAD unless creating a new branch.