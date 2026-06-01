---
name: gh-open-pr
description: Open GitHub pull requests with the gh CLI when the user asks to push a branch, open a PR, create a pull request, publish work for review, or apply web-epica PR title standards.
---

# GH Open PR

## Goal

Open a GitHub pull request from the current branch using `gh` with a predictable title, useful body, and verified URL.

Completion condition: PR URL returned by `gh pr view --json url` or `gh pr create`, local branch pushed to origin, and no unrelated local changes included.

## PR Title Standard

Build the title before running `gh pr create`.

1. If a Jira ID is present in the branch name, commit messages, changeset, user request, or inferred task context, put it first.
2. Preserve the Jira ID casing and format, for example `EP-1978`.
3. Include the feature name exactly as the developer provided it. If they did not provide one, infer a short feature name from the branch, changed files, or commit subject.
4. Make the human-readable part start with a capital letter.
5. Do not use lowercase conventional-commit prefixes such as `ci:`, `fix:`, or `feat:` as the PR title prefix.
6. Keep the title concise: Jira ID plus 3-10 words is the default target.

Examples:

- `EP-1978 Dynamic onboarding screens`
- `EP-2253 Payment history webview states`
- `Create release workflow optimization`
- `Active plans mock webview updates`

## Workflow

1. Verify prerequisites:
   - Run `gh auth status`.
   - Run `git remote -v` and confirm an `origin` remote exists.
   - Run `git branch --show-current`; stop if detached.
   - Run `git status --short`; do not include unrelated changes. If unrelated changes exist, commit only the intended files or move the work to a dedicated worktree/branch.

2. Determine branch and base:
   - Use the current branch as `--head` unless the user named a branch.
   - Use the user-provided base branch when given; otherwise use `main`.
   - If the branch is not pushed, run `git push -u origin HEAD`.

3. Prepare the PR body:
   - Include `## Summary` with 1-3 bullets describing user-visible or CI-visible changes.
   - Include `## Testing` with commands that ran, or `Not run (reason)`.
   - Mention important skipped validation honestly.

4. Open the PR:
   - Prefer an explicit command so the title standard is enforced:

```bash
gh pr create --base "$base" --head "$branch" --title "$title" --body-file "$body_file"
```

   - Use `--body` instead of `--body-file` only for very short bodies where shell quoting is safe.
   - If a PR already exists, do not create a duplicate; run `gh pr view --web` or `gh pr view --json url,title,state` and report it.

5. Verify and report:
   - Run `gh pr view --json number,title,url,headRefName,baseRefName,state`.
   - Confirm the title follows this skill's title standard.
   - Tell the user the PR URL, branch, base, and validation performed.

## Gotchas

- `gh pr create --fill` can produce lowercase conventional titles. Use explicit `--title`.
- The branch may track a stale or wrong upstream. Check `git status -sb` when in doubt.
- Worktree setup hooks may touch lockfiles. Remove install noise unless it is part of the requested PR.
- Never merge the PR unless the user explicitly asks for merging.
- Never include credentials, `.env`, generated local artifacts, screenshots, or unrelated user changes.
