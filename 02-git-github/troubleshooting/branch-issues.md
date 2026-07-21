# Branch Troubleshooting

Common Git branch-related issues and their solutions.

---

# Cannot Delete Current Branch

Error

```text
error: cannot delete branch 'feature' checked out at ...
```

Cause

You are currently on the branch.

Solution

```bash
git switch main
git branch -d feature
```

---

# Branch Not Fully Merged

Error

```text
The branch 'feature' is not fully merged.
```

Cause

The branch contains commits that have not been merged.

Solution

Merge the branch first.

or

```bash
git branch -D feature
```

if you intentionally want to discard the work.

---

# Wrong Branch Checked Out

Symptoms

- Changes appear in the wrong branch.

Solution

```bash
git branch
git switch correct-branch
```

Always verify the active branch before committing.

---

# Accidentally Deleted a Branch

Recovery

If the commit still exists, Git Reflog can recover it.

```bash
git reflog
```

Detailed recovery will be covered in Day 05.