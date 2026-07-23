# Git Reset Commands

This document contains the Git Reset commands practiced during Day 05.

---

# 1. Soft Reset

```bash
git reset --soft HEAD~1
```

Moves HEAD back while keeping changes staged.

---

# 2. Mixed Reset

```bash
git reset --mixed HEAD~1
```

Moves HEAD back and unstages changes.

(Default behavior)

---

# 3. Hard Reset

```bash
git reset --hard HEAD~1
```

Moves HEAD back and removes staged and working directory changes.

> Warning: This permanently removes uncommitted changes.

---

# Commands Practiced

- git reset --soft
- git reset --mixed
- git reset --hard

---

# Key Takeaways

- Soft Reset keeps changes staged.
- Mixed Reset keeps changes only in the Working Directory.
- Hard Reset restores the repository to the selected commit.
- Understand Working Directory, Staging Area, and Repository before using reset.