# Git Update - Review, Commit, and Push

Review all changes in the repository, create a meaningful commit, and push to remote.

## Steps:

1. **Review Repository Status**
   - Run `git status` to see all changes
   - Run `git diff` to review unstaged changes
   - Run `git diff --staged` to review staged changes
   - Check for untracked files that should be included

2. **Analyze Changes**
   - Group related changes together
   - Identify the primary purpose of the changes
   - Note any breaking changes or important updates
   - Check for sensitive information that shouldn't be committed

3. **Stage Appropriate Files**
   - Add relevant files to staging area
   - Exclude any temporary files, logs, or local configurations
   - Ensure .gitignore rules are being followed

4. **Create Meaningful Commit**
   - Write a clear, concise commit message that explains:
     - What changed (brief summary in first line)
     - Why it changed (if not obvious)
     - Any impacts or considerations
   - Follow the project's commit convention

5. **Push to Remote**
   - Push the commit to the appropriate branch
   - Verify the push was successful

## Commit Message Format:
```
<type>: <brief description>

<optional detailed explanation>

<optional footer with breaking changes or issues>
```

Where type is one of:
- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- style: Code style changes (formatting, etc)
- refactor: Code refactoring
- test: Test additions or changes
- chore: Maintenance tasks

## Important Reminders:
- Never commit sensitive data (API keys, passwords, etc.)
- Ensure all tests pass before committing
- Review changes carefully to avoid committing unintended files
- Keep commits focused - one logical change per commit