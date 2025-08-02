# Claude Agents for This Project

This directory contains the Claude agent system configuration for this project.

## Directory Structure

```
.claude/
├── agents/           # ⚠️ Claude native sub-agents (DO NOT MODIFY)
├── systemprompts/    # Agent personality definitions
├── contexts/         # Agent state between sessions
├── commands/         # Slash commands
├── scripts/          # Utility scripts
└── README.md         # This file
```

## Available Agents

| Agent | Purpose | Launch Command |
|-------|---------|----------------|
| developer | General development tasks | `ca developer` |
| reviewer | Code review and quality checks | `ca reviewer` |
| documenter | Documentation creation | `ca documenter` |

## Quick Start

```bash
# List all agents
ca-list

# Launch an agent
ca developer

# Launch with yolo mode
ca developer --yolo

# Generate quick aliases
.claude/scripts/generate-agent-extensions.sh
source .claude/generated-aliases.sh

# Use quick alias
ca-developer
```

## Adding New Agents

1. Create system prompt: `.claude/systemprompts/newagent.md`
2. Create context file: `.claude/contexts/newagent_context.md`
3. Run: `.claude/scripts/generate-agent-extensions.sh`
4. Launch: `ca newagent`

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/update-context` | Generic context update |
| `/update-{agent}-context` | Agent-specific context update |
| `/gitupdate` | Review and commit changes |

## Maintaining Context

Use slash commands to update agent context after work sessions:
- `/update-developer-context` - After development work
- `/update-reviewer-context` - After code reviews
- `/update-documenter-context` - After documentation

## Best Practices

1. Update context regularly to maintain continuity
2. Keep agents focused on specific domains
3. Commit important context changes
4. Use appropriate agents for different tasks

## Customization

Edit the agent prompts in `systemprompts/` to customize behavior for your project's needs.

---

For more information: https://github.com/chllming/cc-simple-agent