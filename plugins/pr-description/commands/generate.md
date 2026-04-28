---
description: Generate a pull request description from the current branch diff against main
argument-hint: "[base-branch] - base branch to diff against (default: main)"
---

Generate a complete, reviewer-friendly pull request description for the current branch.

## INPUTS
- Current branch name (`git branch --show-current`)
- Commit log since diverging from base branch (`git log <base>...HEAD`)
- Full diff against base branch (`git diff <base>...HEAD`)
- Optional base branch argument (default: `main`)

## INSTRUCTIONS

1. Determine the base branch — use the argument if provided, otherwise `main`
2. Run `git log <base>...HEAD --oneline` to get the commit history
3. Run `git diff <base>...HEAD --stat` to get a file-level summary
4. Read the diff to understand the changes in detail
5. Write a PR description with these sections:

### Summary
2-4 bullet points covering what this PR does and why

### Changes
Grouped list of changes by area (e.g. API, UI, Tests, Config). Use file paths where helpful.

### Test Plan
Checklist of things a reviewer should verify manually or that automated tests cover

### Notes
Any breaking changes, migration steps, follow-up work, or decisions worth explaining

6. Keep the title suggestion under 72 characters, imperative mood

## OUTPUT FORMAT

Output the PR title suggestion first, then the full description body in markdown, ready to paste into GitHub/GitLab.
