# Git Reflog Recovery

This document explains how Git Reflog helps recover lost work.

---

# Recover Lost Commit

```bash
git reflog
```

Locate the previous HEAD.

Recover it:

```bash
git reset --hard HEAD@{1}
```

---

# Common Recovery Scenarios

- Accidental Hard Reset
- Deleted Branch
- Detached HEAD
- Incorrect Rebase

---

# Best Practices

- Use reflog before attempting manual recovery.
- Verify commit history after recovery.

---

# Key Takeaways

- Reflog is Git's safety net.
- Most recent history changes can be recovered.
- Reflog is available only in the local repository.