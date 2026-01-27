# Command Format Patterns

## Structure

Commands are Markdown files in `.claude/commands/`:

```markdown
# Command Name

Brief description of what this command does.

## Instructions

Step-by-step instructions for Claude to follow when this command is invoked.

## Input

What the user provides (if anything).

## Output

What the command produces.
```

## Rules

- One command per file: `command-name.md`
- Use kebab-case for filenames
- Start with a clear purpose statement
- Include explicit step-by-step instructions
- Specify expected inputs and outputs
- Keep commands focused — one task per command
- Namespace with directories: `.claude/commands/agent-os/`
