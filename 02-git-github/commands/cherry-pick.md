# Git Cherry-pick

This document covers Git Cherry-pick concepts, commands, internal working, production use cases, and best practices.

---

# What is Git Cherry-pick?

Git Cherry-pick copies one or more commits from one branch and applies them onto another branch.

Unlike Merge, Cherry-pick copies only selected commits instead of merging an entire branch.

---

# Why Cherry-pick?

Cherry-pick is useful when:

- Copying a hotfix
- Backporting bug fixes
- Moving a feature
- Restoring selected commits
- Applying specific changes without merging

---

# Internal Working

```text
Selected Commit
      │
      ▼
Read Commit
      │
      ▼
Generate Patch
      │
      ▼
Apply Patch
      │
      ▼
Create NEW Commit
      │
      ▼
Move HEAD Forward
```

Git copies the changes and creates a brand-new commit with a different commit hash.

---

# Syntax

Cherry-pick one commit

```bash
git cherry-pick <commit_hash>
```

Cherry-pick multiple commits

```bash
git cherry-pick commit1 commit2 commit3
```

Cherry-pick a range

```bash
git cherry-pick A^..D
```

Cherry-pick without committing

```bash
git cherry-pick --no-commit <commit>
```

Continue

```bash
git cherry-pick --continue
```

Abort

```bash
git cherry-pick --abort
```

---

# HEAD Movement

Before

```text
HEAD
 │
 ▼
A ---- B
```

After

```text
HEAD
 │
 ▼
A ---- B ---- C
```

HEAD moves forward because Git creates a new commit.

---

# Cherry-pick vs Merge

| Cherry-pick | Merge |
|-------------|-------|
| Copies selected commits | Merges complete branch |
| Creates new commit(s) | Creates merge commit |
| Ideal for hotfixes | Ideal for integrating branches |

---

# Cherry-pick vs Rebase

| Cherry-pick | Rebase |
|-------------|--------|
| Copies commits | Moves commits |
| Selective | Entire branch |
| Good for backports | Good for linear history |

---

# Production Workflow

```text
Production Bug
      │
      ▼
Fix on Hotfix Branch
      │
      ▼
git cherry-pick
      │
      ▼
Release Branch Updated
      │
      ▼
Deploy
```

---

# Commands Practiced

```bash
git cherry-pick <commit>

git cherry-pick commit1 commit2

git cherry-pick A^..D

git cherry-pick --no-commit <commit>

git cherry-pick --continue

git cherry-pick --abort

git show <commit>

git log --oneline
```

---

# Labs Completed

- Cherry-pick single commit
- Cherry-pick multiple commits
- Cherry-pick commit range
- Cherry-pick using --no-commit
- Cherry-pick with merge conflict

---

# Production Use Cases

- Hotfix deployment
- Backport bug fixes
- Release branch updates
- Copy production fixes
- Selective feature migration

---

# Best Practices

- Cherry-pick only independent commits.
- Review commits before applying.
- Test after cherry-picking.
- Prefer Merge/Rebase for large feature branches.
- Use Cherry-pick mainly for hotfixes.

---

# Key Takeaways

- Cherry-pick copies commits.
- Commit hash changes.
- Original commit remains.
- HEAD moves forward.
- Useful for production hotfixes.
- Conflicts may require manual resolution.

---

# Interview Questions

- What is Git Cherry-pick?
- Cherry-pick vs Merge?
- Cherry-pick vs Rebase?
- Why does commit hash change?
- What is --no-commit?
- When should Cherry-pick be used?
- Can Cherry-pick create conflicts?