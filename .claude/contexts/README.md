# Context File Template

This directory contains context files that help agents maintain state between sessions. Each agent should have a corresponding `{agent}_context.md` file.

## Recommended Structure

Context files should follow this general structure:

```markdown
# {Agent} Agent Context

## Recent Activities
- List recent tasks completed
- Include important changes made
- Note any significant discoveries

## Current Focus
- What you're actively working on
- Current priorities or goals
- Active investigations or explorations

## Pending Tasks
- Tasks that need to be completed
- Follow-up items from previous sessions
- Issues that need resolution

## Important Notes
- Key project-specific information
- Critical paths, dependencies, or configurations
- Lessons learned or gotchas to remember
- Environment-specific considerations

## Technical Details (optional)
- Specific configuration values
- Important file paths or dependencies
- API endpoints or service details
```

## Best Practices

1. **Keep it Actionable**: Focus on information that helps guide future work
2. **Regular Updates**: Update after significant work sessions using `/update-{agent}-context`
3. **Remove Completed Items**: Clean up completed tasks to keep context relevant
4. **Be Specific**: Include file paths, function names, and specific details
5. **Security**: Never include secrets, tokens, or sensitive data

## Example Entry

```markdown
## Recent Activities
- Implemented user authentication in `src/auth/login.ts`
- Added rate limiting middleware to API endpoints
- Fixed memory leak in WebSocket connection handler

## Current Focus
- Optimizing database queries for user dashboard
- Investigating slow response times in `/api/users` endpoint

## Pending Tasks
- Add unit tests for authentication module
- Update API documentation for new endpoints
- Review and merge PR #123
```

## Maintenance

- Context files are tracked in git to maintain project knowledge
- Teams can review context files to understand ongoing work
- Use `ca-init-contexts` to create missing context files
- Run `.claude/scripts/check-context-parity.sh` to verify all agents have contexts