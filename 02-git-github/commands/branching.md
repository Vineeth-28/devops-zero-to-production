# Git Branching Commands

This document contains commonly used Git branching commands with explanations and production use cases.

---

# List All Local Branches

```bash
git branch
```

Purpose:
- Displays all local branches.
- The current branch is marked with `*`.

Production Use:
- Verify the available branches before switching or deleting.

---

# Create a New Branch

```bash
git branch feature/login-api
```

Purpose:
- Creates a new branch.
- Does not switch to it.

Production Use:
- Create an isolated workspace for a new feature.

---

# Switch Branch

```bash
git switch feature/login-api
```

Purpose:
- Switches to an existing branch.

Production Use:
- Start working on a specific feature.

---

# Switch Using Checkout

```bash
git checkout feature/login-api
```

Purpose:
- Switches branches using the legacy command.

Note:
- Modern Git recommends `git switch`.

---

# Return to Main

```bash
git switch main
```

Purpose:
- Returns to the main branch.

---

# Delete Branch

```bash
git branch -d feature/login-api
```

Purpose:
- Safely deletes a merged branch.

Production Use:
- Clean up merged feature branches.

---

# Force Delete Branch

```bash
git branch -D feature/login-api
```

Purpose:
- Deletes a branch even if it contains unmerged commits.

Warning:
- Use only when you are certain the branch is no longer needed.

---

# View Local Branch References

```bash
ls .git/refs/heads
```

Purpose:
- Displays all locally stored branch reference files.

---

# View Branch Pointer

```bash
cat .git/refs/heads/main
```

Purpose:
- Shows the SHA-1 hash of the commit pointed to by the branch.

Production Insight:
A Git branch is simply a file containing the commit hash of the latest commit.