# Git Branching Workflow

Understanding how Git branches work internally.

---

# Creating a Feature Branch

```text
main
 │
 ▼
Commit C
```

Create a new branch

```bash
git branch feature
```

Result

```text
main
 │
 ▼
Commit C

feature
 │
 ▼
Commit C
```

No files are copied.

Git simply creates another pointer.

---

# Switching Branch

```bash
git switch feature
```

Result

```text
HEAD
 │
 ▼
feature
 │
 ▼
Commit C

main
 │
 ▼
Commit C
```

Only HEAD moves.

---

# Creating a Commit

```bash
git commit -m "Add Login API"
```

Result

```text
HEAD
 │
 ▼
feature
 │
 ▼
Commit D
 │
 ▼
Commit C

main
 │
 ▼
Commit C
```

Only the active branch pointer moves.

---

# Merging

```text
feature

↓

Merge

↓

main
```

After merging, the feature branch can be deleted.

---

# Branch Lifecycle

```text
Create Branch

↓

Switch Branch

↓

Develop Feature

↓

Commit

↓

Push

↓

Pull Request

↓

Merge

↓

Delete Branch
```