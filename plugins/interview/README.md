# interview

A three-step interview workflow toolkit: pre-screening assessment, interview question guide, and scored post-interview evaluation with PDF export.

## Usage

```
/interview assess <CandidateName>
/interview questions <CandidateName>
/interview evaluate <CandidateName>
```

Or invoke steps directly:

```
/interview:assess-candidate <CandidateName>
/interview:build-questions <CandidateName>
/interview:evaluate-candidate <CandidateName>
```

## Workflow

```
assess → questions → [conduct interview] → evaluate
```

## Commands

| Command | Description |
|---|---|
| `assess-candidate` | Generate a pre-screening strengths/gaps analysis and two targeted questions from the resume and JD. Saves to `questions/<Name>_assessment.md`. |
| `build-questions` | Build a full interview guide from the assessment: spoken intro, 4–5 core questions with follow-ups and listen-fors. Saves to `questions/<Name>_questions.md`. |
| `evaluate-candidate` | Produce a scored post-interview evaluation from transcript, summary, resume, and assessment. Saves `.md` and `.pdf` to `evaluations/`. |

## Project Structure

Your working directory should look like this:

```
<project-root>/
├── candidates/          # Resumes (PDF)
├── job-description/     # Job description (PDF)
├── questions/           # Generated assessments and question guides
├── interviews/
│   └── <CandidateName>/
│       ├── transcript.txt
│       └── summary.txt
├── evaluations/         # Generated evaluation .md and .pdf
└── dnuckolls_intro.md   # (optional) Interviewer background and priorities
```

## Dependencies

- `pandoc` — required for PDF export in `evaluate-candidate`
