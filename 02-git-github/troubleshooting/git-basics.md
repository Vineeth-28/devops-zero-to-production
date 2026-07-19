# Git Basics Troubleshooting

## git status

Shows:

- Current branch
- Modified files
- Staged files
- Untracked files
- Working tree status

---

## git init

Creates:

- Hidden `.git` directory
- Repository metadata
- Object database
- Branch references

---

## Common Mistakes

❌

```bash
git add.
```

✅

```bash
git add .
```

---

Deleting the `.git` folder removes:

- Commit history
- Branches
- Tags
- Repository metadata

The project files remain, but it is no longer a Git repository.