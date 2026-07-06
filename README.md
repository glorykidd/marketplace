# GloryKidd Skills Marketplace

A public marketplace of Claude Code plugins — skills, agents, and bundles you can browse and install.

## Plugins

| Name | Type | Description |
|---|---|---|
| [commit-message](./plugins/commit-message) | skill | Generate conventional commit messages from staged changes |
| [pr-description](./plugins/pr-description) | skill | Generate PR descriptions from branch diff |
| [debug-assistant](./plugins/debug-assistant) | bundle | Root cause analysis command + autonomous debugging agent |
| [interview](./plugins/interview) | skill | Full interview workflow: workspace setup, pre-screening assessment, question guide, and scored evaluation with PDF export |
| [security-review](./plugins/security-review) | bundle | Comprehensive security audit against OWASP Top 10, CWE, NIST 800-53, CIS Benchmarks, SOC 2, ISO 27001 |
| [display-slide](./plugins/display-slide) | skill | Build polished 1920x1080 PNG announcement slides for church, school, or ministry lobby screens |

## How It Works

Each plugin lives in `plugins/<name>/` and is described by a manifest at `.claude-plugin/plugin.json`. The `registry.json` at the root is the auto-generated index consumed by Claude Code when installing plugins.

Plugin types:

| Type | Description |
|---|---|
| **skill** | One or more slash commands (`/plugin:command`) |
| **agent** | One or more autonomous subagents |
| **bundle** | Both commands and agents |
| **mcp** | An MCP server, optionally with commands |

## Templates

The [`templates/hello-world`](./templates/hello-world) directory is a copy-paste starter that demonstrates the full plugin structure — a command, an agent, a skill router, and a manifest — with inline documentation explaining each piece.

## Contributing

See [CLAUDE.md](./CLAUDE.md) for the full contribution guide.

Quick steps:
1. Copy `templates/hello-world` to `plugins/<your-plugin-name>/`
2. Update `.claude-plugin/plugin.json` with your name, description, and author
3. Replace the command/agent/skill files with your own logic
4. Run `./generate-registry.sh`
5. Add your plugin entry to `.claude-plugin/marketplace.json`
6. Open a pull request
