---
name: worktree
description: Create worktree to work independently.
compatibility: Requires git repository.
metadata:
  author: andrii
---

You should create a new worktree.
User may specify base branch or use 'main'
User may specify new branch name.
For path, please use ../worktrees/web-epica/{new-name-of-folder} - please, do not use '/' or any other prohibited symbols in the folder name.

`git worktree add -b <new-branch> <path> <base-branch>`

Ensure that node_modules are installed and .env is present - this should be done automatically by running pre-commit hooks.
