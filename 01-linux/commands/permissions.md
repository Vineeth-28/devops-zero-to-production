# 🔐 Linux File Permissions

## What is it?

Linux permissions control who can:

- Read a file
- Write to a file
- Execute a file

Permissions are divided into:

- Owner
- Group
- Others

---

## Permission Values

| Permission | Value |
|------------|------:|
| Read (r) | 4 |
| Write (w) | 2 |
| Execute (x) | 1 |

Examples:

| Permission | Numeric |
|------------|---------|
| rwx | 7 |
| rw- | 6 |
| r-x | 5 |
| r-- | 4 |
| --- | 0 |

---

## Commands

Make executable

```bash
chmod +x deploy.sh
```

Numeric permission

```bash
chmod 755 deploy.sh
```

Remove execute permission

```bash
chmod -x deploy.sh
```

---

## Interview Questions

- What does chmod 755 mean?
- Difference between chmod and chown?
- Why does Permission Denied happen?

---

## Production Scenario

Developer runs:

```bash
./deploy.sh
```

Output:

```
Permission denied
```

First command:

```bash
ls -l deploy.sh
```

Investigate first.

Never guess.

---

## Best Practices

- Follow least privilege.
- Never give 777 unless absolutely required.
- Investigate before changing permissions.

---

## Key Takeaways

- chmod changes permissions.
- r=4 w=2 x=1
- Always verify permissions using ls -l.