# Merge Conflict Troubleshooting

Merge conflicts occur when Git cannot automatically combine changes from two branches.

---

# Why Merge Conflicts Occur

Git creates a conflict when:

- Both branches modify the same lines.
- Git cannot determine which version is correct.

Example

Developer A

```
Login Button
```

Developer B

```
Authentication Button
```

Git cannot choose automatically.

---

# Conflict Markers

Git inserts conflict markers into the file.

```
<<<<<<< HEAD
Dashboard
Payment
=======
Login
Signup
>>>>>>> feature
```

Meaning

- HEAD → Current branch
- ======= → Separator
- feature → Incoming branch

---

# Resolution Steps

## Step 1

Open the conflicting file.

---

## Step 2

Remove conflict markers.

---

## Step 3

Keep the correct code.

---

## Step 4

Stage the file.

```bash
git add app.txt
```

---

## Step 5

Complete the merge.

```bash
git commit
```

---

# Verify Merge

```bash
git log --graph --oneline --all
```

---

# Common Mistakes

## Forgetting git add

Git will report

```
You have unmerged paths
```

---

## Committing before resolving

Git will reject the commit.

---

## Leaving conflict markers

The project may fail to build.

Always remove

```
<<<<
<<<
=======
>>>>>>>
```

---

# Production Tips

- Pull the latest changes before opening a Pull Request.
- Merge frequently.
- Keep feature branches small.
- Resolve conflicts carefully.
- Review the merged code before pushing.

---

# Summary

Conflict

↓

Edit File

↓

git add

↓

git commit

↓

Merge Completed