# Production Merge Workflow

Modern software teams use feature branches and Pull Requests to ensure safe collaboration.

---

# Development Workflow

```
Create Feature Branch
        │
        ▼
Write Code
        │
        ▼
Commit Changes
        │
        ▼
Push Branch
        │
        ▼
Open Pull Request
        │
        ▼
Code Review
        │
        ▼
CI Tests
        │
        ▼
Approval
        │
        ▼
Merge
        │
        ▼
Deploy
```

---

# Why Use Pull Requests?

Pull Requests provide:

- Code Review
- Automated Testing
- Security Checks
- CI/CD Validation
- Team Collaboration

---

# Fast-Forward Workflow

```
main

A ─── B ─── C
             \
              D ─── E
```

↓

```
A ─── B ─── C ─── D ─── E
```

No Merge Commit.

---

# Three-Way Workflow

```
             D ─── E
            /       \
A ─── B ─── C         M
            \       /
             F ─── G
```

Merge Commit created.

---

# Production Best Practices

- Create a feature branch for every task.
- Keep Pull Requests small.
- Merge frequently.
- Pull the latest changes before merging.
- Never commit directly to `main`.
- Review code before merging.
- Ensure CI passes before approval.

---

# Typical Production Commands

```bash
git switch main
git pull origin main
git merge feature
git push origin main
```

---

# Team Workflow

Developer

↓

Feature Branch

↓

Commit

↓

Push

↓

Pull Request

↓

Review

↓

CI

↓

Approval

↓

Merge

↓

Deployment

---

# Key Learnings

- Feature branches isolate work.
- Pull Requests improve code quality.
- Fast-Forward Merge creates no merge commit.
- Three-Way Merge preserves both branch histories.
- Merge conflicts must be resolved manually.
- Frequent merges reduce conflicts.