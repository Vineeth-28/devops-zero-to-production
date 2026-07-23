
# Reset Recovery

This document explains how to recover from accidental Git Reset operations.

---

# Problem

Executed:

```bash
git reset --hard HEAD~1
```

Lost local commits.

---

# Recovery

```bash
git reflog
```

Find the previous HEAD.

Then recover:

```bash
git reset --hard HEAD@{1}
```

---

# Best Practices

- Check reflog before panicking.
- Avoid unnecessary hard resets.
- Commit important work frequently.

---

# Key Takeaways

- Hard Reset does not always mean permanent data loss.
- Reflog can recover recent commits.