# Git Cherry-pick Recovery & Troubleshooting

This document covers common Cherry-pick failures, recovery techniques, conflict resolution, and production troubleshooting.

---

# Common Errors

- Merge conflict
- Wrong commit cherry-picked
- Empty cherry-pick
- Cherry-pick interrupted
- Duplicate commit
- Missing dependency commit

---

# Workflow

```text
Cherry-pick Failed
      │
      ▼
Read Error
      │
      ▼
Identify Cause
      │
      ▼
Resolve Conflict / Abort
      │
      ▼
Continue
```

---

# Merge Conflict

```text
CONFLICT (content)
```

Resolve

```bash
git status

git add .

git cherry-pick --continue
```

---

# Abort Cherry-pick

```bash
git cherry-pick --abort
```

Returns repository to its previous state.

---

# Empty Cherry-pick

```text
The previous cherry-pick is now empty
```

Meaning the changes already exist.

Skip

```bash
git cherry-pick --skip
```

---

# Wrong Commit

Undo using

```bash
git revert <cherry-picked_commit>
```

---

# Review Commit

```bash
git show <commit>
```

Always inspect before applying.

---

# Recovery Commands

```bash
git status

git show

git cherry-pick --continue

git cherry-pick --abort

git cherry-pick --skip

git log --oneline
```

---

# Best Practices

- Verify commit before cherry-picking.
- Resolve conflicts carefully.
- Test before pushing.
- Prefer Cherry-pick for small fixes.
- Avoid copying dependent commits individually.

---

# Interview Questions

- Why does Cherry-pick fail?
- What does --abort do?
- What does --continue do?
- When does Git create an empty Cherry-pick?
- How do you recover from a failed Cherry-pick?