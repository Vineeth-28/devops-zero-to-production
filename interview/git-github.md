# Git & GitHub Interview Questions

Based on `../02-git-github/` (commands/, troubleshooting/, workflows/, production-challenge.README.md).

---

## Q1. A bad commit was pushed to a shared branch that other people have already pulled. How do you fix it?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Whether you know `revert` is the safe choice on shared history, and understand why rewriting shared history is dangerous.

### Expected Answer
Use `git revert <commit>` to create a new commit that undoes the bad change, rather than `git reset` which rewrites history. Reset is fine on a local/private branch, but on a shared branch it forces everyone else to reconcile diverging history, which is disruptive and error-prone.

### Strong Interview Answer
"I'd use `git revert`, not `reset`. Revert creates a brand-new commit that undoes the bad change, so history stays linear and everyone who already pulled the branch just pulls the revert commit forward — no conflicts, no force-push. Reset would rewrite history, and since others have already pulled, that creates diverging histories and forces a force-push, which is risky and disruptive on a shared branch. Reset is fine on my own local branch before I've pushed; revert is what I reach for once it's shared."

### Follow-up Questions
- When would `reset` actually be appropriate?
- What happens if you force-push after a reset on a shared branch?
- How would you revert a merge commit specifically?

### Key Points
- Shared/pushed history → `revert` (safe, additive).
- Local/unpushed history → `reset` is fine.
- Force-pushing rewritten shared history breaks other people's clones.

---

## Q2. Explain how `cherry-pick` works and when you'd use it for a hotfix.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Practical understanding of applying a specific commit to a different branch without merging everything.

### Expected Answer
`cherry-pick` applies the changes from a specific commit onto your current branch as a new commit, without bringing in the rest of that branch's history. Common use: a fix was committed to `main` but you need it on a `release` branch too, without merging all of `main`'s other in-progress changes.

### Strong Interview Answer
"Cherry-pick takes one specific commit and replays just its changes onto my current branch as a new commit — it doesn't drag along the rest of that branch's history. The classic case is a hotfix: a bug fix lands on `main`, but a `release/1.2` branch is already cut and needs that same fix without pulling in everything else that's landed on `main` since. I'd `git cherry-pick <sha>` onto the release branch. If there's a conflict, I resolve it just like a merge conflict, then continue the cherry-pick."

### Follow-up Questions
- What happens if the cherry-picked commit conflicts with the target branch?
- How is cherry-pick different from merging just that one commit's branch?
- Can you cherry-pick a range of commits?

### Key Points
- Cherry-pick replays one commit's changes as a new commit elsewhere.
- Classic use case: hotfix to a release branch without merging everything else.
- Conflicts are resolved the same way as a merge conflict.

---

## Q3. Merge vs rebase — how do you decide which to use, on a real team?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Judgment, not just the mechanical difference — do you know the team/workflow tradeoffs.

### Expected Answer
Merge preserves the true history including when branches diverged and joined, creates a merge commit, and is non-destructive/safe for shared branches. Rebase rewrites your branch's commits on top of the target branch, producing linear history, but rewrites SHAs — unsafe on commits others have already pulled. Teams often rebase feature branches before opening a PR (to keep history clean) but merge (not rebase) when integrating into `main`.

### Strong Interview Answer
"Mechanically, merge combines two histories with a merge commit and keeps everything as it happened; rebase replays your commits on top of the target branch, giving linear history but rewriting SHAs. On a team, I rebase my own feature branch to pick up the latest `main` before opening a PR — since it's still just my branch, rewriting is safe. Once it's a shared PR that others may have pulled, or once it's merging into `main`, I don't rebase that — I merge, because rewriting commits other people already have creates painful divergence. So the rule of thumb is: rebase what's still private, merge what's shared."

### Follow-up Questions
- What does "rewriting shared history" actually break for a collaborator?
- What is `git rebase -i` used for beyond just updating a branch?
- Have you hit a case where rebase caused more problems than it solved?

