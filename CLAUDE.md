# CLAUDE.md

## Overview

This is the GloryKidd public skills marketplace — a curated registry of Claude Code plugins (skills, agents, and bundles) that anyone can browse, submit, and install.

- **Content types**: skills (slash commands), agents (subagents), bundles (both), MCP plugins
- **Primary users**: Claude Code users looking to extend their workflow; developers contributing new skills
- **Key workflows**: browse registry, install a plugin, submit a new plugin, regenerate registry

## Architecture

```
marketplace/
├── .claude-plugin/
│   └── marketplace.json        # Top-level marketplace manifest (all plugin entries)
├── plugins/
│   ├── commit-message/         # skill — generate conventional commit messages
│   ├── pr-description/         # skill — generate PR descriptions from branch diff
│   ├── debug-assistant/        # bundle — root cause analysis + autonomous investigator
│   └── interview/              # skill — full interview workflow (create, assess, questions, evaluate)
│       └── <plugin>/
│           ├── .claude-plugin/
│           │   └── plugin.json # Per-plugin manifest
│           ├── commands/       # Slash command files (.md)
│           ├── agents/         # Agent files (.md)
│           ├── skills/         # Skill router files (.md) — optional entry-point skill
│           │   └── <name>/
│           │       └── skill.md
│           └── README.md
├── templates/
│   └── hello-world/            # Copy-paste starter demonstrating all plugin layers
├── registry.json               # Auto-generated index — never edit manually
├── generate-registry.sh        # Regenerates registry.json from all plugins/
├── .claude/
│   └── settings.json           # Allowed bash commands for this repo
└── CLAUDE.md
```

## Current Plugins

### commit-message
- **Type**: skill
- **Commands**: `generate` — produces a Conventional Commits message from staged changes
- **External deps**: none

### pr-description
- **Type**: skill
- **Commands**: `generate` — produces a full PR description (Summary, Changes, Test Plan, Notes) from branch diff
- **External deps**: none

### debug-assistant
- **Type**: bundle
- **Commands**: `analyze` — structured root cause analysis with ranked fix candidates
- **Agents**: `investigate` — autonomous end-to-end bug investigator (reads code, traces execution, proposes a fix)
- **External deps**: none

### interview
- **Type**: skill
- **Commands**:
  - `create` — initializes workspace folders (`candidates/`, `job-description/`, `questions/`, `interviews/`, `evaluations/`) and scaffolds `dnuckolls_intro.md`; prints a setup checklist
  - `assess-candidate` — pre-screening strengths/gaps analysis + two targeted questions from resume and JD
  - `build-questions` — full interview guide from assessment (spoken intro, 4–5 questions with follow-ups and listen-fors)
  - `evaluate-candidate` — scored post-interview evaluation from transcript + summary; exports `.md` and `.pdf`
- **Skills**: `interview` router — single entry point routing `create|assess|questions|evaluate` to the matching command
- **External deps**: `pandoc` (for PDF export in `evaluate-candidate`)

### display-slide
- **Type**: skill
- **Skills**: `display-slide` — builds a single 1920x1080 PNG announcement/display slide (HTML/CSS + Playwright render) for a church, school, or ministry
- **External deps**: `playwright` (Chromium render + layout verification)

## Plugin Types

| Type | Has commands/ | Has agents/ | Has mcp/server.json |
|---|---|---|---|
| skill | ✓ | ✗ | ✗ |
| agent | ✗ | ✓ | ✗ |
| bundle | ✓ | ✓ | ✗ |
| mcp | either | either | ✓ |

## Key Conventions

- Every plugin must have `.claude-plugin/plugin.json` with `name`, `version`, `description`, `author`, and `metadata`
- Plugin names are lowercase, hyphen-separated (e.g. `commit-message`)
- Command files go in `commands/<command-name>.md` with YAML frontmatter (`description`, optional `argument-hint`)
- Agent files go in `agents/<agent-name>.md` with frontmatter (`name`, `description`, `tools`, `model`, `color`)
- Skill router files go in `skills/<name>/skill.md` with frontmatter (`name`, `description`, `allowed-tools`, `argument-hint`)
- `registry.json` is always regenerated via `./generate-registry.sh` — never edit it manually
- `maxDataClassification` must be `Public` for all community-submitted plugins

## Adding a New Plugin

1. Copy `templates/hello-world` to `plugins/<your-plugin-name>/`
2. Update `.claude-plugin/plugin.json` — set `name`, `description`, `author`, and `metadata`
3. Replace command/agent/skill files with your own logic
4. Add a `README.md` documenting usage, commands, and any external dependencies
5. Run `./generate-registry.sh`
6. Add your plugin entry to `.claude-plugin/marketplace.json`
7. Commit all files including the updated `registry.json`
8. Open a pull request

## Commands & Scripts

```bash
# Regenerate registry from all plugins
./generate-registry.sh

# Validate registry JSON
python3 -m json.tool registry.json
```

**Requires `jq` and `perl`** — `generate-registry.sh` depends on both. The CI workflow
(`.github/workflows/validate-registry.yml`) runs on a self-hosted Windows runner under
`pwsh`; it expects `jq` on `PATH` and invokes `generate-registry.sh` via Git for Windows'
bundled bash (`C:\Program Files\Git\bin\bash.exe`), so `perl` must be reachable from
*that* bash, not necessarily the pwsh session's own `PATH`. The workflow's "Check required
tooling is available" step fails fast with a clear message if either is missing.
