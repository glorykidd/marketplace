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
│   └── marketplace.json        # Top-level marketplace manifest
├── plugins/
│   └── <plugin-name>/
│       ├── .claude-plugin/
│       │   └── plugin.json     # Per-plugin manifest
│       ├── commands/           # Skill files (.md)
│       ├── agents/             # Agent files (.md)
│       ├── mcp/
│       │   └── server.json     # MCP server config (MCP plugins only)
│       └── README.md
├── registry.json               # Auto-generated index (source of truth for installers)
├── generate-registry.sh        # Regenerates registry.json from plugins/
├── .claude/
│   └── settings.json           # Allowed bash commands
└── CLAUDE.md
```

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
- `registry.json` is always regenerated via `./generate-registry.sh` — never edit it manually
- `maxDataClassification` must be `Public` for all community-submitted plugins

## Adding a New Plugin

1. Create `plugins/<name>/` directory
2. Add `.claude-plugin/plugin.json`
3. Add command files in `commands/` and/or agent files in `agents/`
4. Add a `README.md`
5. Run `./generate-registry.sh`
6. Update `.claude-plugin/marketplace.json` to include the new plugin entry
7. Commit all files including the updated `registry.json`

## Commands & Scripts

```bash
# Regenerate registry from all plugins
./generate-registry.sh

# Validate registry JSON
python3 -m json.tool registry.json
```
