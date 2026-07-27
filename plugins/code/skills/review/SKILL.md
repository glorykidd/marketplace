---
name: review
description: Multi-agent code review that works on a PR, an explicit git ref range, or the current diff if no PR exists yet. Called by /code:review.
allowed-tools: Write, Bash(gh pr comment:*), Bash(gh pr diff:*), Bash(gh pr view:*), Bash(gh pr list:*), Bash(git diff:*), Bash(git status:*), Bash(git rev-parse:*), Bash(git merge-base:*), Bash(git remote show:*), Bash(git blame:*), Bash(git log:*), Bash(git show:*), Bash(find:*), Bash(mktemp:*), Bash(rm:*)
argument-hint: "[PR number|URL|git ref range] [--improve]"
---

# Code Review

Multi-agent code review that works on a PR, an explicit git ref range, or — when no PR exists yet — the current uncommitted or branch diff.

**Use this skill when:** the user runs `/code:review`, with or without arguments.

**Arguments:** `$ARGUMENTS` may contain, in any combination:
- A PR number or URL
- A git ref or ref range (e.g. `main..HEAD`, a commit SHA, `abc123..def456`)
- `--improve` — after review, also run the `code-improver` agent on the same touched files and fold its suggestions into the output

---

## Step 1 — Resolve the diff and set mode

Determine what to review, in this priority order:

1. **PR number/URL** in `$ARGUMENTS` → `mode = pr`. Fetch with `gh pr diff <n>` / `gh pr view <n>`.
2. **Explicit git ref or range** in `$ARGUMENTS` (not a PR reference) → `mode = local`. Run `git diff <range>`.
3. **No target given** →
   a. Run `git status --porcelain`. If there are staged or unstaged changes, diff the working tree against `HEAD` (`git diff HEAD`). → `mode = local`.
   b. Otherwise, find the default branch (`git remote show origin | grep 'HEAD branch'` or fall back to `main`/`master`), compute `git merge-base HEAD <default-branch>`, and diff `merge-base..HEAD`. If this diff is empty → nothing to review, stop and tell the user. → `mode = local`.
4. If a PR reference and a git ref were both given, the PR reference wins.

Keep the resolved diff text and the `mode` — every later step needs both.

## Step 2 — Eligibility check (PR mode only)

Local mode always proceeds (skip to Step 3), except: if the resolved diff is empty or trivial (e.g. whitespace-only), stop and tell the user there's nothing to review.

In PR mode, invoke the `eligibility-checker` agent with the PR reference. If it reports the PR is closed, draft, doesn't need review, or already has a review comment from this tool, stop and tell the user why, quoting the agent's reasoning. Do not proceed.

## Step 3 — Context gathering

Invoke the `pr-summarizer` agent once, passing the mode and the PR reference or diff/ref-range. It returns:
- A change summary
- The list of relevant CLAUDE.md file paths for touched directories

## Step 4 — Parallel specialized review

Launch these five agents **in parallel**, each given the same diff and the CLAUDE.md file list from Step 3:

- `reviewer-guidelines` — CLAUDE.md compliance + convention-level security
- `reviewer-bugs` — functional bugs + performance regressions
- `reviewer-history` — git blame/log context
- `reviewer-comments` — in-code comment compliance
- `reviewer-coverage` — testing gaps + documentation gaps

Collect all reported issues into one list, tagged with which agent raised each.

## Step 5 — Confidence scoring

For each issue from Step 4, invoke `confidence-scorer` in parallel, passing the issue, the diff excerpt it refers to, and the CLAUDE.md file list. Drop any issue scoring below 80. If zero issues remain at or above 80, treat this as "no issues found" for Step 8's output — do not fabricate issues to fill the output template.

## Step 6 — Re-check eligibility (PR mode only)

Before producing PR-mode output, invoke `eligibility-checker` again on the same PR reference. If it's no longer eligible (e.g. someone closed it while the review was running), stop and tell the user.

## Step 7 — Optional improve pass

If `--improve` was passed, invoke the existing `code-improver` agent (`plugins/code/agents/improve.md`) on the files touched by the diff. Fold its readability/performance/best-practice suggestions into the output as an additional "Readability & Design" section — do not duplicate anything already surfaced by the Step 4 agents. This is an additive call into the `code-improver` agent's logic, not a copy of it.

Note: `/code:improve` (`plugins/code/commands/improve.md`) is a separate, standalone entry point with its own rubric and output format (a saved `claude-findings/` report) — it does not invoke `code-improver` and is not required to match this step's output shape.

## Step 8 — Output

Use this template for the findings that survived Step 5 (plus Step 7 if run):

```markdown
### Summary
- **Scope:**
- **Impact:**
- **Risk level:**

### Positives
- **Code quality wins:**
- **Good patterns:**

### Issues by Severity
(Critical: score 100, Important: score 85 — from Step 5; only these two values clear the drop threshold)

#### Critical
- [file:line] Problem → Why it matters → Fix suggestion

#### Important
- [file:line] Problem → Why it matters → Fix suggestion

### Testing Gaps
(from reviewer-coverage)

### Documentation
(from reviewer-coverage)

### Readability & Design
(from Step 7, only if --improve was passed)
```

If no issues survived scoring, output a short confirmation instead: what was checked, and that no high-confidence issues were found.

**Local mode**: print this to the user directly. Never attempt to post anywhere — there is no PR yet.

**PR mode**: print this to the user first, formatted for readability. Then also render the terse GitHub-comment version:

```markdown
<!-- code:review-pipeline -->
### Code review

Found N issues:

1. <brief description> (CLAUDE.md says "<...>" / bug due to <reason>)

<link to file and line, full-SHA GitHub URL, ±1 line of context: https://github.com/<owner>/<repo>/blob/<full-sha>/<path>#L<start>-L<end>>

...

🤖 Generated with [Claude Code](https://claude.ai/code)
```

Or if no issues: `<!-- code:review-pipeline -->\n### Code review\n\nNo issues found. Checked for bugs, CLAUDE.md compliance, and coverage gaps.`

The `<!-- code:review-pipeline -->` marker must always be the first line of the posted comment — `eligibility-checker` relies on it to detect a prior run.

Then ask the user (AskUserQuestion) whether to post this comment to the PR. Only post on explicit confirmation. Do not assign the PR to anyone as part of this flow — leave the assignee field untouched.

To post safely, never interpolate the review text into a shell command string — it routinely contains backticks, `$()`, quotes, and other shell metacharacters from code snippets. Instead, write the comment body to a temp file with the Write tool using a randomized name via `mktemp` (e.g. `TMPFILE=$(mktemp /tmp/code-review-XXXXXX)` — no file extension, since macOS's `mktemp` does not portably support a suffix after the `X` pattern) and post with `gh pr comment <n> --body-file "$TMPFILE"`, which reads the file directly and never passes the content through shell expansion. Always clean up afterward with `rm -f "$TMPFILE"`, whether the user confirms the post or declines.

Linking rules for PR mode (must follow exactly, otherwise Markdown won't render):
- Full commit SHA required — never a shell substitution
- Format: `https://github.com/<owner>/<repo>/blob/<full-sha>/<path>#L<start>-L<end>`
- At least 1 line of context before and after the commented line(s)
