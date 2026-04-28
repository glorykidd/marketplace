---
description: Analyze an error or bug with root cause analysis and a ranked list of fix candidates
argument-hint: "<error message or description>"
---

Perform a structured root cause analysis on the provided error or bug description.

## INPUTS
- Error message or bug description (required argument)
- Stack trace if available (paste after the command)
- Relevant source files discovered via search

## INSTRUCTIONS

1. Parse the error message and identify the error type, location, and triggering condition
2. Search the codebase for the relevant files, functions, and call sites
3. Trace the execution path that leads to the error
4. Identify the root cause — distinguish between the symptom (where it crashes) and the cause (why it happens)
5. Generate 2-3 ranked fix candidates, ordered by confidence and invasiveness (least invasive first)
6. For each candidate, describe the change, its trade-offs, and any risks

## OUTPUT FORMAT

### Error Summary
One sentence describing what failed and where.

### Root Cause
Explanation of why it failed — the underlying condition, not just the crash site.

### Fix Candidates

**Option 1 (Recommended):** `<short label>`
- What to change
- Trade-offs
- Risk level: Low / Medium / High

**Option 2:** `<short label>`
- ...

### Next Steps
Which option to take and what to verify after the fix.
