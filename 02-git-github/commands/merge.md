# Git Merge Commands

This document contains the Git merge commands practiced during Day 04 along with their purpose and production use cases.

---

# 1. Merge a Branch

## Syntax

```bash
git merge <branch-name>
```

### Example

```bash
git merge feature
```

### Purpose

Merge changes from another branch into the current branch.

---

# 2. Fast-Forward Merge

When the current branch has no new commits, Git simply moves the branch pointer.

```bash
git switch main
git merge feature
```

Result

```
main ----> latest commit
```

No merge commit is created.

---

# 3. Three-Way Merge

When both branches contain new commits.

```bash
git switch main
git merge feature
```

Git automatically creates a Merge Commit.

---

# 4. View Commit Graph

```bash
git log --graph --oneline --all
```

Example

```
*   Merge branch 'feature'
|\
| * Add Signup
| * Add Login
* | Add Dashboard
* | Add Payment
|/
* Initial Commit
```

Useful for visualizing branch history.

---

# 5. Check Merge Status

```bash
git status
```

Useful during merge conflicts.

Example

```
both modified: app.txt
```

---

# 6. Stage Resolved File

```bash
git add app.txt
```

Marks the conflict as resolved.

---

# 7. Complete Merge

```bash
git commit
```

or

```bash
git commit -m "Merge feature into main"
```

Creates the Merge Commit.

---

# Production Workflow

```bash
git switch main
git pull
git merge feature
git push
```

---

# Commands Practiced

- git merge
- git status
- git add
- git commit
- git log --graph --oneline --all

---

# Key Takeaways

- Fast-Forward Merge moves the branch pointer.
- Three-Way Merge creates a Merge Commit.
- Merge conflicts require manual resolution.
- Always inspect the commit graph after merging.