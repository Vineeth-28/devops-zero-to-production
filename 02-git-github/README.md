# 🔥 Git & GitHub Production Revision

Production-focused Git & GitHub revision with hands-on practice, interview preparation, Git internals, collaboration workflows, and real-world troubleshooting.

This module focuses on understanding **how Git works internally**, enabling developers to confidently use Git in production environments rather than simply memorizing commands.

---

# 🎯 Objective

Build a strong understanding of Git internals, version control, branching, merging, rebasing, resetting, and collaboration workflows.

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

## ✅ Day 05 – Rebase, Reset & Reflog

- What is Git Rebase?
- Merge vs Rebase
- Linear History
- Interactive Rebase
- Squash
- Reword
- Edit
- Drop
- Git Reset
- Working Directory
- Staging Area
- Repository
- Soft Reset
- Mixed Reset
- Hard Reset
- Git Reflog
- Recover Lost Commits
- Production Rebase Workflow

---

## ✅ Day 06 – GitHub Workflow & Collaboration

- Remote Repositories
- `origin` vs `upstream`
- `git init` vs `git clone`
- `git remote`
- `git remote -v`
- `git remote add`
- `git remote rename`
- `git remote set-url`
- `git fetch`
- `git pull`
- `git pull --rebase`
- `git push`
- Remote Tracking Branches
- Fast-Forward Push
- Non-Fast-Forward Push
- GitHub Flow
- Pull Requests
- Code Reviews
- Branch Protection Rules
- Multi-Developer Collaboration

---

# 📂 Folder Structure

```text
02-git-github/

├── commands/
│   ├── git-basics.md
│   ├── git-internals.md
│   ├── branching.md
│   ├── merge.md
│   ├── rebase.md
│   ├── reset.md
│   ├── reflog.md
│   ├── remote-repositories.md
│   ├── remote-commands.md
│   ├── github-flow.md
│   ├── pull-requests.md
│   ├── branch-protection.md
│   └── remote-tracking-branches.md
│
├── troubleshooting/
│   ├── git-basics.md
│   ├── detached-head.md
│   ├── branch-issues.md
│   ├── merge-conflicts.md
│   ├── reset-recovery.md
│   ├── reflog-recovery.md
│   ├── non-fast-forward.md
│   ├── remote-conflicts.md
│   └── pull-vs-fetch.md
│
├── workflows/
│   ├── git-workflow.md
│   ├── branching-workflow.md
│   ├── merge-workflow.md
│   ├── rebase-workflow.md
│   ├── github-collaboration-workflow.md
│   ├── fork-upstream-workflow.md
│   └── pull-request-workflow.md
│
├── pdfs/
│   ├── Day-01-Git-Basics.pdf
│   ├── Day-02-Git-Internals.pdf
│   ├── Day-03-Branches.pdf
│   ├── Day-04-Merge.pdf
│   ├── Day-05-Rebase-Reset-Reflog.pdf
│   └── Day-06-GitHub-Remotes-and-Collaboration.pdf
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

## Rebase

- `git rebase`
- `git rebase -i`
- `git rebase --continue`
- `git rebase --abort`

## Reset

- `git reset --soft`
- `git reset --mixed`
- `git reset`
- `git reset --hard`

## Reflog

- `git reflog`
- `git reset --hard HEAD@{1}`

## Remote Repositories

- `git clone`
- `git remote`
- `git remote -v`
- `git remote add`
- `git remote rename`
- `git remote remove`
- `git remote set-url`
- `git fetch`
- `git pull`
- `git pull --rebase`
- `git push`
- `git push -u origin main`

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
- Git Rebase
- Interactive Rebase
- Replay Commits
- Linear History
- Squash
- Reword
- Edit
- Drop
- Git Reset
- Soft Reset
- Mixed Reset
- Hard Reset
- Git Reflog
- HEAD Movement
- Commit Recovery
- Origin
- Upstream
- Fetch
- Pull
- Push
- Remote Tracking Branches
- GitHub Flow
- Pull Requests
- Code Review
- Branch Protection
- Fast-Forward Push
- Non-Fast-Forward Push
- Multi-Developer Workflow

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

## Working Directory → Staging Area → Repository

```text
Working Directory
        │
        ▼   (git add)
