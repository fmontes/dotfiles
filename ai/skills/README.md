# Skills

My personal collection of agent skills for Claude Code and other coding agents.

## Structure

```
skills/
├── <skill-name>/SKILL.md
└── <skill-name>/SKILL.md
```

Each skill lives in its own folder with a `SKILL.md` describing what it does and how to use it.

## Adding a Skill

1. Create a folder: `<skill-name>/`
2. Add a `SKILL.md` with frontmatter:

   ```markdown
   ---
   name: skill-name
   description: One-line summary of when to use this skill.
   ---

   # Skill body
   ```

3. List it in this README under Reference.

## Reference

- **[brainstorm](./brainstorm/SKILL.md)** — Interview-style grilling that walks every branch of a plan, surfaces trade-offs you missed, and ends with an executable spec.

  ```bash
  npx skills add https://github.com/fmontes/dotfiles/tree/main/ai --skill brainstorm
  ```

- **[check-review](./check-review/SKILL.md)** — Pull PR review comments and triage each one against the diff into Fix / Skip / Discuss.

  ```bash
  npx skills add https://github.com/fmontes/dotfiles/tree/main/ai --skill check-review
  ```

## License

MIT
