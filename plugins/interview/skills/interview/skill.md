---
name: interview
description: Run an interview workflow step for a candidate. Steps: create (init workspace), assess (pre-screening assessment from resume), questions (build interview guide), evaluate (post-interview scored evaluation). Usage - /interview <step> [CandidateName]. Route to the matching /interview:<step> command.
allowed-tools: Read, Write, Bash
argument-hint: "<step: create|assess|questions|evaluate> [CandidateName]"
---

# Interview Workflow Router

Route the user to the correct interview command based on the step requested.

## Argument Parsing

Parse:
- `step` — one of: `create`, `assess`, `questions`, or `evaluate`
- `CandidateName` — the candidate's name as used in filenames (not required for `create`)

## Routing

| Step | Routes to |
|---|---|
| `create` | `/interview:create` |
| `assess` | `/interview:assess-candidate <CandidateName>` |
| `questions` | `/interview:build-questions <CandidateName>` |
| `evaluate` | `/interview:evaluate-candidate <CandidateName>` |

If no step is provided, list all four steps with one-line descriptions and ask the user which to run.

If no candidate name is provided for `assess`, `questions`, or `evaluate`, list available candidates from `candidates/` using `Bash(ls candidates/)` and ask.

## Step Descriptions

- **create** — Initialize the workspace folder structure (`candidates/`, `questions/`, `evaluations/`, `interviews/`, `job-description/`) and scaffold `dnuckolls_intro.md` if not present. Run this first in a new directory.
- **assess** — Generate a pre-screening assessment from the resume before the interview. Produces `questions/<Name>_assessment.md` with strengths, gaps, and two tailored interview questions.
- **questions** — Build a full interview question guide from the assessment. Produces `questions/<Name>_questions.md` with the interviewer intro, four to five core questions, follow-ups, and listen-fors.
- **evaluate** — Write a scored post-interview evaluation from the transcript, summary, and assessment. Produces `evaluations/<Name>_evaluation.md` and a PDF.

## Workflow Order

```
create → [add resume + JD] → assess → questions → [conduct interview] → evaluate
```

If a user skips ahead (e.g., runs `evaluate` without a prior assessment), proceed — but note which upstream files are missing.
