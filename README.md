# Claude Code Simple Agent System

A lightweight, extensible system for creating specialized Claude Code agents with persistent context and custom commands. Perfect for teams wanting domain-specific AI assistants that remember their work between sessions.

## What This Is

This repository provides a template for setting up specialized Claude Code agents in your project. Each agent:
- Has a unique personality and domain expertise
- Maintains context between sessions
- Provides slash commands for common tasks
- Can be launched with simple shell commands

## Quick Start

### Option 1: Clone and Copy

```bash
# Clone this repository
git clone https://github.com/chllming/cc-simple-agent.git

# Copy the .claude directory to your project
cp -r cc-simple-agent/.claude /path/to/your/project/

# Copy shell functions to your home directory
cp cc-simple-agent/shell-functions/claude-agent-functions.sh ~/.claude-agent-functions.sh

# Add to your .zshrc or .bashrc
echo 'source ~/.claude-agent-functions.sh' >> ~/.zshrc
source ~/.zshrc

# Initialize agents in your project
cd /path/to/your/project
ca-init
```

### Option 2: Git Submodule

```bash
# In your project root
git submodule add https://github.com/chllming/cc-simple-agent.git .claude-agent-template

# Copy the template
cp -r .claude-agent-template/.claude .

# Set up shell functions (same as Option 1)
cp .claude-agent-template/shell-functions/claude-agent-functions.sh ~/.claude-agent-functions.sh
echo 'source ~/.claude-agent-functions.sh' >> ~/.zshrc
source ~/.zshrc
```

### Option 3: Quick Setup with VS Code

```bash
# Clone and set up in one command
git clone https://github.com/chllming/cc-simple-agent.git && cd cc-simple-agent && ./setup.sh

# Copy to your project with VS Code terminals config
cp -r .claude /path/to/your/project/
cp .vscode/terminals.json.example /path/to/your/project/.vscode/terminals.json

# Install VS Code Terminals Manager extension
code --install-extension fabiospampinato.vscode-terminals
```

## Directory Structure

```
.claude/
├── agents/           # ⚠️ CLAUDE NATIVE - DO NOT MODIFY
├── systemprompts/    # Your custom agent personalities
├── contexts/         # Agent state persistence
├── commands/         # Slash commands
├── scripts/          # Utility scripts
└── README.md         # Project-specific documentation
```

### Important: `.claude/agents/`

This directory is reserved for Claude Code's native sub-agent functionality. Do not modify files here. See [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code/sub-agents).

## Creating Your First Agent

### 1. Define the Agent

Create `.claude/systemprompts/backend.md`:

```markdown
# Backend Developer Agent

You are a backend development specialist with expertise in APIs, databases, and system architecture.

## Core Responsibilities
- Design and implement RESTful APIs
- Optimize database queries and schemas
- Ensure code quality and testing
- Review security implications

## Key Knowledge
- Node.js, Python, Go
- PostgreSQL, MongoDB, Redis
- Docker, Kubernetes
- CI/CD pipelines

## Standards
- Follow RESTful conventions
- Write comprehensive tests
- Document all APIs
- Consider scalability
```

### 2. Create Initial Context

Create `.claude/contexts/backend_context.md`:

```markdown
# Backend Agent Context

## Recent Activities
- Initial agent setup

## Current Focus
- Learning codebase structure

## Pending Tasks
- Review existing API endpoints
- Identify optimization opportunities

## Important Notes
- Project uses Node.js with TypeScript
- PostgreSQL as primary database
```

### 3. Add Update Command

Create `.claude/commands/update-backend-context.md`:

```markdown
# Update Backend Context

Review your session and update `.claude/contexts/backend_context.md`.

Focus on:
- APIs created or modified
- Database schema changes
- Performance optimizations
- Security improvements
- Test coverage changes
- Technical debt identified
```

### 4. Launch Your Agent

```bash
# Basic launch
ca backend

# With yolo mode (skip permissions)
ca backend --yolo

# Generate quick alias
.claude/scripts/generate-agent-extensions.sh
source .claude/generated-aliases.sh

# Now you can use
ca-backend
```

## Example Agents

This template includes several example agents to get you started:

### Developer Agent
A general software development assistant for coding tasks.

```bash
ca developer
```