Staging Area
        │
        ▼   (git commit)
Repository
```

- `git add` moves changes from the Working Directory into the Staging Area.
- `git commit` moves staged changes into the Repository as a permanent snapshot.
- `git reset` moves HEAD (and optionally the Staging Area and Working Directory) backward through this pipeline, depending on the reset mode used.

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

# 🔀 Rebase Architecture

## Before Rebase

```text
main:      A ─── B ─── C
                          \
feature:                   D ─── E
                            (branched from A)
```

## After Rebase

```text
main:      A ─── B ─── C
                          \
feature:                   D' ─── E'
                     (replayed on top of C)
```

Rebase **replays** the commits from `feature` on top of the latest `main`, producing new commits (`D'`, `E'`) with new SHAs, resulting in a **linear history**.

## Merge vs Rebase

```text
Merge                          Rebase

A ─ B ─ C ─ M                  A ─ B ─ C ─ D' ─ E'
        │  /                          (linear, no merge commit)
   D ─ E
(creates a Merge Commit,       (rewrites history,
 preserves branch history)      no Merge Commit)
```

---

# 🔄 Reset Architecture

```text
                Working Directory   Staging Area   Repository (HEAD)
Soft Reset             ✔ kept            ✔ kept        moves back
Mixed Reset            ✔ kept            ✘ unstaged    moves back
Hard Reset              ✘ discarded       ✘ discarded    moves back
```

- **Soft Reset** (`git reset --soft`) – moves HEAD only; staged changes and working directory are untouched.
- **Mixed Reset** (`git reset` / `git reset --mixed`) – moves HEAD and unstages changes; working directory files are untouched.
- **Hard Reset** (`git reset --hard`) – moves HEAD and discards staged and working directory changes, matching the repository exactly to the target commit.

---

# 🛟 Reflog Recovery

```text
Commit
   │
   ▼
Hard Reset
   │
   ▼
git reflog
   │
   ▼
Recover
```

`git reflog` tracks every movement of HEAD, so even after a `git reset --hard`, the "lost" commit can be recovered with `git reset --hard HEAD@{1}` (or the relevant reflog entry) before it is garbage collected.

---

# 🌐 GitHub Collaboration Architecture

```text
Developer A               Developer B
      │                         │
      ▼                         ▼
Feature Branch            Feature Branch
      │                         │
      ├──────────────┐──────────┤
                     ▼
              GitHub Repository
                     │
             Pull Request
                     │
              Code Review
                     │
                 Merge
                     │
                    main
```

---

# 🔄 Remote Repository Workflow

```text
Local Repository
      │
      │ git push
      ▼
GitHub Repository
      ▲
      │ git fetch
      │ git pull
Local Repository
```

---

# 🌿 Remote Tracking Branches

```text
GitHub
   │
   ▼
origin/main
   │
merge / rebase
   ▼
main
```

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

## Production Rebase Workflow

```text
Feature
   │
   ▼
Commit
   │
   ▼
Fetch
   │
   ▼
Rebase
   │
   ▼
Resolve Conflicts
   │
   ▼
Push --force-with-lease
   │
   ▼
Pull Request
```

## GitHub Flow

```text
main
 │
 ├──────────────┐
 │              │
 ▼              ▼
feature/login  feature/payment
 │              │
 ▼              ▼
Push          Push
 │              │
 ▼              ▼
Pull Request Pull Request
        │
        ▼
Code Review
        │
        ▼
CI Checks
        │
        ▼
