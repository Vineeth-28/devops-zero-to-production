# Git Rebase Commands

This document contains the Git Rebase commands practiced during Day 05 along with their purpose and production use cases.

---

# 1. Rebase Current Branch

## Syntax

```bash
git rebase <branch-name>
```

### Example

```bash
git rebase main
```

### Purpose

Replays the current branch commits on top of another branch to create a clean and linear commit history.

---

# 2. Interactive Rebase

```bash
git rebase -i HEAD~4
```

### Purpose

Rewrite commit history before pushing.

Useful for:

- Squashing commits
- Renaming commits
- Editing commits
- Dropping unwanted commits

---

# 3. Continue Rebase

```bash
git rebase --continue
```

Continue rebasing after resolving conflicts.

---

# 4. Abort Rebase

```bash
git rebase --abort
```

Cancel the current rebase operation.

---

# Commands Practiced

- git rebase
- git rebase -i
- git rebase --continue
- git rebase --abort

---

# Key Takeaways

- Rebase creates a linear history.
- Interactive Rebase cleans commit history.
- Resolve conflicts before continuing.
- Abort safely if something goes wrong.