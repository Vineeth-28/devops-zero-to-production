# 👤 Linux Users & Groups

## What is it?

Linux uses users and groups to control access to resources.

Every file has:

- Owner
- Group

---

## Commands

Current user

```bash
whoami
```

User information

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

User details

```bash
id devops
```

---

## Memory Trick

whoami

↓

Who am I?

id

↓

Everything about me

groups

↓

Groups only

---

## Interview Questions

Difference between:

- whoami
- id
- groups

Why use groups instead of individual permissions?

---

## Production Scenario

100 developers need access to:

```
/var/www
```

Correct approach:

Create one group.

Add all users.

Assign folder permission once.

---

## Best Practices

- Use groups.
- Avoid unnecessary sudo.
- Follow least privilege.

---

## Key Takeaways

Groups simplify permission management.