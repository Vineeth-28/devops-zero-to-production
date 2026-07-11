# 🧪 User Management Lab

## Objective

Understand Linux users, groups and permissions.

---

## Commands

Current user

```bash
whoami
```

User details

```bash
id
```

Groups

```bash
groups
```

Create user

```bash
sudo adduser devops
```

Verify

```bash
id devops
```

---

## Permission Lab

Create file

```bash
touch deploy.sh
```

Check permission

```bash
ls -l deploy.sh
```

Make executable

```bash
chmod +x deploy.sh
```

---

## Learning Outcome

Understand:

- Users
- Groups
- Permissions
- Ownership
- Execute permission