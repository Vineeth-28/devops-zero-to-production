# Git Cherry-pick Workflow

This document explains how Git Cherry-pick is used in production environments.

---

# Hotfix Workflow

```text
Production Bug
      │
      ▼
Create Hotfix
      │
      ▼
Commit
      │
      ▼
git cherry-pick
      │
      ▼
Release Branch
      │
      ▼
Deploy
```

---

# Backport Workflow

```text
main

Bug Fixed

      │
      ▼

release

git cherry-pick

      │
      ▼

Production
```

---

# Internal Workflow

```text
Select Commit
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
Create New Commit
```

---

# Conflict Workflow

```text
Cherry-pick
      │
      ▼
Conflict
      │
 ┌────┴────┐
 ▼         ▼
Abort   Resolve
            │
            ▼
git cherry-pick --continue
```

---

# CI/CD Workflow

```text
Developer

↓

Commit

↓

Hotfix Branch

↓

Cherry-pick

↓

Release Branch

↓

CI/CD

↓

Production
```

---

# Commands

```bash
git cherry-pick

git cherry-pick --continue

git cherry-pick --abort

git cherry-pick --no-commit

git show

git log
```

---

# Production Best Practices

- Cherry-pick only tested commits.
- Review with git show.
- Test before deployment.
- Avoid cherry-picking long feature chains.
- Keep release branches stable.

---

# Key Takeaways

- Cherry-pick selectively copies commits.
- Excellent for hotfixes.
- Creates new commits.
- Integrates well with release workflows.
- Common in production support teams.