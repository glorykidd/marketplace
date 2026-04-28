---
description: Generate a conventional commit message from staged git changes
argument-hint: "[scope] - optional scope to narrow the message"
---

Generate a clear, conventional commit message for the currently staged changes.

## INPUTS
- Staged git diff (`git diff --cached`)
- Optional scope argument to narrow the message (e.g. "auth", "api", "ui")

## INSTRUCTIONS

1. Run `git diff --cached` to get staged changes
2. Analyze the diff to understand what changed and why
3. Determine the commit type:
   - `feat`: new feature
   - `fix`: bug fix
   - `refactor`: code change that neither fixes a bug nor adds a feature
   - `docs`: documentation only
   - `test`: adding or updating tests
   - `chore`: build process, tooling, dependencies
   - `perf`: performance improvement
   - `style`: formatting, whitespace, missing semicolons
4. If a scope argument was provided, use it; otherwise infer scope from the files changed
5. Write a subject line: `<type>(<scope>): <short imperative summary>` — max 72 chars
6. Write a body if the change is non-trivial: explain the WHY, not the WHAT
7. If there are breaking changes, add `BREAKING CHANGE:` footer

## OUTPUT FORMAT

Present the commit message in a code block ready to copy, then briefly explain the type and scope choice if non-obvious.

```
<type>(<scope>): <subject>

<optional body>

<optional footer>
```
