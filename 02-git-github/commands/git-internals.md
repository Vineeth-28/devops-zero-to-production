# Git Internals Commands

## View Commit History

git log --oneline

## View Commit Object

git cat-file -p HEAD

## View Tree Object

git cat-file -p <tree_hash>

## Checkout Previous Commit

git checkout <commit_hash>

## View Current HEAD

cat .git/HEAD

## Repository Status

git status