#!/bin/bash
# Setup script for Claude Agent System

set -euo pipefail

echo "Claude Agent System Setup"
echo "========================="
echo ""

# Detect shell
SHELL_RC=""
if [[ -f "$HOME/.zshrc" ]]; then
    SHELL_RC="$HOME/.zshrc"
    echo "Detected shell: zsh"
elif [[ -f "$HOME/.bashrc" ]]; then
    SHELL_RC="$HOME/.bashrc"
    echo "Detected shell: bash"
else
    echo "Error: Could not detect shell configuration file"
    echo "Please manually add the following to your shell rc file:"
    echo "source ~/.claude-agent-functions.sh"
    exit 1
fi

# Copy shell functions
echo "Installing shell functions..."
cp shell-functions/claude-agent-functions.sh "$HOME/.claude-agent-functions.sh"

# Check if already sourced
if ! grep -q "claude-agent-functions.sh" "$SHELL_RC"; then
    echo "" >> "$SHELL_RC"
    echo "# Claude Agent System" >> "$SHELL_RC"
    echo "source ~/.claude-agent-functions.sh" >> "$SHELL_RC"
    echo "Added to $SHELL_RC"
else
    echo "Already configured in $SHELL_RC"
fi

# Make scripts executable
chmod +x .claude/scripts/*.sh

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Reload your shell: source $SHELL_RC"
echo "2. Copy .claude directory to your project"
echo "3. Run 'ca-help' for usage information"
echo ""
echo "Quick start:"
echo "  cd /your/project"
echo "  cp -r $(pwd)/.claude ."
echo "  ca-init"
echo "  ca developer"