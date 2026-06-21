# Install moycat/skills

Use this file as the single install entrypoint for any supported harness. Do not look for a harness-specific installer.

## One command

Pick the harness you are currently running in, then run:

```bash
SKILLS_HARNESS=<codex|claude|opencode> bash -c "$(curl -fsSL https://raw.githubusercontent.com/moycat/skills/refs/heads/master/install.sh)"
```

Use exactly one harness unless the user explicitly asks to install everywhere. This avoids duplicate skill discovery in tools that scan multiple locations.

## Targets

The universal installer clones or updates this repository at `~/.local/share/moycat-skills`, then links each `skills/*` folder into the current harness target:

| Harness | Target directory |
| --- | --- |
| Codex | `~/.agents/skills` |
| Claude Code | `~/.claude/skills` |
| OpenCode | `~/.config/opencode/skills` |

## If curl is unavailable

```bash
git clone https://github.com/moycat/skills.git ~/.local/share/moycat-skills
SKILLS_HARNESS=<codex|claude|opencode> bash ~/.local/share/moycat-skills/install.sh
```

If the clone already exists, rerun the one-command installer instead; it updates with `git pull --ff-only`.

## Verify

Run the command for the harness:

```bash
ls -la ~/.agents/skills      # Codex
ls -la ~/.claude/skills      # Claude Code
ls -la ~/.config/opencode/skills  # OpenCode
```

Each installed skill should be a symlink to `~/.local/share/moycat-skills/skills/<skill-name>`.
