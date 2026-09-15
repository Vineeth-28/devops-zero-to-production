# 🚀 Day 09 — Production Git Challenge

> Final practical Git & GitHub challenge for the DevOps Zero to Production revision handbook.

---

# 🎯 Objective

The goal of this challenge is to simulate a real production Git incident.

By completing this challenge, you should be able to:

- Investigate Git history
- Identify a bad production commit
- Safely revert a shared branch
- Create a production hotfix
- Cherry-pick a specific commit
- Resolve cherry-pick conflicts
- Abort a cherry-pick
- Recover lost commits using reflog
- Inspect branches and commit history
- Safely push production changes
- Explain Git decisions in a production interview

---

# 🏗️ Production Git Workflow

A typical workflow:

```text
Developer
    ↓
feature/*
    ↓
release
    ↓
main
    ↓
Production