### Key Points
- Merge = non-destructive, preserves true history, safe on shared branches.
- Rebase = linear history, rewrites SHAs, only safe on unshared/private commits.
- Common pattern: rebase your own feature branch, merge into shared branches.

---

## Q4. You ran `git reset --hard` and lost commits you actually needed. How do you recover them?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Whether you know `reflog` exists and can use it under pressure — a very common real "oh no" moment.

### Expected Answer
`git reflog` records a history of where `HEAD` has pointed, even for commits no longer reachable from any branch. Find the commit SHA before the reset in the reflog, then `git reset --hard <sha>` or `git checkout <sha>` to recover it, or `git branch recovery-branch <sha>` to save it without touching your current branch.

### Strong Interview Answer
"First thing, don't panic — `git reset --hard` doesn't actually delete the commits immediately, it just moves where `HEAD` points. I'd run `git reflog`, which shows every place `HEAD` has been, including the commit right before the reset. I'd grab that SHA and either `git reset --hard <sha>` to go back, or safer, create a new branch pointing at it with `git branch recovery <sha>` first so I don't risk losing it again while I verify it's the right commit."

### Follow-up Questions
- How long do unreachable commits stay recoverable before git garbage-collects them?
- What's the difference between `reset --hard`, `--mixed`, and `--soft` in terms of what gets lost?
- Would `reflog` help if you'd already run `git gc --prune=now`?

### Key Points
- `git reflog` is the safety net — it tracks HEAD movement, not just branch tips.
- Commits aren't deleted immediately by reset; they become unreachable until GC.
- Create a new branch at the recovered SHA before doing anything else, to lock it in.

---

## Q5. Walk me through resolving a merge conflict.

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Mechanical fluency and whether you understand what the conflict markers mean.

### Expected Answer
Git marks conflicting sections in the file with `<<<<<<<`, `=======`, `>>>>>>>` showing both versions. You manually edit the file to the correct final content, remove the markers, `git add` the resolved file(s), then continue with `git commit` (for a merge) or `git rebase --continue` (for a rebase).

### Strong Interview Answer
"Git stops and marks the conflicting lines with `<<<<<<<`, a separator, and `>>>>>>>`, showing my version and theirs. I read both, decide what the correct combined result should be — sometimes it's one side, sometimes both, sometimes a manual blend — edit the file to that final state, delete the conflict markers, then `git add` the file to mark it resolved, and either `git commit` if it's a merge or `git rebase --continue` if it's a rebase. I always double check by re-running tests after resolving, since a syntactically valid resolution can still be logically wrong."

### Follow-up Questions
- How is resolving a conflict during a rebase different from during a merge?
- What tools have you used to make conflict resolution easier?
- How do you avoid conflicts in the first place on a busy shared branch?

### Key Points
- Conflict markers (`<<<<<<<` / `=======` / `>>>>>>>`) show both versions.
- `git add` marks resolved, then `commit` (merge) or `rebase --continue` (rebase).
- Always verify with tests after resolving — a clean merge isn't automatically correct.

---

## Q6. What's the difference between `git pull` and `git fetch`?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Whether you understand pull is really fetch + merge (or rebase), and the implications of that.

### Expected Answer
`git fetch` downloads new commits/refs from the remote but doesn't touch your working branch — you can inspect before integrating. `git pull` does a fetch and then immediately merges (or rebases, with `--rebase`) into your current branch, which can create surprise merge commits or conflicts.

### Strong Interview Answer
"`git fetch` just brings down the latest remote refs without changing anything I'm working on — it's a safe, look-before-you-leap operation. `git pull` is fetch plus an automatic merge (or rebase if configured) into my current branch. I tend to fetch first, especially on something important, so I can look at what changed with `git log origin/main` before deciding to merge or rebase it in myself, rather than letting pull surprise me with a merge commit."

### Follow-up Questions
- What does `git pull --rebase` do differently from a plain `git pull`?
- How would you configure your repo to always rebase on pull?
- Why might a surprise merge commit from `pull` be a problem on a clean-history team?

