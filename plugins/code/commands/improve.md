---
description: Review and improve existing code for readability, performance, and best practices, then save structured findings reports
argument-hint: File path to review
---

# Code Improver

Review and improve existing code for readability, performance, and best practices, then save the results.

## Instructions

1. Read the specified file(s) using the Read tool.
2. Analyze the code for:
   - Readability improvements
   - Performance optimizations
   - Best practice violations
   - Refactoring opportunities
   - Security concerns
3. Present structured suggestions with before/after examples.
4. **Write the full findings to a markdown file** in the `claude-findings/` folder at the project root.
   - Create the `claude-findings/` directory if it doesn't exist.
   - Name the file based on the reviewed file: `claude-findings/<filename>-improvements-<YYYY-MM-DD>.md`
   - Include all suggestions, code snippets, and rationale in the markdown output.
   - Use a clear structure: Summary, then each finding with Category, Severity, Location, Current Code, Suggested Code, and Rationale.

## Output Format (for the markdown file)

```markdown
# Code Improvement Report: <file path>
**Date:** <date>

## Summary
<brief overview of findings>

## Findings

### 1. <Title>
- **Category:** Readability | Performance | Best Practice | Security | Refactoring
- **Severity:** Low | Medium | High
- **Location:** `<file>:<line>`

**Current:**
\`\`\`
<current code>
\`\`\`

**Suggested:**
\`\`\`
<improved code>
\`\`\`

**Rationale:** <why this change improves the code>
```
