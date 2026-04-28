# GloryKidd Skills Marketplace

A public marketplace of Claude Code plugins — skills, agents, and bundles you can browse and install.

## Plugins

| Name | Type | Description |
|---|---|---|
| [commit-message](./plugins/commit-message) | skill | Generate conventional commit messages from staged changes |
| [pr-description](./plugins/pr-description) | skill | Generate PR descriptions from branch diff |
| [debug-assistant](./plugins/debug-assistant) | bundle | Root cause analysis + autonomous debugging agent |

## Contributing

See [CLAUDE.md](./CLAUDE.md) for the full contribution guide.

Quick steps:
1. Create `plugins/<your-plugin-name>/`
2. Add `.claude-plugin/plugin.json`, command/agent `.md` files, and a `README.md`
3. Run `./generate-registry.sh`
4. Open a pull request
