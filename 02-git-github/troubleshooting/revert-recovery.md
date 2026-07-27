# Git Revert Recovery & Troubleshooting

This document contains common Git Revert issues, recovery techniques, production troubleshooting scenarios, and best practices.

---

# Common Revert Errors

- Reverting the wrong commit
- Merge commit revert failure
- Merge conflicts during revert
- Revert already applied
- Reverting multiple dependent commits
- Aborted revert operation

---

# Troubleshooting Workflow

```text
Revert Failed
      │
      ▼
Read Error Message
      │
      ▼
Identify Cause
      │
      ▼
Resolve Conflict / Abort
      │
      ▼
Continue Revert
      │
      ▼
Verify Changes
      │
      ▼
Push
```

---

# Error 1

## Merge Commit Without Mainline

Command

```bash
git revert <merge_commit_hash>
```

Error

```text
error: commit is a merge but no -m option was given
fatal: revert failed
```

### Why?

A merge commit has multiple parents.

Git doesn't know which parent should be treated as the main branch.

### Solution

```bash
git revert -m 1 <merge_commit_hash>
```

---

# Error 2

## Merge Conflict During Revert

Command

```bash
git revert HEAD
```

Error

```text
CONFLICT (content)

Automatic revert failed.
```

### Why?

The same file has changed after the target commit.

Git cannot automatically apply the reverse patch.

### Solution

Resolve conflict manually.

```bash
git status
```

Edit files.

```bash
git add .
```

Continue

```bash
git revert --continue
```

---

# Error 3

## Wrong Commit Reverted

Example

```bash
git revert abc123
```

Later you realize

Wrong commit.

### Solution

Simply revert the revert.

```bash
git log --oneline
```

Find

```text
Revert "Add Login Feature"
```

Then

```bash
git revert <revert_commit_hash>
```

Git creates another commit restoring the original changes.

---

# Error 4

## Revert Already Applied

Sometimes

```bash
git revert
```

produces

```text
nothing to commit
```

or

```text
patch already applied
```

### Why?

The changes have already been removed.

No action is required.

---

# Error 5

## Revert Stopped

Example

```text
(master|REVERTING)
```

Git is waiting.

Check

```bash
git status
```

Finish

```bash
git add .
git revert --continue
```

Abort

```bash
git revert --abort
```

---

# Error 6

## Multiple Reverts

Instead of

```bash
git revert commit1
git revert commit2
git revert commit3
```

Use

```bash
git revert --no-commit commit1
git revert --no-commit commit2
git revert --no-commit commit3
```

Finally

```bash
git commit -m "Rollback payment module"
```

---

# Recovery Commands

Continue

```bash
git revert --continue
```

Abort

```bash
git revert --abort
```

Check Status

```bash
git status
```

View History

```bash
git log --oneline
```

Inspect Commit

```bash
git show <commit>
```

---

# Production Recovery Workflow

```text
Production Bug
      │
      ▼
Find Commit
      │
      ▼
git show
      │
      ▼
git revert
      │
      ▼
Conflict?
   │        │
  Yes      No
   │        │
Resolve     Push
   │
git revert --continue
   │
Push
```

---

# Best Practices

- Always identify the correct commit before reverting.
- Read the commit using `git show`.
- Test locally before pushing.
- Use `git revert` instead of `git reset` on shared branches.
- Prefer one rollback commit using `--no-commit` for related changes.
- Never force-push production branches to undo published commits.

---

# Production Scenarios

### Failed Deployment

```text
Deploy

↓

Bug

↓

git revert

↓

Redeploy
```

---

### Bad Feature Release

```text
Merge Feature

↓

Production Error

↓

git revert

↓

Feature Disabled
```

---

### Emergency Rollback

```text
Critical Bug

↓

Identify Commit

↓

Revert

↓

Smoke Test

↓

Push

↓

Production Stable
```

---

# Common Mistakes

❌ Using `git reset --hard` on shared branches

❌ Forgetting `-m` while reverting merge commits

❌ Ignoring merge conflicts

❌ Pushing without testing rollback

❌ Reverting the wrong commit

---

# Key Takeaways

- Git Revert preserves history.
- Merge commits require `-m`.
- Conflicts are resolved with `git revert --continue`.
- Failed revert operations can be canceled with `git revert --abort`.
- Reverting a revert restores the original changes.
- `--no-commit` helps combine multiple rollback operations into a single commit.

---

# Interview Questions

- What causes a merge conflict during Git Revert?
- What does `git revert --continue` do?
- When would you use `git revert --abort`?
- Why is `-m` required for merge commits?
- Can you revert a revert?
- How do you rollback multiple commits into one commit?
- What is the safest rollback strategy for production?
- Why shouldn't `git reset --hard` be used on shared branches?