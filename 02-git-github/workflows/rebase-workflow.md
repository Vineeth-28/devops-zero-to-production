# Git Rebase Workflow

This document describes the standard Git Rebase workflow followed in production.

---

# Workflow

```text
Feature Branch

↓

Develop Feature

↓

git fetch origin

↓

git rebase origin/main

↓

Resolve Conflicts

↓

git rebase --continue

↓

Run Tests

↓

git push --force-with-lease

↓

Create Pull Request
```

---

# Best Practices

- Rebase feature branches frequently.
- Never rebase shared branches.
- Resolve conflicts carefully.
- Verify commit history before pushing.

---

# Production Notes

- Rebase keeps history clean.
- Easier Pull Request reviews.
- Preferred before opening a PR.