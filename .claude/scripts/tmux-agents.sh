#!/bin/bash
# Launch multiple Claude agents in tmux sessions
# Usage: .claude/scripts/tmux-agents.sh

set -euo pipefail

SESSION_NAME="claude-agents"

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "Error: tmux is not installed. Please install tmux first."
    exit 1
fi

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    tmux attach -t "$SESSION_NAME"
    exit 0
fi

# Create new session with developer agent
tmux new-session -d -s "$SESSION_NAME" -n 'Developer'
tmux send-keys -t "$SESSION_NAME:0" 'ca developer' C-m

# Add reviewer agent
tmux new-window -t "$SESSION_NAME:1" -n 'Reviewer'
tmux send-keys -t "$SESSION_NAME:1" 'ca reviewer' C-m

# Add documenter agent
tmux new-window -t "$SESSION_NAME:2" -n 'Documenter'
tmux send-keys -t "$SESSION_NAME:2" 'ca documenter' C-m

# Optional: Add more agents as needed
# tmux new-window -t "$SESSION_NAME:3" -n 'Backend'
# tmux send-keys -t "$SESSION_NAME:3" 'ca backend' C-m

# tmux new-window -t "$SESSION_NAME:4" -n 'Frontend'
# tmux send-keys -t "$SESSION_NAME:4" 'ca frontend' C-m

# Select first window
tmux select-window -t "$SESSION_NAME:0"

# Attach to session
echo "Launching Claude agents in tmux..."
echo "Use Ctrl+B then window number (0-2) to switch between agents"
echo "Use Ctrl+B then D to detach from session"
tmux attach -t "$SESSION_NAME"