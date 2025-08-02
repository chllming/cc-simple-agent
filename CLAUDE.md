# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Claude Code Simple Agent System - a lightweight framework for creating specialized Claude Code agents with persistent context and custom commands. It allows teams to build domain-specific AI assistants that maintain state between sessions.

## Architecture

### Core Components

1. **Shell Functions** (`shell-functions/claude-agent-functions.sh`):
   - Main entry point: `claude-agent()` function (aliased as `ca`)
   - Finds project root by searching for `.claude` directory
   - Launches Claude with agent-specific system prompts
   - Supports model selection and permission bypass flags

2. **Agent System** (`.claude/` directory structure):
   - `systemprompts/`: Agent personality and expertise definitions
   - `contexts/`: Persistent agent state between sessions
   - `commands/`: Slash commands for common tasks
   - `scripts/`: Utility scripts for agent management
   - `settings.local.json`: Local permission settings

3. **Key Scripts**:
   - `setup.sh`: One-time installation of shell functions
   - `.claude/scripts/generate-agent-extensions.sh`: Creates quick aliases
   - `.claude/scripts/check-context-parity.sh`: Validates context files
   - `.claude/scripts/tmux-agents.sh`: Multi-agent tmux setup

## Development Commands

This is a bash script-based project with no build/test commands. Key commands:

```bash
# Installation
./setup.sh                    # Install shell functions to ~/.claude-agent-functions.sh

# Agent Management
ca <agent>                    # Launch agent
ca <agent> --yolo            # Launch with permission bypass
ca <agent> --model <model>   # Launch with specific model
ca-list                      # List available agents
ca-init                      # Initialize .claude in a project
ca-init-contexts             # Create missing context files

# Script Execution
.claude/scripts/generate-agent-extensions.sh    # Generate quick aliases
```

## Agent Creation Workflow

1. Create system prompt: `.claude/systemprompts/{agent}.md`
2. Create context file: `.claude/contexts/{agent}_context.md`
3. Create update command: `.claude/commands/update-{agent}-context.md`
4. Generate aliases: `.claude/scripts/generate-agent-extensions.sh`
5. Launch: `ca {agent}`

## Important Implementation Details

- The `.claude/agents/` directory is reserved for Claude Code's native sub-agent functionality - never modify
- Agent launcher searches up directory tree for `.claude` directory
- Caches project root in `CLAUDE_PROJECT_ROOT` environment variable
- Context files are automatically loaded when agent starts
- Shell functions must be sourced from `.zshrc` or `.bashrc`
- VS Code Terminals Manager integration available via `.vscode/terminals.json.example`

## Common Patterns

- Agents read their context on startup: `.claude/contexts/{agent}_context.md`
- Update commands follow naming: `/update-{agent}-context`
- System prompts define agent personality, expertise, and standards
- Context files track recent activities, current focus, and pending tasks

## CI/CD Recommendations

For projects using this agent system, consider these CI checks:

1. **Context Parity Check**: Include `.claude/scripts/check-context-parity.sh` in CI to ensure every agent has a context file
2. **Prompt Size Check**: Verify system prompts stay under 3KB to manage context window usage
3. **Script Validation**: Run shellcheck on all `.sh` files in `.claude/scripts/`

Example GitHub Actions workflow:
```yaml
- name: Check agent context parity
  run: .claude/scripts/check-context-parity.sh
  
- name: Check prompt sizes
  run: find .claude/systemprompts -name "*.md" -size +3k -exec echo "Warning: {} exceeds 3KB" \;
```