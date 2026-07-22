# 🔥 Git & GitHub Production Revision

Production-focused Git & GitHub revision with hands-on practice, interview preparation, Git internals, collaboration workflows, and real-world troubleshooting.

This module focuses on understanding **how Git works internally**, enabling developers to confidently use Git in production environments rather than simply memorizing commands.

---

# 🎯 Objective

Build a strong understanding of Git internals, version control, branching, merging, and collaboration workflows.

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

## ✅ Day 03 – Git Branches

- What is a Branch?
- Lightweight Branches
- Branch Pointers
- HEAD and Branch Relationship
- Branch Creation
- Branch Switching
- `git branch`
- `git switch`
- `git checkout`
- `.git/refs/heads`
- Branch Deletion (`-d` vs `-D`)
- Git Flow
- GitHub Flow
- Trunk-Based Development

---

## ✅ Day 04 – Merge & Merge Conflicts

- What is Git Merge?
- Fast-Forward Merge
- Three-Way Merge
- Merge Base
- Merge Commit
- Merge Conflicts
- Conflict Markers
- Conflict Resolution
- ORT Merge Strategy
- Production Merge Workflow
- Merge Best Practices

---

# 📂 Folder Structure

```text
02-git-github/

├── commands/
│   ├── git-basics.md
│   ├── git-internals.md
│   ├── branching.md
│   └── merge.md
│
├── troubleshooting/
│   ├── git-basics.md
│   ├── detached-head.md
│   ├── branch-issues.md
│   └── merge-conflicts.md
│
├── workflows/
│   ├── git-workflow.md
│   ├── branching-workflow.md
│   └── merge-workflow.md
│
├── pdfs/
│   ├── Day-01-Git-Basics.pdf
│   ├── Day-02-Git-Internals.pdf
│   ├── Day-03-Branches.pdf
│   └── Day-04-Merge.pdf
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
- `git log --graph --all`
- `git cat-file -p HEAD`
- `git cat-file -p <tree_hash>`
- `cat .git/HEAD`

## Branching

- `git branch`
- `git branch <branch-name>`
- `git switch <branch-name>`
- `git switch main`
- `git checkout <branch-name>`
- `git branch -d <branch-name>`
- `git branch -D <branch-name>`
- `ls .git/refs/heads`
- `cat .git/refs/heads/main`

## Merge

- `git merge <branch>`
- `git merge feature`
- `git status`
- `git add <file>`
- `git commit`
- `git log --graph --all`

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
- Git Branches
- Branch Pointers
- Branch References
- Git Snapshot
- Fast-Forward Merge
- Three-Way Merge
- Merge Base
- Merge Commit
- Merge Conflict
- ORT Merge Strategy

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

# 🌿 Git Branch & Merge Architecture

## Fast-Forward Merge

```text
Before Merge

main
 │
 ▼
A ─── B ─── C
             \
              D ─── E
                   ▲
                feature
```

```text
After Merge

A ─── B ─── C ─── D ─── E
                         ▲
                   main, feature
```

---

## Three-Way Merge

```text
             D ─── E
            /       \
A ─── B ─── C         M
            \       /
             F ─── G
```

`M` is the **Merge Commit**.

---

# 🛠 Git Workflow

```text
Developer
      │
      ▼
Feature Branch
      │
      ▼
Commit Changes
      │
      ▼
Push Branch
      │
      ▼
Pull Request
      │
      ▼
Code Review
      │
      ▼
CI Tests
      │
      ▼
Merge
      │
      ▼
Deploy
```

---

# 🚨 Production Scenarios

## Git

- Detached HEAD Investigation
- Branch Pointer Inspection
- Branch Storage Investigation
- Branch Switching
- Branch Deletion
- HEAD Movement Analysis
- Fast-Forward Merge
- Three-Way Merge
- Merge Conflict Resolution
- Pull Request Workflow
- Code Review Workflow

---

# 💡 Key Learnings

- Git stores snapshots instead of individual file versions.
- Blob objects store file contents.
- Tree objects store directory structures.
- Commit objects store metadata and project snapshots.
- HEAD represents the current position in the repository.
- Detached HEAD enables safe debugging of previous commits.
- Branches are lightweight movable pointers.
- Creating a branch does not copy the repository.
- Fast-Forward Merge moves only the branch pointer.
- Three-Way Merge creates a Merge Commit.
- Merge Base is the common ancestor of two branches.
- Merge Conflicts occur when the same lines are modified differently.
- ORT is Git's default merge strategy.
- Production teams use Pull Requests before merging into `main`.

---

# 🎤 Interview Questions Covered

## Git Fundamentals

- What is Git?
- What is Version Control?
- Git vs GitHub
- Why do companies use Git?

## Git Internals

- What is a Blob?
- What is a Tree?
- What is a Commit Object?
- Explain SHA-1.
- What is HEAD?
- What is Detached HEAD?

## Git Branches

- What is a Git Branch?
- Why are branches lightweight?
- Where are branches stored?
- What is inside `.git/refs/heads`?
- What happens during `git switch`?
- What moves after a commit?
- Difference between `git switch` and `git checkout`
- Difference between `git branch -d` and `git branch -D`
- Explain Git Flow
- Explain GitHub Flow
- Explain Trunk-Based Development

## Git Merge

- What is Git Merge?
- What is a Fast-Forward Merge?
- Why is it called a Fast-Forward Merge?
- What is a Three-Way Merge?
- Why can't Git perform a Fast-Forward Merge when branches diverge?
- What is a Merge Base?
- What is a Merge Commit?
- Why do merge conflicts occur?
- How do you resolve merge conflicts?
- What is the ORT Merge Strategy?
- Why do companies use feature branches and Pull Requests?
- Merge Best Practices

---

# 📅 Revision Progress

- ✅ Day 01 – Git Fundamentals
- ✅ Day 02 – Git Internals & HEAD
- ✅ Day 03 – Branches & Branch Pointers
- ✅ Day 04 – Merge & Merge Conflicts
- ⏳ Day 05 – Rebase, Reset & Reflog
- ⏳ Day 06 – GitHub Workflow & Collaboration
- ⏳ Day 07 – Production Git Challenge

---

# 🎯 Goal

Learn Git the way production engineers use it.

Instead of memorizing commands, understand Git's internal architecture, object database, branching model, merge strategies, and troubleshooting techniques to confidently work with real-world repositories.

> **Learn → Understand → Practice → Explain → Apply**