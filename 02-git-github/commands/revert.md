# Git Revert

This document contains the Git Revert concepts, commands, production rollback workflows, and best practices practiced during Day 07.

---

# What is Git Revert?

`git revert` creates a **new commit** that reverses the changes introduced by an earlier commit while preserving the project's commit history.

Unlike `git reset`, Git Revert **does not remove commits**.

---

# Why Git Revert?

Git Revert is primarily used to safely undo changes that have already been pushed to a shared repository.

It preserves history, making it ideal for production environments.

---

# How Git Revert Works

Suppose the repository history is:

```text
A ---- B ---- C ---- D
```

Commit **D** introduces a bug.

Running:

```bash
git revert D
```

creates:

```text
A ---- B ---- C ---- D ---- E
```

Where

```
E
```

contains the **inverse changes** of commit **D**.

The original commit remains in history.

---

# Internal Working

Git performs the following steps:

```text
Target Commit
      │
      ▼
Read Commit
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

Git never deletes the original commit.

---

# Syntax

## Revert Latest Commit

```bash
git revert HEAD
```

---

## Revert Specific Commit

```bash
git revert <commit-hash>
```

Example

```bash
git revert a82fd91
```

---

## Find Commit Hash

```bash
git log --oneline
```

Example

```text
71ac3a1 Add Payment API
5bd91fd Add Login API
2ab91d0 Initial Commit
```

---

# Revert Multiple Commits

Revert commits individually

```bash
git revert <commit1>
git revert <commit2>
```

or use a commit range when appropriate.

---

# Revert Without Creating a Commit

```bash
git revert --no-commit <commit>
```

Git

- Applies reverse changes
- Does NOT create a commit
- Leaves the changes staged

Create your own commit

```bash
git commit -m "Rollback authentication module"
```

Useful when combining multiple rollback changes into one commit.

---

# Revert Merge Commit

Merge commits contain multiple parents.

Git needs to know which parent represents the mainline history.

```bash
git revert -m 1 <merge-commit-hash>
```

Meaning

```
Keep Parent 1

Undo changes introduced from Parent 2
```

Without `-m`

```text
error: commit is a merge but no -m option was given
fatal: revert failed
```

---

# HEAD Movement

Before

```text
HEAD
 │
 ▼
A ---- B ---- C ---- D
```

After

```text
HEAD
 │
 ▼
A ---- B ---- C ---- D ---- E
```

HEAD moves **forward** because Git creates a new commit.

---

# Git Reset vs Git Revert

| Git Reset | Git Revert |
|-----------|------------|
| Removes commits | Preserves commits |
| Rewrites history | Preserves history |
| Moves HEAD backward | Creates a new commit |
| Dangerous after push | Safe after push |
| Used locally | Used on shared branches |

---

# Production Workflow

```text
Bug Found
      │
      ▼
Identify Commit
      │
      ▼
git log
      │
      ▼
git revert <commit>
      │
      ▼
Test
      │
      ▼
Push
      │
      ▼
Production Restored
```

---

# Production Scenario

```text
Developer

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

      │

      ▼

git revert

      │

      ▼

Rollback
```

---

# Best Practices

- Use Git Revert for commits already pushed to shared branches.
- Read the commit using `git show` before reverting.
- Verify rollback using automated tests.
- Write meaningful rollback commit messages.
- Prefer Revert over Reset on production branches.

---

# Commands Practiced

```bash
git revert HEAD

git revert <commit>

git revert --no-commit <commit>

git revert -m 1 <merge-commit>

git log --oneline

git show <commit>
```

---

# Commands Practiced During Labs

### Lab 1

```bash
git revert HEAD
```

---

### Lab 2

```bash
git revert <old_commit_hash>
```

---

### Lab 3

```bash
git revert --no-commit HEAD
git commit -m "Rollback notification feature"
```

---

### Lab 4

```bash
git revert -m 1 <merge_commit_hash>
```

---

# Production Use Cases

- Rollback failed deployment
- Undo production bug
- Remove faulty feature
- Rollback hotfix
- Undo merge request
- Restore production stability

---

# Common Mistakes

❌ Using `git reset --hard` after pushing.

❌ Force pushing shared branches.

❌ Reverting the wrong commit.

❌ Forgetting to test after rollback.

❌ Reverting merge commits without using `-m`.

---

# Key Takeaways

- Git Revert never deletes history.
- Git creates a new rollback commit.
- HEAD moves forward after a revert.
- Revert is safe for shared repositories.
- `--no-commit` allows manual review before committing.
- Merge commits require the `-m` option.
- Production teams prefer Revert over Reset for rollback.

---

# Interview Questions

- What is Git Revert?
- How is Git Revert different from Git Reset?
- Why do companies prefer Git Revert?
- What happens internally during a revert?
- Why does Git create a new commit?
- What is `git revert --no-commit`?
- Why is `-m` required for merge commits?
- What does `git revert -m 1` do?
- Can Git Revert create conflicts?
- When should Git Revert be used in production?