---
description: Build a structured interview question guide for a candidate, grounded in their pre-screening assessment. Includes the interviewer's spoken introduction, core questions with follow-ups and listen-fors, and closing notes. Use after assess-candidate and before the interview. Saves to questions/<CandidateName>_questions.md.
argument-hint: "<Candidate Name> [--assessment <path>] [--jd <path>]"
---

# Interview Question Guide Builder

Produce a structured, ready-to-use interview guide from a pre-screening assessment.

## Usage

```
/interview:build-questions <Candidate Name>
/interview:build-questions <Candidate Name> [--assessment <path>] [--jd <path>]
```

## Project Structure

```
<project-root>/
├── questions/           # Pre-screening assessments; output location for _questions.md
├── job-description/     # Job description PDF
└── dnuckolls_intro.md   # Interviewer spoken introduction text
```

## Step 1: Discover Files

- **Assessment**: search `questions/` for a Markdown file containing the candidate's name
- **Job description**: first PDF in `job-description/`
- **Interviewer intro**: read `dnuckolls_intro.md`

Report files found. If the assessment is missing, stop and ask the user to run `/interview:assess-candidate` first.

## Step 2: Read All Inputs

Read the assessment, JD, and interviewer intro in full. Identify:

- The two pre-planned questions from the assessment (use these as the core of the guide)
- The central tension or key unknown about this candidate
- The JD requirements that most need probing beyond what the resume answers
- The interviewer's stated priorities from `dnuckolls_intro.md`

## Step 3: Produce the Interview Guide

Write to `questions/<CandidateLastName><CandidateFirstName>_questions.md`.

Use **exactly** this structure:

---

### Header

```
# Interview Guide: <First Last>
**Role:** <Role>
**Date:** <today's date>
```

### Interviewer Introduction

Paste the "Senior Candidates" spoken introduction from `dnuckolls_intro.md` verbatim. This is what David reads aloud to open the interview.

### Opening (5 min)

Standard prompt: ask the candidate to briefly describe where they're coming from and what drew them to this role. No scoring — this is warm-up and orientation.

### Core Questions

Four to five questions total. Structure each one as:

```
### <N>. <Area Being Probed>
**Ask:** "<exact question>"
**Follow-up if shallow:** "<one targeted follow-up>"
**Listen for:** <two to three sentences: what a strong answer looks like, what a red flag looks like>
```

Question ordering:
1. Start with a question that lets the candidate show technical strength (builds confidence, gives you baseline)
2. Move to the highest-uncertainty area from the assessment (the central tension)
3. A situational or behavioral question tied to a real scenario the role will face
4. One question on organizational fit or motivation (optional — include if role motivation fit was flagged as uncertain)

The two questions from the pre-screening assessment MUST appear in this section. Add two to three additional questions as needed to cover JD requirements not addressed in the assessment.

### Candidate Q&A (10 min)

Section header only. Include two to three suggested talking points about the team that the interviewer can offer if asked:

- Pull these from `dnuckolls_intro.md` and the team context described there
- Each should be one sentence, grounded in what was already shared in the intro doc

### Close

Standard: thank the candidate, explain the next steps in the process (without committing to a timeline), and invite any final questions.

---

### Writing Guidance

The guide is a tool for the interviewer, not the candidate. Write it so it can be picked up cold — assume the interviewer has read the pre-screening assessment but may not have it open during the call.

Exact question wording matters. Write the question as it would actually be spoken, not as a topic header. Include natural language.

The "listen for" sections should be opinionated: name what signals distinguish a strong answer from a weak one for *this specific role and candidate*.

## Step 4: Confirm Output

Report the path to the written guide and list the five core questions by title so the user can quickly confirm coverage.
