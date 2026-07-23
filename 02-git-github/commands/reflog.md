# Git Reflog Commands

This document contains the Git Reflog commands practiced during Day 05.

---

# 1. View Reflog

```bash
git reflog
```

Displays the history of HEAD movements.

---

# 2. Recover Lost Commit

```bash
git reset --hard HEAD@{1}
```

Restore the repository to a previous HEAD position.

---

# Commands Practiced

- git reflog
- git reset --hard HEAD@{1}

---

# Key Takeaways

- Reflog records every HEAD movement.
- Lost commits can usually be recovered.
- Useful after accidental hard resets.
- Reflog is local to your repository.