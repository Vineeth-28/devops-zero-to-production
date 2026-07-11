# 🔑 SSH

## What is SSH?

SSH (Secure Shell) allows secure remote login to Linux servers.

---

## Login

```bash
ssh -i key.pem ubuntu@PUBLIC_IP
```

---

## Important Files

Laptop

```
~/.ssh
```

EC2

```
~/.ssh/authorized_keys
```

---

## Why SSH Keys?

More secure than passwords.

Private key stays with the user.

Public key is stored on the server.

---

## Interview Questions

Why use SSH keys instead of passwords?

Difference between:

- Private Key
- Public Key

---

## Production Scenario

Developer:

```
Permission denied (publickey)
```

Check:

1. Username
2. Private key
3. Security Group
4. SSH service
5. authorized_keys

---

## Best Practices

Never share PEM files.

Each developer should have their own SSH key.

---

## Key Takeaways

SSH Keys > Passwords