### Key Points
- `fetch` = download only, no changes to your branch.
- `pull` = fetch + merge (or rebase) automatically.
- Fetching first lets you inspect before integrating.

---

## Q7. Your push is rejected with "non-fast-forward." What does that mean and how do you fix it?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Understanding of divergent history and the correct (non-destructive) way to reconcile it.

### Expected Answer
It means the remote branch has commits you don't have locally — your branch has diverged. Fix by pulling/fetching and integrating (merge or rebase) the remote changes into your local branch first, then pushing. Force-pushing is possible but dangerous on shared branches since it can discard others' work.

### Strong Interview Answer
"It means someone else pushed to that branch after I last pulled, so my local branch and the remote have diverged — a straight push can't be applied as a fast-forward. The right fix is to `git pull` (or fetch + rebase/merge) to bring in their changes, resolve any conflicts, and then push again. I'd avoid `--force` unless I'm certain I'm not going to overwrite someone else's work — on a shared branch that's basically never the right first move."

### Follow-up Questions
- When, if ever, is force-pushing acceptable?
- What's `--force-with-lease` and why is it safer than plain `--force`?
- How do branch protection rules relate to this scenario?

### Key Points
- Non-fast-forward = remote has commits you don't have; you're diverged.
- Fix: pull/rebase to integrate, then push — don't force by default.
- `--force-with-lease` is the safer alternative when force is genuinely needed.

---

## Q8. What is "detached HEAD" state and how do you get out of it safely?

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Whether you understand what HEAD actually points to, and won't panic or lose work in this state.

### Expected Answer
Detached HEAD means `HEAD` points directly at a commit rather than at a branch (e.g. after `git checkout <sha>`). Commits made here aren't on any branch, so they can become unreachable once you check out something else. Fix: if you want to keep work done here, create a branch (`git checkout -b new-branch`) before switching away.

### Strong Interview Answer
"Detached HEAD happens when you check out a specific commit instead of a branch — `HEAD` points straight at that commit, not at a branch reference. It's not dangerous by itself, but if I make new commits there and then switch to another branch without saving them, those commits can become orphaned and eventually get garbage collected. So the rule is: if I need to keep anything I did in that state, I create a branch there first with `git checkout -b <name>` before moving on."

### Follow-up Questions
- How would you know you're in detached HEAD state just from `git status`?
- What commands commonly put you into detached HEAD?
- Can you recover commits made in detached HEAD after switching away, if you forgot to branch?

### Key Points
- Detached HEAD = HEAD points to a commit directly, not a branch.
- Commits there are orphaned if you switch away without branching.
- Always `git checkout -b <name>` before leaving detached HEAD if the work matters.

---

## Q9. Compare `git reset --soft`, `--mixed`, and `--hard`.

**Difficulty:** 🟡 Medium

### What the interviewer is testing
Precise knowledge of what each mode does to the commit history, staging area, and working directory.

### Expected Answer
`--soft` moves the branch pointer only — staged changes and working directory are untouched, so your changes sit staged, ready to re-commit. `--mixed` (default) moves the pointer and unstages changes, but keeps them in the working directory. `--hard` moves the pointer and discards changes in both the staging area and working directory entirely.

### Strong Interview Answer
"All three move where the branch pointer is, but they differ in what happens to your changes. `--soft` keeps everything staged — useful if I want to squash a few commits into one and re-commit immediately. `--mixed`, the default, unstages the changes but leaves them in my working directory, so I can review and re-stage selectively. `--hard` throws away both the staging area and working directory changes — that's destructive, so I only use it when I'm certain I don't need those changes, and I know `reflog` is my safety net if I'm wrong."

### Follow-up Questions
- Which one would you use to undo a commit but keep editing the files?
- What's the risk with `--hard` specifically, versus the other two?
- How does `reset` differ from `revert` in terms of what happens to history?

### Key Points
- `--soft`: pointer only moves, changes stay staged.
- `--mixed` (default): pointer moves, changes unstaged but kept in working dir.
- `--hard`: pointer moves, all changes discarded — destructive, recoverable only via reflog.

