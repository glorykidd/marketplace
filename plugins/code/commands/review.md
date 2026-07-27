---
description: Multi-agent code review of a PR, a git ref range, or the current diff if no PR exists yet
allowed-tools: Write, Bash(gh pr comment:*), Bash(gh pr diff:*), Bash(gh pr view:*), Bash(gh pr list:*), Bash(git diff:*), Bash(git status:*), Bash(git rev-parse:*), Bash(git merge-base:*), Bash(git remote show:*), Bash(git blame:*), Bash(git log:*), Bash(git show:*), Bash(find:*), Bash(mktemp:*), Bash(rm:*)
argument-hint: "[PR number|URL|git ref range] [--improve]"
---

Locate the skill file:

```bash
find "${CLAUDE_HOME:-$HOME/.claude}" /usr/local/share/claude -path "*/code/skills/review/SKILL.md" 2>/dev/null | head -1
```

If this command produces no output, the plugin is not installed correctly — stop and tell the user to reinstall the `code` plugin rather than proceeding without instructions.

Otherwise, read and execute the full skill from the path returned, following all instructions in that file exactly.

ARGUMENTS: $ARGUMENTS
