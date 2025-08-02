#!/bin/bash
# Claude Agent System - Shell Functions
# Source this file from your .zshrc or .bashrc

# Claude agent launcher - reads from current project's .claude/systemprompts/
claude-agent() {
    set -euo pipefail
    local AGENT="$1"
    shift
    
    local YOLO=""
    local MODEL=""
    local EXTRA_ARGS=()
    
    # Parse remaining arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --yolo)
                YOLO="--dangerously-skip-permissions"
                shift
                ;;
            --model)
                MODEL="--model $2"
                shift 2
                ;;
            *)
                EXTRA_ARGS+=("$1")
                shift
                ;;
        esac
    done
    
    # Find project root (with caching)
    local PROJECT_ROOT=""
    if [[ -n "${CLAUDE_PROJECT_ROOT:-}" ]] && [[ -d "${CLAUDE_PROJECT_ROOT}/.claude" ]]; then
        PROJECT_ROOT="$CLAUDE_PROJECT_ROOT"
    else
        local SEARCH_DIR="$PWD"
        while [[ "$SEARCH_DIR" != "/" ]]; do
            if [[ -d "${SEARCH_DIR}/.claude" ]]; then
                PROJECT_ROOT="$SEARCH_DIR"
                export CLAUDE_PROJECT_ROOT="$PROJECT_ROOT"
                break
            fi
            SEARCH_DIR="$(dirname "$SEARCH_DIR")"
        done
    fi
    
    if [[ -z "$PROJECT_ROOT" ]]; then
        echo "Error: No .claude directory found in current project hierarchy"
        echo "Run 'claude-init' to initialize Claude for this project"
        return 1
    fi
    
    local PROMPTS_DIR="${PROJECT_ROOT}/.claude/systemprompts"
    local CONTEXTS_DIR="${PROJECT_ROOT}/.claude/contexts"
    
    # Check if systemprompts directory exists
    if [[ ! -d "$PROMPTS_DIR" ]]; then
        echo "Error: No systemprompts directory found at $PROMPTS_DIR"
        echo "Run 'claude-init' to set up system prompts for this project"
        return 1
    fi
    
    # Check if agent prompt exists
    local AGENT_PROMPT_FILE="${PROMPTS_DIR}/${AGENT}.md"
    if [[ ! -f "$AGENT_PROMPT_FILE" ]]; then
        echo "Agent prompt not found: $AGENT"
        echo "Available agents in $PROJECT_ROOT:"
        ls -1 "$PROMPTS_DIR" 2>/dev/null | sed 's/\.md$//' | sort
        return 1
    fi
    
    # Build the initial prompt
    local INITIAL_PROMPT=""
    local CONTEXT_FILE="${CONTEXTS_DIR}/${AGENT}_context.md"
    
    if [[ -f "$CONTEXT_FILE" ]]; then
        INITIAL_PROMPT="Please read .claude/contexts/${AGENT}_context.md and analyze your current state, then wait for user input."
    else
        INITIAL_PROMPT="Context file .claude/contexts/${AGENT}_context.md not found. Proceeding without context. Please wait for user input."
    fi
    
    # Launch Claude with the agent prompt appended and initial context loading
    cd "$PROJECT_ROOT"
    
    # Build command array
    local cmd=(claude)
    [[ -n "$YOLO" ]] && cmd+=($YOLO)
    [[ -n "$MODEL" ]] && cmd+=($MODEL)
    cmd+=(--append-system-prompt "$(cat "$AGENT_PROMPT_FILE")")
    [[ ${#EXTRA_ARGS[@]} -gt 0 ]] && cmd+=("${EXTRA_ARGS[@]}")
    cmd+=("$INITIAL_PROMPT")
    
    # Execute command
    "${cmd[@]}"
}

# Project initialization function
claude-init() {
    set -euo pipefail
    local PROJECT_ROOT="${1:-$PWD}"
    
    echo "Initializing Claude for project: $PROJECT_ROOT"
    
    # Create .claude directory structure
    mkdir -p "${PROJECT_ROOT}/.claude/systemprompts"
    mkdir -p "${PROJECT_ROOT}/.claude/contexts"
    mkdir -p "${PROJECT_ROOT}/.claude/commands"
    mkdir -p "${PROJECT_ROOT}/.claude/scripts"
    
    # Create a sample agent prompt
    if [[ ! -f "${PROJECT_ROOT}/.claude/systemprompts/default.md" ]]; then
        cat > "${PROJECT_ROOT}/.claude/systemprompts/default.md" << 'EOF'
# Default Agent System Prompt

You are an AI assistant helping with this specific project.

## Project Context
- Add project-specific context here
- Include key architectural decisions
- List important conventions

## Key Paths
- Document important directories
- List key configuration files

## Development Commands
- Include common commands
- Build/test/deploy scripts
EOF
        echo "Created sample agent: ${PROJECT_ROOT}/.claude/systemprompts/default.md"
    fi
    
    # Create README if it doesn't exist
    if [[ ! -f "${PROJECT_ROOT}/.claude/README.md" ]]; then
        cat > "${PROJECT_ROOT}/.claude/README.md" << 'EOF'
# Claude Agents for This Project

This directory contains specialized Claude agents for this project.

## Available Agents

- `default` - General purpose assistant

## Usage

```bash
ca default        # Launch default agent
ca-list          # List all agents
```

## Adding New Agents

1. Create `.claude/systemprompts/newagent.md`
2. Create `.claude/contexts/newagent_context.md`
3. Run `.claude/scripts/generate-agent-extensions.sh`
4. Launch with `ca newagent`
EOF
    fi
    
    # Copy scripts if they don't exist
    if [[ ! -f "${PROJECT_ROOT}/.claude/scripts/generate-agent-extensions.sh" ]]; then
        # Try to find the template directory
        local TEMPLATE_DIR=""
        if [[ -d "${HOME}/cc-simple-agent/.claude/scripts" ]]; then
            TEMPLATE_DIR="${HOME}/cc-simple-agent"
        elif [[ -d "${HOME}/.claude-agent-template/.claude/scripts" ]]; then
            TEMPLATE_DIR="${HOME}/.claude-agent-template"
        fi
        
        if [[ -n "$TEMPLATE_DIR" ]]; then
            cp "${TEMPLATE_DIR}/.claude/scripts/"*.sh "${PROJECT_ROOT}/.claude/scripts/" 2>/dev/null || true
            chmod +x "${PROJECT_ROOT}/.claude/scripts/"*.sh 2>/dev/null || true
        fi
    fi
    
    # Set cached project root if we're in the initialized directory
    if [[ "$PWD" == "$PROJECT_ROOT"* ]]; then
        export CLAUDE_PROJECT_ROOT="$PROJECT_ROOT"
    fi
    
    echo "Claude initialized for project!"
    echo "Add agent prompts to: ${PROJECT_ROOT}/.claude/systemprompts/"
    echo "Use 'ca <agent-name>' to launch with a specific agent"
}

# Helper to copy agents from one project to another
claude-copy-agents() {
    set -euo pipefail
    local SOURCE_PROJECT="$1"
    local DEST_PROJECT="${2:-$PWD}"
    
    if [[ ! -d "${SOURCE_PROJECT}/.claude/systemprompts" ]]; then
        echo "Error: Source project doesn't have .claude/systemprompts/"
        return 1
    fi
    
    mkdir -p "${DEST_PROJECT}/.claude/systemprompts"
    mkdir -p "${DEST_PROJECT}/.claude/contexts"
    
    echo "Copying agents from $SOURCE_PROJECT to $DEST_PROJECT"
    cp -v "${SOURCE_PROJECT}/.claude/systemprompts/"*.md "${DEST_PROJECT}/.claude/systemprompts/" 2>/dev/null || true
    
    # Initialize empty context files for copied agents
    for prompt_file in "${DEST_PROJECT}/.claude/systemprompts/"*.md; do
        if [[ -f "$prompt_file" ]]; then
            local agent_name="$(basename "$prompt_file" .md)"
            local context_file="${DEST_PROJECT}/.claude/contexts/${agent_name}_context.md"
            if [[ ! -f "$context_file" ]]; then
                echo "# ${agent_name} Agent Context" > "$context_file"
                echo "" >> "$context_file"
                echo "<!-- Update this file with agent-specific context -->" >> "$context_file"
                echo "Created context: ${agent_name}"
            fi
        fi
    done
}

# Short aliases
alias ca="claude-agent"
alias ca-init="claude-init"
alias ca-copy="claude-copy-agents"

# Helper to initialize missing context files
ca-init-contexts() {
    set -euo pipefail
    
    local PROJECT_ROOT="${CLAUDE_PROJECT_ROOT:-}"
    if [[ -z "$PROJECT_ROOT" ]]; then
        ca-list > /dev/null  # This will find and cache PROJECT_ROOT
        PROJECT_ROOT="${CLAUDE_PROJECT_ROOT:-}"
    fi
    
    if [[ -z "$PROJECT_ROOT" ]]; then
        echo "Error: No project root found"
        return 1
    fi
    
    local PROMPTS_DIR="${PROJECT_ROOT}/.claude/systemprompts"
    local CONTEXTS_DIR="${PROJECT_ROOT}/.claude/contexts"
    
    mkdir -p "$CONTEXTS_DIR"
    
    for prompt_file in "$PROMPTS_DIR/"*.md; do
        if [[ -f "$prompt_file" ]]; then
            local agent_name="$(basename "$prompt_file" .md)"
            # Skip README files
            if [[ "$agent_name" == "README" ]]; then
                continue
            fi
            local context_file="${CONTEXTS_DIR}/${agent_name}_context.md"
            if [[ ! -f "$context_file" ]]; then
                echo "# ${agent_name} Agent Context" > "$context_file"
                echo "" >> "$context_file"
                echo "## Recent Activities" >> "$context_file"
                echo "- Agent initialized" >> "$context_file"
                echo "" >> "$context_file"
                echo "## Current Focus" >> "$context_file"
                echo "- Getting started with the project" >> "$context_file"
                echo "" >> "$context_file"
                echo "## Pending Tasks" >> "$context_file"
                echo "- Review project structure" >> "$context_file"
                echo "" >> "$context_file"
                echo "## Important Notes" >> "$context_file"
                echo "- Add project-specific notes here" >> "$context_file"
                echo "Created context: ${agent_name}"
            fi
        fi
    done
}

# List available agents in current project
ca-list() {
    set -euo pipefail
    
    # Use cached project root if available
    local PROJECT_ROOT=""
    if [[ -n "${CLAUDE_PROJECT_ROOT:-}" ]] && [[ -d "${CLAUDE_PROJECT_ROOT}/.claude" ]]; then
        PROJECT_ROOT="$CLAUDE_PROJECT_ROOT"
    else
        local SEARCH_DIR="$PWD"
        while [[ "$SEARCH_DIR" != "/" ]]; do
            if [[ -d "${SEARCH_DIR}/.claude" ]]; then
                PROJECT_ROOT="$SEARCH_DIR"
                export CLAUDE_PROJECT_ROOT="$PROJECT_ROOT"
                break
            fi
            SEARCH_DIR="$(dirname "$SEARCH_DIR")"
        done
    fi
    
    if [[ -z "$PROJECT_ROOT" ]]; then
        echo "Error: No .claude directory found in current project"
        return 1
    fi
    
    local PROMPTS_DIR="${PROJECT_ROOT}/.claude/systemprompts"
    
    if [[ ! -d "$PROMPTS_DIR" ]]; then
        echo "No systemprompts directory found in project"
        echo "Run 'ca-init' to initialize"
        return 1
    fi
    
    echo "Available agents in $PROJECT_ROOT:"
    ls -1 "$PROMPTS_DIR" 2>/dev/null | grep -v README | sed 's/\.md$//' | sort
    
    # Check for missing context files
    local missing_contexts=()
    for prompt_file in "$PROMPTS_DIR/"*.md; do
        if [[ -f "$prompt_file" ]]; then
            local agent_name="$(basename "$prompt_file" .md)"
            # Skip README files
            if [[ "$agent_name" == "README" ]]; then
                continue
            fi
            if [[ ! -f "${PROJECT_ROOT}/.claude/contexts/${agent_name}_context.md" ]]; then
                missing_contexts+=("$agent_name")
            fi
        fi
    done
    
    if [[ ${#missing_contexts[@]} -gt 0 ]]; then
        echo ""
        echo "Warning: Missing context files for: ${missing_contexts[*]}"
        echo "Run 'ca-init-contexts' to create them"
    fi
}

# Display help
ca-help() {
    cat << 'EOF'
Claude Agent System - Help

COMMANDS:
  ca <agent>              Launch an agent
  ca <agent> --yolo       Launch with permissions bypass
  ca <agent> --model X    Launch with specific model
  ca-list                 List available agents
  ca-init                 Initialize Claude in current directory
  ca-init-contexts        Create missing context files
  ca-copy <src> [dest]    Copy agents from another project
  ca-help                 Show this help message

EXAMPLES:
  ca backend              Launch backend agent
  ca frontend --yolo      Launch frontend agent with yolo mode
  ca-list                 See all available agents

QUICK START:
  1. cd /your/project
  2. ca-init
  3. Create .claude/systemprompts/myagent.md
  4. ca myagent

For more information, see:
https://github.com/chllming/cc-simple-agent
EOF
}

# Optional: Auto-setup when entering directories
# Uncomment to enable automatic agent loading
# ca-auto-setup() {
#     local SEARCH_DIR="$PWD"
#     while [[ "$SEARCH_DIR" != "/" ]]; do
#         if [[ -d "${SEARCH_DIR}/.claude" ]]; then
#             export CLAUDE_PROJECT_ROOT="$SEARCH_DIR"
#             return 0
#         fi
#         SEARCH_DIR="$(dirname "$SEARCH_DIR")"
#     done
# }
# 
# # Hook into cd command
# ca-cd() {
#     builtin cd "$@"
#     ca-auto-setup
# }
# alias cd='ca-cd'

echo "Claude Agent System loaded. Type 'ca-help' for usage."