---

## Q10. What's a "Production Git Challenge" type scenario you'd expect in a real job, and how would you handle discovering a secret was accidentally committed?

**Difficulty:** 🔴 Production

### What the interviewer is testing
Awareness that a leaked secret isn't fixed by just deleting it in a new commit — history still has it.

### Expected Answer
Deleting the file in a new commit doesn't remove it from history — anyone can still find it in old commits. You must rewrite history to actually remove it (`git filter-repo` or BFG Repo-Cleaner), force-push the cleaned history, and — critically — rotate/invalidate the leaked credential immediately, since it must be treated as compromised regardless of the git cleanup.

### Strong Interview Answer
"The first and most important step isn't a git command at all — it's rotating the credential immediately, because the moment it's pushed, even briefly, I have to treat it as compromised. Then for the repo itself, just deleting the file in a new commit isn't enough — it's still sitting in history. I'd use something like `git filter-repo` or BFG to actually strip it from all commits, force-push the rewritten history, and let the team know everyone needs to re-clone or hard-reset since local histories will diverge. I'd also add the file pattern to `.gitignore` and consider a pre-commit secret scanner to prevent it happening again."

### Follow-up Questions
- Why is rotating the credential more urgent than cleaning the git history?
- What tools have you used or heard of for scrubbing history (filter-repo, BFG)?
- How would you prevent this from happening again going forward?

### Key Points
- Rotate the leaked credential immediately — treat it as compromised the moment it's pushed.
- Deleting in a new commit is not enough; history must be rewritten (filter-repo/BFG).
- Prevent recurrence with `.gitignore` and pre-commit secret scanning.

---

## Q11. Walk me through the GitHub pull-request workflow end to end, as you'd actually use it on a team.

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Real day-to-day collaboration fluency, not just knowing the git commands in isolation.

### Expected Answer
Branch off `main` for the change, commit incrementally, push the branch, open a PR describing the change, request reviewers, respond to review comments (often with additional commits or an interactive rebase to clean up), pass CI checks, then merge (often squash-merge) once approved, and delete the branch.

### Strong Interview Answer
"I branch off `main` for the change, commit as I go, and push the branch to open a PR with a clear description of what and why. Reviewers leave comments, I address them with more commits or sometimes clean the branch up with an interactive rebase before merge. CI has to pass — tests, linting, whatever the pipeline checks. Once it's approved and green, I merge — usually squash-merge to keep `main`'s history clean — and delete the feature branch afterward."

### Follow-up Questions
- What's the difference between squash-merge, merge commit, and rebase-merge on GitHub?
- How do branch protection rules change this workflow?
- What do you do if CI fails after you thought you were ready to merge?

### Key Points
- Standard flow: branch → commit → push → PR → review → CI → merge → cleanup.
- Squash-merge keeps `main` history clean and readable, one commit per feature.
- Branch protection enforces reviews/CI before merge is allowed.

---

## Q12. In one sentence each, what's the practical difference between `reset` and `revert`?

**Difficulty:** 🟢 Easy

### What the interviewer is testing
Can you give a crisp, confident one-liner instead of over-explaining — useful for rapid-fire interview rounds.

### Expected Answer
`reset` moves the branch pointer backward, rewriting history (safe only if unshared). `revert` adds a new commit that undoes a previous one, keeping history intact (safe on shared branches).

### Strong Interview Answer
"`Reset` rewrites history by moving the branch pointer — good for local cleanup, dangerous once shared. `Revert` adds a new commit that undoes a previous change without touching history — that's what I use once something is pushed and others may have pulled it."

### Follow-up Questions
- Which one would you use to undo a bad commit that's already in production?
- Can you revert a revert?
- What would you say to a teammate who force-pushed a reset onto `main`?

### Key Points
- `reset` = rewrites history (local/unshared only).
- `revert` = new commit undoing a change (safe for shared/pushed history).
- Default to `revert` once anything is pushed.

---
