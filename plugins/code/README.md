# code

Code quality toolkit: explain code and gotchas, run a multi-agent review of a PR or a pre-PR diff, and improve code for readability and best practices.

## Usage

```
/code:explain path/to/file.ts
/code:improve path/to/file.ts
/code:review                        # reviews current uncommitted/branch diff
/code:review 123                    # reviews PR #123
/code:review main..HEAD             # reviews an explicit git ref range
/code:review 123 --improve          # review + fold in readability/perf suggestions
```

## Commands

| Command | Description |
|---|---|
| `explain` | Explain code at a high level: data flow, dependencies, gotchas, risks |
| `improve` | Review a file for readability, performance, and best practices; saves a structured findings report to `claude-findings/` |
| `review` | Multi-agent review of a PR, a git ref range, or the current diff if no PR exists yet |

## How `review` works

`review` dispatches to a skill that runs a pipeline of specialized agents:

1. Resolves the diff (PR, explicit ref range, or current uncommitted/branch diff) and locates any relevant `CLAUDE.md` files.
2. Runs five reviewer agents in parallel: bugs, CLAUDE.md/security guidelines, comment compliance, test/doc coverage gaps, and git history context.
3. Scores every reported issue for confidence and drops low-confidence ones.
4. In PR mode, re-checks PR eligibility, then offers to post a summary comment — only on explicit confirmation.
5. With `--improve`, additionally runs the `code-improver` agent and folds its suggestions into the output.

## Agents

| Agent | Description |
|---|---|
| `pr-summarizer` | Summarizes the diff and locates relevant `CLAUDE.md` files |
| `eligibility-checker` | Checks whether a PR is eligible for automated review (not closed/draft/trivial/already reviewed) |
| `reviewer-bugs` | Scans for functional bugs, logic errors, and performance regressions |
| `reviewer-guidelines` | Audits `CLAUDE.md` compliance and convention-rooted security issues |
| `reviewer-comments` | Checks compliance with guidance in existing code comments |
| `reviewer-coverage` | Identifies test and documentation gaps |
| `reviewer-history` | Reviews git blame/log context for touched lines |
| `confidence-scorer` | Scores each reported issue 0–100 to filter false positives |
| `improve` (`code-improver`) | Reviews existing code for readability, performance, and best-practice issues |

## External deps

None — uses `git` and, in PR mode, `gh` (GitHub CLI).
