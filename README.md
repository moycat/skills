# moycat skills

A portable Agent Skills collection for Codex, Claude Code, OpenCode, and other tools that understand `SKILL.md`.

## One-sentence install

Tell your agent:

> Fetch https://raw.githubusercontent.com/moycat/skills/refs/heads/master/INSTALL.md and install this skill collection for your current harness.

That instruction points every harness at the same `INSTALL.md` and the same universal installer. The installer links each `skills/*` folder into the target directory for the current harness instead of maintaining separate harness-specific install scripts.

## Layout

```text
skills/
  <skill-name>/
    SKILL.md
    scripts/      # optional
    references/   # optional
    assets/       # optional
```

Skill folder names should match the `name` in `SKILL.md` and use lowercase letters, digits, and single hyphen separators.

## Development

```bash
npm run validate
```

`npm run validate` checks `skills/*/SKILL.md` frontmatter and naming rules.
