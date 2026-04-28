---
description: Evaluate a job candidate using their resume, pre-screening assessment, interview transcript, and summary. Produces a scored markdown evaluation and PDF in the evaluations/ folder. Use this whenever you need to assess candidate fit after an interview, generate an evaluation report, or score a candidate against a job description.
argument-hint: "<Candidate Name> [--resume <path>] [--assessment <path>] [--transcript <path>] [--summary <path>] [--jd <path>]"
---

# Candidate Evaluation

Produce a structured, scored candidate evaluation report from interview artifacts, then export it as a PDF.

## Usage

```
/interview:evaluate-candidate <Candidate Name>
/interview:evaluate-candidate <Candidate Name> [--resume <path>] [--assessment <path>] [--transcript <path>] [--summary <path>] [--jd <path>]
```

All file paths are optional — the skill auto-discovers them from the project structure if not supplied.

## Project Structure

Expect the working directory to be structured like this:

```
<project-root>/
├── candidates/          # Resumes (PDF), matched by candidate name
├── questions/           # Pre-screening assessments (Markdown), matched by candidate name
├── interviews/
│   └── <CandidateName>/ # Transcript and summary for each candidate
│       ├── transcript.txt
│       └── summary.txt
├── evaluations/         # Output location for evaluation .md and .pdf
└── job-description/     # Job description PDF (auto-detected, first PDF found)
```

## Step 1: Discover Files

If paths are not explicitly provided, locate them by searching the project directory:

- **Resume**: search `candidates/` for a PDF whose filename contains the candidate's name (case-insensitive, partial match on first or last name)
- **Assessment**: search `questions/` for a Markdown file whose filename contains the candidate's name
- **Transcript**: look for `interviews/<CandidateName>/transcript.txt` — try the name as-is, then with spaces removed, then as CamelCase
- **Summary**: look for `interviews/<CandidateName>/summary.txt` — same name matching as transcript
- **Job description**: use the first PDF found in `job-description/`

If any file cannot be found, report which ones are missing and ask the user to provide the paths before continuing.

## Step 2: Read All Inputs

Read all five files in full:
1. Job description
2. Resume
3. Pre-screening assessment (includes initial strengths/gaps analysis and the two planned interview questions)
4. Transcript
5. Interview summary

## Step 3: Produce the Evaluation

Write a markdown evaluation to `evaluations/<CandidateLastName><CandidateFirstName>_evaluation.md` (no spaces).

Use **exactly** this structure:

---

### Required Sections

#### Overall Recommendation
One of: **Advance**, **Conditional Advance — [brief condition]**, or **Pass**.

Two to three sentences explaining the recommendation, focused on the central tension or deciding factor. Lead with the conclusion, not the hedges.

#### Scoring Summary

A markdown table with these exact dimensions — score each /5 and include a one-line note:

| Dimension | Score | Notes |
|---|---|---|
| Technical AI/ML Depth | X/5 | ... |
| Governance & Compliance Knowledge | X/5 | ... |
| Enablement & Training Design | X/5 | ... |
| Communication & Audience Awareness | X/5 | ... |
| Cloud Platform Fit | X/5 | ... |
| Stakeholder & Leadership Range | X/5 | ... |
| Role Motivation Fit | X/5 | ... |

**Overall: X.X / 5** (average, one decimal)

#### What the Interview Confirmed

Two subsections:

**Strengths validated** — What the interview confirmed or elevated from the pre-screening assessment. Be specific: name the question, name the answer, name what it revealed. Don't just restate the resume.

**Gaps that remain open** — What the pre-screening flagged that the interview did not resolve. Be honest about uncertainty; don't paper over it.

#### Interview Dynamics

Two to four sentences describing how the conversation actually went — energy, rapport, how the candidate engaged with questions, any notable moments. Base this only on the transcript; don't invent dynamics that aren't evidenced there.

#### Recommended Next Steps

If advancing: what specifically should happen next — work sample, deeper round, reference check. Be concrete about what question the next step is designed to answer.

If passing: a one-sentence honest reason that respects the candidate's time and avoids vague language.

#### Pre-Screening Assessment Accuracy

Two to three sentences: did the pre-screening assessment correctly predict what the interview revealed? Which predictions held, which didn't, and what that says about the pre-screening methodology.

---

### Writing Guidance

The evaluation should read like a memo from a senior hiring manager to a hiring committee — precise, evidence-based, and opinionated. Avoid hedging language that says nothing ("may potentially"). State what you observed and what it means.

The key distinction this role requires is between *knowing the right answer* and *being able to transfer knowledge to others at scale*. Hold that lens throughout the evaluation — especially when assessing enablement and communication scores.

Do not add a comparative note about other candidates. Each evaluation stands alone.

## Step 4: Convert to PDF

Run the following command to produce the PDF:

```bash
eval "$(/usr/libexec/path_helper)" && pandoc <evaluation_md_path> -o <evaluation_pdf_path>
```

Where `<evaluation_pdf_path>` is the same path as the markdown file but with `.pdf` extension.

If pandoc is not on PATH, it is typically at `/opt/homebrew/bin/pandoc`. If pdflatex is needed, it is at `/Library/TeX/texbin/pdflatex`.

## Step 5: Confirm Output

Report the paths to both the `.md` and `.pdf` files and give a one-sentence summary of the overall recommendation.
