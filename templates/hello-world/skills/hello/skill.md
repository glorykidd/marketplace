---
name: hello-world:hello
description: Entry point for the hello-world plugin. Routes to greet (command) or greeter (agent) based on the argument. Usage - /hello-world:hello [greet <name> | agent]
allowed-tools: Bash
argument-hint: "[greet <name> | agent]"
---

# Hello World Router

A simple router that demonstrates how a skill can serve as a single entry point to a plugin's commands and agents.

## Argument Parsing

Parse the first word as the mode:
- `greet` — run the greet command for the optional name that follows
- `agent` — hand off to the greeter agent
- *(nothing)* — show the two options and ask which to use

## Routing

| Mode | Action |
|---|---|
| `greet <name>` | Run `/hello-world:greet <name>` |
| `agent` | Invoke the `hello-world:greeter` agent |
| *(none)* | List options and prompt the user |

## Purpose

This skill exists to show the three-layer plugin structure:
1. **commands/** — stateless slash commands invoked directly
2. **agents/** — autonomous subagents with their own tool access and instructions
3. **skills/** — router/entry-point skills that tie the plugin together
