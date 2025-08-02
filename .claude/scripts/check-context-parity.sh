#!/bin/bash
set -euo pipefail

# Check that every systemprompt has a matching context file
PROJECT_ROOT="${1:-$(pwd)}"
PROMPTS_DIR="${PROJECT_ROOT}/.claude/systemprompts"
CONTEXTS_DIR="${PROJECT_ROOT}/.claude/contexts"

if [[ ! -d "$PROMPTS_DIR" ]]; then
    echo "Error: No systemprompts directory found at $PROMPTS_DIR"
    exit 1
fi

missing_contexts=()
for prompt_file in "$PROMPTS_DIR/"*.md; do
    if [[ -f "$prompt_file" ]]; then
        agent_name="$(basename "$prompt_file" .md)"
        # Skip README files
        if [[ "$agent_name" == "README" ]]; then
            continue
        fi
        context_file="${CONTEXTS_DIR}/${agent_name}_context.md"
        if [[ ! -f "$context_file" ]]; then
            missing_contexts+=("$agent_name")
        fi
    fi
done

if [[ ${#missing_contexts[@]} -gt 0 ]]; then
    echo "Error: Missing context files for agents: ${missing_contexts[*]}"
    echo "Run 'ca-init-contexts' to create them"
    exit 1
fi

echo "✓ All agents have matching context files"
exit 0