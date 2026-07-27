# Git Revert Workflow

This document explains the production workflow for using Git Revert to safely roll back changes without rewriting commit history.

---

# What is Git Revert Workflow?

Git Revert Workflow is a rollback strategy used in production to safely undo changes by creating a new commit instead of deleting existing commits.

Unlike `git reset`, Git Revert preserves the complete project history, making it the preferred rollback method for shared repositories.

---

# Production Rollback Workflow

```text
Bug Report
      │
      ▼
Identify Faulty Commit
      │
      ▼
Inspect Commit
(git show)
      │
      ▼
Revert Commit
(git revert)
      │
      ▼
Run Tests
      │
      ▼
Commit Created
      │
      ▼
Push Changes
      │
      ▼
Production Restored
```

---

# Workflow 1 – Revert Latest Commit

```text
Developer
      │
      ▼
Commit
      │
      ▼
Push
      │
      ▼
Production Bug
      │
      ▼
git revert HEAD
      │
      ▼
Rollback Commit
      │
      ▼
Push
```

Commands

```bash
git log --oneline

git revert HEAD

git push
```

---

# Workflow 2 – Revert Specific Commit

```text
Repository History

A ---- B ---- C ---- D ---- E
             ▲
      Faulty Commit
```

Rollback

```bash
git revert <commit_hash>
```

Result

```text
A ---- B ---- C ---- D ---- E ---- R
```

Where

```
R
```

is the rollback commit.

---

# Workflow 3 – Rollback Multiple Commits

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

Review changes.

Create one rollback commit.

```bash
git commit -m "Rollback payment module"
```

---

# Workflow 4 – Revert Merge Commit

Production

```text
main
 │
 ▼
Feature Branch
 │
 ▼
Merge
 │
 ▼
Production
 │
 ▼
Critical Bug
```

Rollback

```bash
git revert -m 1 <merge_commit_hash>
```

Git

- Keeps Parent 1
- Removes changes introduced by Parent 2
- Creates a new rollback commit

---

# Workflow 5 – Emergency Production Rollback

```text
Deployment
      │
      ▼
Monitoring Alert
      │
      ▼
Production Failure
      │
      ▼
Find Commit
      │
      ▼
git revert
      │
      ▼
Smoke Test
      │
      ▼
Push
      │
      ▼
Production Stable
```

---

# Team Collaboration Workflow

```text
Developer
      │
      ▼
Feature Branch
      │
      ▼
Pull Request
      │
      ▼
Merge into main
      │
      ▼
Production Issue
      │
      ▼
git revert
      │
      ▼
Rollback Commit
      │
      ▼
Push
```

No history is rewritten.

Every developer receives the rollback commit.

---

# CI/CD Rollback Workflow

```text
Developer
      │
      ▼
Commit
      │
      ▼
CI Pipeline
      │
      ▼
Deploy
      │
      ▼
Production Error
      │
      ▼
git revert
      │
      ▼
New Commit
      │
      ▼
CI Pipeline
      │
      ▼
Deploy Rollback
```

---

# Internal Workflow

```text
Target Commit
      │
      ▼
Read Commit Object
      │
      ▼
Generate Reverse Patch
      │
      ▼
Apply Reverse Changes
      │
      ▼
Create New Commit
      │
      ▼
Move HEAD Forward
```

Git never removes the original commit.

---

# Production Best Practices

✅ Inspect the commit before reverting.

```bash
git show <commit_hash>
```

---

✅ Test locally before pushing.

---

✅ Use Git Revert on shared branches.

---

✅ Use `--no-commit` when combining multiple rollback operations.

---

✅ Revert merge commits using

```bash
git revert -m 1 <merge_commit_hash>
```

---

# Commands Used

```bash
git log --oneline

git show <commit_hash>

git revert HEAD

git revert <commit_hash>

git revert --no-commit <commit_hash>

git revert -m 1 <merge_commit_hash>

git revert --continue

git revert --abort

git push
```

---

# Common Mistakes

❌ Using `git reset --hard` after pushing.

❌ Force pushing production branches.

❌ Forgetting the `-m` option while reverting merge commits.

❌ Not testing rollback before pushing.

❌ Reverting the wrong commit.

---

# Key Takeaways

- Git Revert creates a rollback commit instead of deleting history.
- Production teams use Git Revert for safe rollbacks.
- `--no-commit` allows multiple rollback changes to be combined into one commit.
- Merge commits require `git revert -m 1`.
- Rollbacks should always be tested before deployment.
- Git Revert integrates cleanly with CI/CD pipelines.

---

# Production Scenario

```text
Developer

↓

Feature Branch

↓

Commit

↓

Pull Request

↓

Merge

↓

Deploy

↓

Bug Found

↓

git revert

↓

Rollback Commit

↓

CI/CD

↓

Production Restored
```