Merge
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
- Interactive Rebase before PR
- Squashing commits
- Cleaning commit history
- Recover after Hard Reset
- Recover deleted commits
- Recover deleted branch
- Safe Force Push
- Configure GitHub Remote
- Clone Existing Repository
- Add Remote Repository
- Push First Project
- Track Remote Branches
- Fetch Remote Changes
- Pull Latest Changes
- Push Local Changes
- Resolve Remote Merge Conflicts
- Handle Non-Fast-Forward Push
- Collaborate with Multiple Developers
- Pull Request Review Workflow
- Branch Protection Workflow

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
- Rebase rewrites history.
- Rebase creates new SHAs.
- Interactive Rebase cleans commits.
- Soft Reset keeps staging.
- Mixed Reset unstages.
- Hard Reset restores repository.
- Reflog stores HEAD movements.
- Lost commits can be recovered.
- GitHub hosts remote repositories for collaboration.
- `origin` is the default remote alias created by `git clone`.
- `upstream` refers to the original repository in a fork workflow.
- `git fetch` downloads remote changes without modifying the current branch.
- `git pull` performs `fetch` followed by `merge` (or `rebase`).
- Remote-tracking branches mirror the state of remote branches.
- `git push` uploads local commits to the remote repository.
- Non-fast-forward pushes occur when the remote contains newer commits.
- Pull Requests enable collaboration and code reviews.
- Branch Protection prevents unsafe changes to production branches.

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

## Git Rebase

- What is Git Rebase?
- How is Rebase different from Merge?
- Why does Rebase create new SHAs?
- What is an Interactive Rebase?
- What does `git rebase -i` allow you to do?
- What is Squash and when is it used?
- What is the difference between Reword and Edit?
- What does Drop do during an interactive rebase?
- What happens during `git rebase --continue`?
- Why and when would you use `git rebase --abort`?

## Git Reset

- What is Git Reset?
- What is the difference between Soft, Mixed, and Hard Reset?
- What happens to the Staging Area in a Mixed Reset?
- What happens to the Working Directory in a Hard Reset?
- When would you use `git reset --soft`?
- Why is `git reset --hard` considered dangerous in production?

## Git Reflog

- What is Git Reflog?
- How does Reflog help recover lost commits?
- What does `HEAD@{1}` mean?
- Can Reflog recover a deleted branch?
- How long do unreachable commits stay recoverable before garbage collection?

## GitHub Collaboration

- What is a Remote Repository?
- Difference between Git and GitHub?
- What is origin?
- What is upstream?
- Difference between git init and git clone?
- What is git fetch?
- Difference between git fetch and git pull?
- What are Remote Tracking Branches?
- What is a Fast-Forward Push?
- What is a Non-Fast-Forward Push?
- How do you resolve a rejected push?
- What is GitHub Flow?
- What is a Pull Request?
- Why do companies use Pull Requests?
- What is Branch Protection?
- Explain a production Git workflow.

---

# 📅 Revision Progress

- ✅ Day 01 – Git Fundamentals
- ✅ Day 02 – Git Internals & HEAD
- ✅ Day 03 – Branches & Branch Pointers
- ✅ Day 04 – Merge & Merge Conflicts
- ✅ Day 05 – Rebase, Reset & Reflog
- ✅ Day 06 – GitHub Workflow & Collaboration
- ⏳ Day 07 – Production Git Challenge

---

# ⭐ Cheat Sheet (Quick Revision)

```text
Git Rebase
   │
   ▼
Interactive Rebase
   │
   ▼
Reset
   │
   ▼
Reflog
   │
   ▼
Recovery
```

Use this as a fast pre-interview refresher: rebase to clean up history, interactive rebase to squash/reword/edit/drop commits, reset to move HEAD (soft/mixed/hard), and reflog as the safety net to recover from any reset gone wrong.

---

# 🎯 Goal

Learn Git the way production engineers use it.

Instead of memorizing commands, understand Git's internal architecture, object database, branching model, merge strategies, rebase workflow, reset modes, remote/collaboration workflows, and recovery techniques to confidently work with real-world repositories.

> **Learn → Understand → Practice → Explain → Apply**
