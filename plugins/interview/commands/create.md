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

### Step 4: Confirm Output and Give Setup Instructions

Report which folders were created vs. already existed, and whether `dnuckolls_intro.md` was created or already present.

Then print the following setup checklist verbatim so the user knows exactly what to do next:

---

**Workspace ready. Complete these steps before running your first interview:**

**1. Add the job description**
Drop the job description PDF into `job-description/`. One file only — the workflow auto-detects the first PDF it finds.

**2. Add candidate resumes**
Drop each candidate's resume PDF into `candidates/`. Name the file with the candidate's full name so the workflow can match it (e.g., `JaneDoe.pdf` or `Jane_Doe_Resume.pdf`).

**3. Fill out your interviewer intro**
Open `dnuckolls_intro.md` and complete all sections:
- **About Me** — your name, role, and a sentence about your team
- **What We're Looking For** — the two or three qualities that matter most for this role
- **Senior Candidates Introduction** — the exact words you read aloud to open every interview
- **Team Context** — two or three talking points you can offer when candidates ask about the team

This file is read by every step in the workflow. The more specific it is, the better the assessments and question guides will be.

**4. Start the workflow**
Once the above are in place:
```
/interview assess <CandidateName>
```

---
