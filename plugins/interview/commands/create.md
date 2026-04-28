---
description: Initialize the interview workspace folder structure in the current directory. Creates candidates/, questions/, evaluations/, interviews/, and job-description/ if they do not already exist, and scaffolds a dnuckolls_intro.md template if one is not present.
argument-hint: "[--force] - re-create missing folders even if workspace looks partially initialized"
---

# Create Interview Workspace

Initialize the standard interview workspace folder structure in the current directory.

## INSTRUCTIONS

### Step 1: Check Existing State

Run `ls -1` in the current directory to see what already exists. Report which expected folders are present and which are missing.

Expected folders:
- `candidates/` — place PDF resumes here
- `job-description/` — place the job description PDF here
- `questions/` — generated assessments and question guides land here
- `interviews/` — place transcript and summary per candidate here
- `evaluations/` — generated evaluation reports land here

### Step 2: Create Missing Folders

For each folder that does not exist, create it:

```bash
mkdir -p candidates job-description questions interviews evaluations
```

Do not overwrite or modify folders that already exist.

### Step 3: Scaffold dnuckolls_intro.md

If `dnuckolls_intro.md` does not already exist, create it with this template:

```markdown
# Interviewer Introduction

## About Me

[Your name and role — e.g., "I'm David, an AI Engineering Lead at Acme Corp."]

[One to two sentences about your team and what you're building.]

## What We're Looking For

[Two to three sentences describing the key qualities and experience that matter most for this role.]

## Senior Candidates Introduction

[The spoken introduction you read aloud at the start of the interview. Example:]

"Thanks for taking the time today. I'll give you a quick overview of who I am and what the team does, then we'll spend most of our time on your background. Feel free to ask questions at any point."

[Continue with your actual intro here.]

## Team Context (Talking Points)

- [Talking point 1 — something interesting about the team or the problem space]
- [Talking point 2 — a recent win or current challenge]
- [Talking point 3 — growth opportunity or team culture note]
```

If `dnuckolls_intro.md` already exists, leave it untouched.

### Step 4: Confirm Output

Report:
- Which folders were created vs. already existed
- Whether `dnuckolls_intro.md` was created or already present
- The full workspace structure using `ls -1`
- Next step: "Add a resume PDF to `candidates/` and a job description PDF to `job-description/`, then run `/interview assess <CandidateName>`."
