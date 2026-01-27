# Standards Authoring Patterns

## Structure

Standards are Markdown files organized by category:

```
standards/
├── global/           # Apply everywhere
│   ├── tech-stack.md
│   └── naming.md
└── patterns/         # Specific patterns
    ├── components.md
    └── testing.md
```

## File Format

```markdown
# Standard Title

## Brief description or principles

- Key principle 1
- Key principle 2

## Example

\`\`\`typescript
// Code example showing the pattern
\`\`\`

## Rules

- Concrete, actionable rules
- Things to do and avoid
```

## Rules

- Keep standards concise — under 100 lines per file
- Include code examples for every pattern
- Write rules as actionable directives, not vague principles
- Use `global/` for universal standards, `patterns/` for specific patterns
- Standards should be profile-aware — override `tech-stack.md` per profile
