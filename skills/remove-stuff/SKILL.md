---
name: remove-stuff
description: Use when the user asks to remove, delete, drop, strip, eliminate, or get rid of a feature, field, API, UI, config option, behavior, copy, document section, dependency, or other repository content.
---

# Remove Stuff

## Overview

Remove the requested thing as if it never existed. Do not preserve historical naming, compatibility adapters, transitional wrappers, or documentation about the removal unless the user explicitly asks for them.

## Core Rule

When the user asks to remove something, erase its presence from the repository rather than adding evidence that it is absent.

- Do not add tests whose only assertion is that the removed thing no longer exists.
- Do not add documentation saying the removed thing does not exist.
- Do not keep compatibility aliases, old names, adapters, fallback branches, or deprecated interfaces unless explicitly requested.
- Do not leave comments explaining that the removed thing used to exist.
- Do update documentation, examples, schemas, fixtures, and generated artifacts so they describe the current system accurately.

## Workflow

1. Identify all names and traces.
   - List exact names, aliases, labels, routes, fields, flags, environment variables, copy, translations, tests, fixtures, docs, generated files, and dependencies related to the requested removal.
   - Include alternate spellings, casing variants, plural forms, CLI names, API names, database names, and UI labels.

2. Search before editing.
   - Use `rg` for each likely term and variant.
   - Search code, tests, fixtures, docs, migrations, schemas, generated assets, config, CI, and dependency manifests.
   - Prefer structured tools for structured files when available, but still use text search to catch references.

3. Remove the full implementation surface.
   - Delete source code, public exports, imports, routes, UI controls, handlers, feature flags, configuration, schema fields, fixture data, tests, documentation, examples, and dependency entries that exist only for the removed item.
   - Remove wrappers, adapters, compatibility layers, deprecated aliases, conditional branches, and migration helpers that no longer serve a real purpose.
   - Delete or simplify call paths that became unnecessary after the removal.

4. Clean the surrounding code.
   - Re-read every modified file after the first pass.
   - Remove dead code, empty abstractions, unused parameters, unused imports, unreachable branches, redundant wrappers, meaningless defaults, and stale tests.
   - Simplify interfaces and data flow after the removed item is gone.
   - Keep the resulting code cohesive, direct, and consistent with repository patterns.

5. Update current documentation.
   - Remove obsolete references from docs, README files, generated docs, API examples, screenshots, fixtures, and changelog drafts.
   - Keep documentation focused on the current behavior.
   - Do not add statements such as "Feature X was removed" unless the user asks for release notes, migration notes, or historical documentation.

6. Verify the absence.
   - Run `rg` over the repository for every identified term and variant.
   - Investigate every remaining hit. A remaining hit is acceptable only when it is unrelated, intentionally historical by user request, or part of external/vendor content that should not be edited.
   - Report any intentional remaining hits explicitly.

7. Validate the edited code.
   - Run the repository's normal formatter, linter, type checker, static analysis, and test commands when available.
   - If the repository has no such commands, perform the strongest available local validation and state the gap.

## What To Remove

Check these categories during removal:

- Source files, exports, imports, type definitions, constants, helpers, selectors, reducers, stores, models, migrations, serializers, validators, middleware, jobs, and command handlers.
- UI labels, controls, routes, screenshots, mock data, stories, snapshots, translations, and accessibility labels.
- API fields, GraphQL schema members, OpenAPI entries, protobuf fields, database columns, config keys, environment variables, CLI flags, and feature flags.
- Tests, fixtures, mocks, factories, snapshots, sample payloads, generated docs, README sections, tutorials, examples, and comments.
- Dependencies, build entries, CI references, release-note drafts, monitoring names, metrics, dashboards, and alerts that exist only for the removed item.

## Anti-Patterns

Avoid these behaviors:

- Keeping `OldThing` as an alias to `NewThing` after the user asked to remove `OldThing`.
- Keeping an adapter that only maps removed fields to replacement fields.
- Leaving a `removedFeatureEnabled` branch that can never be true.
- Adding tests like `expect(config.removedField).toBeUndefined()` when no behavior remains.
- Adding docs like "The removed field is no longer supported."
- Leaving TODO comments, dead fixtures, empty wrapper modules, or unused compatibility helpers.

## Final Response Checklist

Before finishing, confirm:

- The requested item was removed from implementation, tests, fixtures, docs, configuration, and generated artifacts where applicable.
- Repository-wide searches were run for relevant terms and remaining hits were explained.
- Modified code was re-read and simplified to remove wrappers, branches, adapters, dead code, and unnecessary complexity left behind by the deletion.
- Documentation now describes the current system without historical removal disclaimers unless requested.
- Validation commands were run, or unavailable validation was clearly stated.