### Reviewer Agent
Code review specialist focusing on quality and best practices.

```bash
ca reviewer
```

### Documenter Agent
Technical documentation expert for APIs, guides, and README files.

```bash
ca documenter
```

## Shell Commands

### Core Commands

| Command | Description |
|---------|-------------|
| `ca <agent>` | Launch agent |
| `ca <agent> --yolo` | Launch with permissions bypass |
| `ca <agent> --model claude-3-opus` | Launch with specific model |
| `ca-list` | List available agents |
| `ca-init` | Initialize Claude in a project |
| `ca-init-contexts` | Create missing context files |

### Quick Aliases

Generate convenient aliases for your agents:

```bash
# Generate aliases for all agents
.claude/scripts/generate-agent-extensions.sh

# Source the generated aliases
source .claude/generated-aliases.sh

# List all available aliases
ca-list-aliases
```

After running the generate script, you'll have aliases like:
- `ca-backend` → `ca backend --yolo`
- `ca-frontend` → `ca frontend --yolo`
- `ca-developer` → `ca developer --yolo`
- etc.

These aliases automatically include `--yolo` for permission bypass, making agent launches faster.

## Slash Commands

Every agent should have at least these commands:

| Command | Purpose |
|---------|---------|
| `/update-context` | Generic context update template |
| `/update-{agent}-context` | Agent-specific context update |
| `/gitupdate` | Review and commit changes |

## Extending the System

### Adding New Agents

1. Create system prompt: `.claude/systemprompts/newagent.md`
2. Create context file: `.claude/contexts/newagent_context.md`
3. Generate extensions: `.claude/scripts/generate-agent-extensions.sh`
4. Source aliases: `source .claude/generated-aliases.sh`

### Custom Slash Commands

Create any markdown file in `.claude/commands/` to add new slash commands:

```markdown
# My Custom Command

Description of what this command does.

## Steps:
1. First step
2. Second step
3. Third step
```

### Project-Specific Setup

Create a setup script for your project's agents:

```bash
#!/bin/bash
# setup-project-agents.sh

# Create backend agent
cat > .claude/systemprompts/backend.md << 'EOF'
# Backend Agent
Your backend-specific prompt here...
EOF

# Create frontend agent
cat > .claude/systemprompts/frontend.md << 'EOF'
# Frontend Agent
Your frontend-specific prompt here...
EOF

# Generate extensions
.claude/scripts/generate-agent-extensions.sh

echo "Project agents created!"
```

## Best Practices

### 1. Agent Design
- Keep agents focused on specific domains
- Include relevant technical context
- List key responsibilities clearly
- Specify coding standards

### 2. Context Management
- Update contexts after significant work
- Remove completed tasks
- Keep information actionable
- Include discoveries and decisions

### 3. Naming Conventions
- System prompts: `{agent}.md`
- Context files: `{agent}_context.md`
- Update commands: `update-{agent}-context.md`

### 4. Team Collaboration
- Commit agent prompts to share expertise
- Review and update shared contexts
- Document agent capabilities
- Create agents for common workflows

## Troubleshooting

### "Command not found: ca"
```bash
source ~/.zshrc  # or ~/.bashrc
```

### "No .claude directory found"
```bash
ca-init  # Initialize in current directory
```

### "Agent prompt not found"
```bash
ca-list  # See available agents
```

### Missing context files
```bash
ca-init-contexts  # Create missing context files
```

## Advanced Usage

### Terminal Manager Integration

Integrate Claude agents with VS Code or other terminal managers for instant access to all your agents.

#### VS Code Terminals Configuration

Create `.vscode/terminals.json` in your project:

```json
{
  "autorun": false,
  "autokill": false,
  "terminals": [
    {
      "name": "Developer",
      "description": "General development agent",
      "command": "ca developer",
      "cwd": "${workspaceFolder}",
      "icon": "code"
    },
    {
      "name": "Reviewer",
      "description": "Code review specialist",
      "command": "ca reviewer",
      "cwd": "${workspaceFolder}",
      "icon": "eye"
    },
    {
      "name": "Documenter",
      "description": "Documentation expert",
      "command": "ca documenter",
      "cwd": "${workspaceFolder}",
      "icon": "book"
    },
    {
      "name": "Deploy",
      "description": "Deployment specialist",
      "command": "ca deploy",
      "cwd": "${workspaceFolder}",
      "icon": "rocket"
    },
    {
      "name": "Tester",
      "description": "Test creation agent",
      "command": "ca tester",
      "cwd": "${workspaceFolder}",
      "icon": "beaker"
    },
    {
      "name": "Debugger",
      "description": "Debug specialist",
      "command": "ca debugger",
      "cwd": "${workspaceFolder}",
      "icon": "bug"
    }
  ]
}
```

