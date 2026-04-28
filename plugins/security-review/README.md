# security-review

Comprehensive security audit of any codebase against industry standards: OWASP Top 10, CWE, NIST 800-53, CIS Benchmarks, SOC 2, and ISO 27001.

## Usage

```
/security-review:audit
/security-review:audit src/ --focus authentication
/security-review:audit --severity high
```

## Commands

| Command | Description |
|---|---|
| `audit` | Full security audit with terminal summary and detailed markdown report |

### Options

| Option | Values | Description |
|---|---|---|
| `target-path` | any path | Directory or file to audit (defaults to project root) |
| `--focus` | `authentication`, `injection`, `crypto`, `data-protection`, `logging`, `dependencies`, `configuration`, `api`, `sessions`, `file-handling` | Narrow audit to one category |
| `--severity` | `critical`, `high`, `medium`, `low`, `informational` | Minimum severity to include in report (defaults to `low`) |

## Agents

| Agent | Description |
|---|---|
| `security-reviewer` | Autonomous auditor — runs the full audit end-to-end without step-by-step guidance |

## Output

- **Terminal**: concise findings summary with severity counts, critical/high items, baseline score, and top 3 priority actions
- **Markdown report**: written to `security-review/<project>-security-review-<YYYY-MM-DD>.md` with full findings, baseline checklist, compliance matrix, and remediation roadmap

## External Dependencies

None.
