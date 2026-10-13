---
name: init-agents
description: Use when the user asks to initialize, create, draft, or update AGENTS.md instructions for a repository, including repo-specific agent rules, coding standards, validation commands, subagent workflow, language policy, and commit guidance.
---

# Initialize AGENTS.md

## Overview

Create or update `AGENTS.md` with repository-specific operating instructions for AI coding agents. The result must reflect the detected languages, tools, commands, and patterns in the current repository.

## Workflow

1. Inspect the repository before writing:
   - Read existing `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, README files, package manifests, build files, lint configs, formatter configs, test configs, CI workflows, and representative source files.
   - Identify primary languages, frameworks, package managers, linters, formatters, type checkers, test runners, and existing code patterns.
   - Preserve useful existing guidance unless it conflicts with the user's request.

2. Write `AGENTS.md` in English.
   - Repository code, comments, docs, agent notes, plans, and subagent communication must be English, except intentional i18n/user-facing product copy.
   - User-facing chat messages should use the language used by the user.

3. Include concrete commands, not generic advice.
   - Prefer commands already defined in the repository, such as `npm run lint`, `pnpm test`, `ruff check .`, `cargo clippy`, or CI workflow commands.
   - If the repository lacks a needed command, name the recommended tool and mark it as a recommendation instead of pretending it already exists.
   - State that relevant lint, format, static analysis, dead-code cleanup, code-smell cleanup, and test commands must run after every code edit and before every commit.

4. Keep the guidance practical and compact.
   - Emphasize modern language features and current best practices.
   - Require following existing repository patterns before introducing new abstractions.
   - Require simple, high-cohesion, low-coupling designs with strong readability, maintainability, and consistency.
   - Warn against over-engineering, speculative abstractions, anti-patterns, dead code, and code smells.

## Required AGENTS.md Sections

The generated `AGENTS.md` must include these topics:

- Repository purpose and detected stack.
- Engineering standards:
  - Follow current best practices for each detected language and framework.
  - Use the latest stable, modern language features available in the project.
  - Avoid known anti-patterns for the detected stack.
  - Prefer repository-local patterns, naming, architecture, and helper APIs.
- Quality workflow:
  - Run the repo-specific linter, formatter, static analysis, dead-code checks, code-smell cleanup, and test commands after every code edit and before every commit.
  - Include concrete command examples for the detected language and tooling.
- Testing expectations:
  - Require meaningful tests for new behavior and bug fixes.
  - Cover happy paths, edge cases, and error paths.
  - Prefer existing test frameworks and test style.
- Subagent workflow:
  - Use subagents aggressively for separable work, including investigation, repository exploration, implementation, validation, and review.
  - Split independent tasks whenever possible to save the main agent's context window.
  - Use the same model and comparable effort level as the main agent unless the user explicitly says otherwise.
  - Require subagent prompts, notes, and reports to be English.
- Language policy:
  - Code, comments, documentation, agent notes, and subagent communication must be English.
  - i18n strings and user-facing product copy may use the target product language.
  - Chat replies to the user should use the user's language.
- Engineering taste:
  - Keep solutions simple and appropriately scoped.
  - Prefer high cohesion, low coupling, readability, maintainability, consistency, and clear boundaries.
  - Avoid over-design and unrelated refactors.
- Commits:
  - Use Conventional Commits, such as `feat: add search filters`, `fix: handle empty config`, or `docs: initialize agent guidance`.

## Command Examples

Use these examples only when they match the detected stack. Prefer repository-defined scripts over generic commands.

| Stack | Common commands to include or adapt |
| --- | --- |
| JavaScript/TypeScript | `npm run lint`, `npm run format`, `npm run typecheck`, `npm test`, `npx knip`, `npx eslint .`, `npx prettier --write .` |
| pnpm JavaScript/TypeScript | `pnpm lint`, `pnpm format`, `pnpm typecheck`, `pnpm test`, `pnpm exec knip` |
| Python | `ruff check .`, `ruff check . --fix`, `ruff format .`, `pytest`, `mypy .`, `pyright` |
| Go | `gofmt -w .`, `go test ./...`, `go vet ./...`, `golangci-lint run` |
| Rust | `cargo fmt`, `cargo clippy --all-targets --all-features -- -D warnings`, `cargo test` |
| Java/Kotlin | `./gradlew test`, `./gradlew check`, `./gradlew spotlessApply`, `./mvnw test`, `./mvnw verify` |
| Ruby | `bundle exec rubocop -A`, `bundle exec rspec`, `bundle exec rake test` |
| C#/.NET | `dotnet format`, `dotnet test`, `dotnet build -warnaserror` |

If a repository uses different tools, replace these examples with the actual commands from manifests, config files, Makefiles, justfiles, taskfiles, or CI workflows.

## AGENTS.md Skeleton

Use this structure unless the repository already has a stronger convention:

```markdown
# AGENTS.md

## Repository Overview
[Summarize the project purpose and detected stack.]

## Engineering Standards
- Follow modern [language/framework] best practices and avoid [stack-specific anti-patterns].
- Match existing repository patterns before introducing new abstractions.
- Keep code high-cohesion, low-coupling, readable, maintainable, and consistent.
- Avoid over-engineering, dead code, speculative abstractions, and unrelated refactors.

## Language Policy
- Code, comments, documentation, agent notes, plans, and subagent communication must be English.
- i18n strings and user-facing product copy may use the target product language.
- Reply to users in the language they use.

## Subagent Workflow
- Use subagents for separable investigation, exploration, implementation, validation, and review tasks.
- Split independent work to preserve the main agent's context window.
- Use the same model and comparable effort level as the main agent unless the user says otherwise.
- Give subagents English prompts and require English reports.

## Quality Commands
Run the relevant commands after every code edit and before every commit:
- Lint: `[repo-specific command]`
- Format: `[repo-specific command]`
- Static analysis/type check: `[repo-specific command]`
- Dead-code/code-smell cleanup: `[repo-specific command or review step]`
- Tests: `[repo-specific command]`

## Testing Expectations
- Add or update tests for new behavior and bug fixes.
- Cover happy paths, edge cases, and error paths.
- Follow the repository's existing test style and fixtures.

## Commits
- Use Conventional Commits.
- Examples: `feat: add import flow`, `fix: handle missing config`, `docs: initialize agent guidance`.
```

## Final Checks

Before finishing:

- Confirm `AGENTS.md` is written in English.
- Confirm every required section is present.
- Confirm command examples match the detected stack and do not claim missing scripts exist.
- If `AGENTS.md` already existed, confirm useful prior guidance was preserved or intentionally reconciled.