This requires the [Terminals Manager](https://marketplace.visualstudio.com/items?itemName=fabiospampinato.vscode-terminals) extension.

**Available VS Code Icons**: `code`, `eye`, `book`, `server`, `browser`, `beaker`, `bug`, `rocket`, `shield`, `organization`, `database`, `cloud`, `package`, `gear`, `tools`, `terminal`, `file-code`, `git-branch`, `check`, `x`, `play`, `debug`, `stop`, and many more. See [VS Code Codicon Reference](https://microsoft.github.io/vscode-codicons/dist/codicon.html).

#### Benefits of Terminal Integration

1. **One-Click Access**: Launch any agent with a single click
2. **Visual Organization**: Icons and descriptions for each agent
3. **Persistent Sessions**: Keep agents running in separate tabs
4. **Quick Switching**: Alt/Cmd+Tab between different agents
5. **Workspace Awareness**: Agents start in the correct directory

#### Setting Up for Your Project

1. Install Terminals Manager extension in VS Code
2. Create `.vscode/terminals.json` with your agents
3. Customize icons and descriptions
4. Access via Command Palette: "Terminals: Run"

#### Example Multi-Agent Workflow

With terminals configured, you can:

```
Tab 1 (Developer)  → Write new feature
Tab 2 (Reviewer)   → Review the code
Tab 3 (Tester)     → Create tests
Tab 4 (Documenter) → Update docs
Tab 5 (Deploy)     → Handle deployment
```

Each agent maintains its own context and can be quickly accessed without restarting.

#### Other Terminal Managers

**tmux Configuration Example**:

```bash
#!/bin/bash
# .claude/scripts/tmux-agents.sh

tmux new-session -d -s claude-agents
tmux rename-window -t claude-agents:0 'Developer'
tmux send-keys -t claude-agents:0 'ca developer' C-m

tmux new-window -t claude-agents:1 -n 'Reviewer'
tmux send-keys -t claude-agents:1 'ca reviewer' C-m

tmux new-window -t claude-agents:2 -n 'Documenter'
tmux send-keys -t claude-agents:2 'ca documenter' C-m

tmux attach -t claude-agents
```

**Windows Terminal Configuration**:

Add to `settings.json`:

```json
{
  "profiles": {
    "list": [
      {
        "name": "Claude Developer",
        "commandline": "wsl.exe bash -c 'cd /path/to/project && ca developer'"
      },
      {
        "name": "Claude Reviewer",
        "commandline": "wsl.exe bash -c 'cd /path/to/project && ca reviewer'"
      }
    ]
  }
}
```

### Environment-Specific Agents

Create agents for different environments:

```bash
.claude/systemprompts/prod-debug.md    # Production debugging
.claude/systemprompts/test-writer.md   # Test creation
.claude/systemprompts/deploy.md        # Deployment specialist
```

### Chain Agents

Use multiple agents in sequence:

```bash
# Development session
ca developer      # Write feature
ca reviewer       # Review code
ca test-writer    # Add tests
ca documenter     # Update docs
```

### Project Templates

Create reusable agent sets:

```bash
# Save your agent set
tar -czf my-agents.tar.gz .claude/systemprompts/*.md

# Apply to new project
tar -xzf my-agents.tar.gz -C /new/project/
```

## Contributing

To improve this template:

1. Fork the repository
2. Add new example agents
3. Improve documentation
4. Submit a pull request

## License

MIT License - Use freely in your projects!

## Support

- **Issues**: [GitHub Issues](https://github.com/chllming/cc-simple-agent/issues)
- **Discussions**: [GitHub Discussions](https://github.com/chllming/cc-simple-agent/discussions)

---

Made with ❤️ for the Claude Code community