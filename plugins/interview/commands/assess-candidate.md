---
description: Generate a pre-screening assessment for a candidate from their resume and the job description. Produces a structured strengths/gaps analysis and two targeted interview questions. Use before any interview to prepare. Saves to questions/<CandidateName>_assessment.md.
argument-hint: "<Candidate Name> [--resume <path>] [--jd <path>]"
---

# Pre-Screening Candidate Assessment

Produce a structured pre-screening assessment from a candidate's resume before any interview takes place.

## Usage

```
/interview:assess-candidate <Candidate Name>
/interview:assess-candidate <Candidate Name> [--resume <path>] [--jd <path>]
```

## Project Structure

```
<project-root>/
├── candidates/          # Resumes (PDF), matched by candidate name
├── questions/           # Output location for _assessment.md files
├── job-description/     # Job description PDF (auto-detected, first PDF found)
└── dnuckolls_intro.md   # Interviewer background and priorities
```

## Step 1: Discover Files

If paths are not provided, locate them:

- **Resume**: search `candidates/` for a PDF whose filename contains the candidate's name (case-insensitive, partial match)
- **Job description**: use the first PDF found in `job-description/`
- **Interviewer context**: read `dnuckolls_intro.md` if it exists — use it to ground the assessment in the interviewer's priorities and the team's current state

Report which files you found before proceeding.

## Step 2: Read All Inputs

Read the job description, resume, and interviewer intro in full. Extract:

- Total years of experience and primary domain areas
- Specific skills and experiences that match the JD requirements
- Signals of enablement, training, or change management experience (if relevant to the role)
- Evidence of senior stakeholder engagement
- Notable gaps, missing keywords, or scope mismatches

## Step 3: Produce the Assessment

Write a markdown assessment to `questions/<CandidateLastName><CandidateFirstName>_assessment.md` (no spaces, last name first).

Use **exactly** this structure:

---

### Header

```
# Candidate Assessment: <First Last>

**Role:** <Role Title from JD>
**Experience:** <total years, key domains>

---
```

### Initial Assessment

#### Strengths

Bullet list. For each item: name the specific signal, tie it to a JD requirement. Do not pad — only include real signals.

#### Gaps / Watch Points

Bullet list. For each item: name what is absent or uncertain, explain why it matters for this role. Distinguish "confirmed absent" from "not evidenced."

#### Overall Fit

One paragraph. Lead with a direct signal/risk statement — e.g., "Strong on X; significant uncertainty on Y." Name the central tension if one exists. Be honest about unknowns; don't oversell.

### Top Two Interview Questions

Choose the two areas of highest uncertainty or highest importance from the gaps analysis. Write one targeted question per area.

#### 1. `<Area being probed>`

```
> "<exact question — specific to this candidate's background, not generic>"
```

**What to listen for:** Two to four sentences. Name what a strong answer includes, and what a red flag looks like. Make the distinction concrete enough that a different interviewer could use it.

#### 2. `<Area being probed>`

```
> "<exact question>"
```

**What to listen for:** Two to four sentences.

---

### Writing Guidance

The assessment should read like a memo from a senior recruiter to the hiring manager — specific, honest, and useful as a preparation tool. Avoid praise inflation. A candidate with genuine strengths and real gaps should look exactly that way on paper.

The questions should be tailored to *this candidate's resume* — they should not work as generic interview questions. Reference the candidate's actual projects, companies, or stated experience when possible.

## Step 4: Confirm Output

Report the path to the written assessment and give a one-sentence summary of the overall fit verdict.

Then append this note exactly:

---
**Next step:** Run `/interview questions <CandidateName>` to build a full interview guide from this assessment.
