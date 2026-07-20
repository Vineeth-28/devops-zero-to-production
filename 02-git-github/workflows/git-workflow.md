# 🔄 Git Workflow

This document explains how code moves from your computer to a remote Git repository while also showing what Git does internally.

---

# Basic Workflow

```text
Edit File
      │
      ▼
Working Directory
      │
   git add
      ▼
Staging Area
      │
 git commit
      ▼
Local Repository
      │
  git push
      ▼
Remote Repository (GitHub)
```

---

# Step 1 — Working Directory

This is where developers write and modify code.

Example

```
index.js
README.md
docker-compose.yml
```

Nothing is saved in Git yet.

---

# Step 2 — Staging Area

Command

```bash
git add .
```

The Staging Area lets you choose exactly what should be included in the next commit.

Think of it as preparing changes before taking a snapshot.

---

# Step 3 — Commit

Command

```bash
git commit -m "Add login feature"
```

Git creates a snapshot of the current staged files.

Internally Git creates

```
Commit
   │
   ▼
Tree
   │
   ▼
Blob
```

---

# Step 4 — Local Repository

After committing

```
Working Directory

↓

Staging Area

↓

Commit

↓

Local Repository
```

The commit exists only on your local machine.

Nobody else can see it yet.

---

# Step 5 — Push

Command

```bash
git push origin main
```

Uploads all local commits to the remote repository.

```
Local Repository

↓

Remote Repository (GitHub)
```

---

# Git Internals During a Commit

```
Edit File

↓

Working Directory

↓

git add

↓

Staging Area

↓

git commit

↓

Commit Object

↓

Tree Object

↓

Blob Objects
```

Git stores objects inside the `.git` directory.

---

# HEAD During Development

Normally

```
HEAD
 │
 ▼
main
 │
 ▼
Latest Commit
```

HEAD represents the current position in the repository.

---

# Detached HEAD

```
HEAD
 │
 ▼
Commit
```

Detached HEAD occurs when HEAD points directly to a commit instead of a branch.

Useful for

- Debugging
- Inspecting old commits
- Comparing releases
- Production troubleshooting

---

# Production Example

Developer modifies

```
payment.js

README.md

Dockerfile
```

Instead of committing everything

```
git add payment.js
git add Dockerfile
```

Only production-related changes are staged.

README changes remain in the Working Directory.

This keeps commits clean and focused.

---

# Complete Git Lifecycle

```
Create Repository
        │
        ▼
Edit Files
        │
        ▼
Working Directory
        │
        ▼
Staging Area
        │
        ▼
Commit
        │
        ▼
Local Repository
        │
        ▼
Remote Repository
```

---

# Key Takeaways

- Working Directory contains current file changes.
- Staging Area prepares changes for commit.
- Commit creates a project snapshot.
- Blob stores file contents.
- Tree stores folder structure.
- Commit stores metadata.
- HEAD tracks the current branch.
- Push uploads commits to GitHub.