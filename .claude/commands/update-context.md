# Update Agent Context

Review your work in this session and update your context file to reflect current state.

## Steps:
1. Review all activities, discoveries, and tasks from this session
2. Read your current context file at `.claude/contexts/${AGENT_NAME}_context.md`
3. Update the context file by:
   - Adding new activities to "Recent Activities"
   - Updating "Current Focus" with active work
   - Moving completed items out of "Pending Tasks"
   - Adding new pending tasks
   - Updating "Important Notes" with key discoveries
   - Removing deprecated or no longer relevant information
4. Ensure the context remains concise and actionable

## Template:
```markdown
# ${AGENT_NAME} Context

## Recent Activities
- [Add new activities from this session]
- [Keep relevant recent activities]

## Current Focus
- [Update with current priorities]
- [Remove completed focus areas]

## Pending Tasks
- [Add new tasks identified]
- [Remove completed tasks]
- [Keep ongoing tasks]

## Important Notes
- [Add new discoveries/decisions]
- [Keep relevant notes]
- [Remove outdated information]
```

Remember: Keep context actionable for future sessions!