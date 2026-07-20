# 🔥 Git & GitHub Production Revision

Production-focused Git & GitHub revision with hands-on practice, interview preparation, Git internals, collaboration workflows, and real-world troubleshooting.

This module focuses on understanding **how Git works internally**, enabling developers to confidently use Git in production environments rather than simply memorizing commands.

---

# 🎯 Objective

Build a strong understanding of Git internals, version control, branching, and collaboration workflows.

The goal is to understand **how Git works under the hood**, troubleshoot repositories confidently, and apply Git effectively in real-world production environments.

---

# 📚 Topics Covered

## ✅ Day 01 – Git Fundamentals

- What is Git?
- Version Control
- Git vs GitHub
- Centralized vs Distributed VCS
- Git Repository
- Working Directory
- Staging Area
- Local Repository
- Remote Repository
- `git init`
- `git status`
- `git add`
- `git commit`
- Commit as Snapshot

---

## ✅ Day 02 – Git Internals

- Git Object Database
- Blob Objects
- Tree Objects
- Commit Objects
- SHA-1 Hashing
- Parent Commits
- Commit History
- HEAD
- Detached HEAD
- Git Object Inspection
- Production Debugging using Detached HEAD

---

# 📂 Folder Structure

```text
02-git-github/

├── commands/
│   ├── git-basics.md
│   └── git-internals.md
│
├── troubleshooting/
│   ├── git-basics.md
│   └── detached-head.md
│
├── workflows/
│   └── git-workflow.md
│
├── pdfs/
│   ├── Day-01-Git-Basics.pdf
│   └── Day-02-Git-Internals.pdf
│
└── README.md
```

---

# 🚀 Commands Practiced

## Repository

- `git init`
- `git status`

## Staging

- `git add`
- `git add .`

## Commit

- `git commit -m`

## History & Internals

- `git log --oneline`
- `git cat-file -p HEAD`
- `git cat-file -p <tree_hash>`
- `cat .git/HEAD`

## Navigation

- `git checkout <commit_hash>`
- `git checkout main`

---

# 🧠 Core Concepts

- Git Repository
- Version Control
- Working Directory
- Staging Area
- Local Repository
- Remote Repository
- Git Object Database
- Blob Objects
- Tree Objects
- Commit Objects
- SHA-1 Hashing
- HEAD
- Detached HEAD
- Git Snapshot

---

# 🏗 Git Architecture

```text
Working Directory
        │
        ▼
Staging Area
        │
        ▼
Commit Object
        │
        ▼
Tree Object
   ┌────┴────┐
   ▼         ▼
Blob       Blob
```

Git stores every repository using **Blob**, **Tree**, and **Commit** objects.

---

# 🎯 HEAD

Normal Repository

```text
HEAD
 │
 ▼
main
 │
 ▼
Latest Commit
```

Detached HEAD

```text
HEAD
 │
 ▼
Commit
```

Normally, **HEAD points to a branch**.

In a Detached HEAD state, **HEAD points directly to a commit**.

---

# 🛠 Git Workflow

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

# 🚨 Production Scenario

Deployment failed after the latest release.

```text
Commit A ✅

Commit B ✅

Commit C ❌
```

Using Detached HEAD:

- Checkout Commit B
- Verify application behaviour
- Compare changes
- Identify the root cause
- Return to the main branch safely

---

# 💡 Key Learnings

- Git stores snapshots instead of individual file versions.
- Blob objects store file contents.
- Tree objects store directory structures.
- Commit objects store metadata and project snapshots.
- HEAD represents the current position in the repository.
- Detached HEAD enables safe debugging of previous commits.
- Git efficiently reuses unchanged objects instead of duplicating files.

---

# 🎤 Interview Questions Covered

- What is Git?
- What is Version Control?
- Git vs GitHub
- Centralized vs Distributed Version Control
- Why do companies use Git?
- What is a Working Directory?
- What is a Staging Area?
- Why does Git have a Staging Area?
- What happens after `git init`?
- What is inside the `.git` directory?
- What is a Git Commit?
- What is a Blob?
- What is a Tree?
- What is a Commit Object?
- What is SHA-1 in Git?
- What is HEAD?
- What is Detached HEAD?
- How do you recover from Detached HEAD?
- Explain a production use case for Detached HEAD.

---

# 📅 Revision Progress

- ✅ Day 01 – Git Fundamentals
- ✅ Day 02 – Git Internals & HEAD
- ⏳ Day 03 – Branches & Branch Pointers
- ⏳ Day 04 – Merge & Merge Conflicts
- ⏳ Day 05 – Rebase, Reset & Reflog
- ⏳ Day 06 – GitHub Workflow & Collaboration
- ⏳ Day 07 – Production Git Challenge

---

# 🎯 Goal

Learn Git the way production engineers use it.

Instead of memorizing commands, understand Git's internal architecture, object database, branching model, and troubleshooting techniques to confidently work with real-world repositories.

> **Learn → Understand → Practice → Explain → Apply**