# hello-world

A minimal example plugin that demonstrates the full marketplace plugin structure. Use this as a starting point when creating a new plugin.

## Usage

```
/hello-world:hello greet Claude
/hello-world:hello agent
/hello-world:greet World
```

## Plugin Structure

```
hello-world/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest — name, version, author, metadata
├── commands/
│   └── greet.md             # Slash command: /hello-world:greet <name>
├── agents/
│   └── greeter.md           # Subagent: hello-world:greeter
├── skills/
│   └── hello/
│       └── skill.md         # Router skill: /hello-world:hello
└── README.md
```

### What each piece does

| File | Type | Purpose |
|---|---|---|
| `.claude-plugin/plugin.json` | Manifest | Registers the plugin with name, version, author, and governance metadata |
| `commands/greet.md` | Command | A stateless slash command — takes an argument and responds directly |
| `agents/greeter.md` | Agent | An autonomous subagent with its own tools, model, and instructions |
| `skills/hello/skill.md` | Skill router | Single entry point that routes to commands or agents |

## Creating Your Own Plugin

1. Copy this folder to `plugins/<your-plugin-name>/`
2. Update `.claude-plugin/plugin.json` — change `name`, `description`, and `author`
3. Replace the command, agent, and skill files with your own logic
4. Run `./generate-registry.sh` from the repo root
5. Add your plugin entry to `.claude-plugin/marketplace.json`
6. Open a pull request
