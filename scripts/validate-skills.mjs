#!/usr/bin/env node
import { existsSync } from "node:fs";
import { readdir, readFile } from "node:fs/promises";
import path from "node:path";

const args = process.argv.slice(2);
const rootIndex = args.indexOf("--root");
const root =
  rootIndex === -1 ? process.cwd() : path.resolve(args[rootIndex + 1] ?? "");

const skillsDir = path.join(root, "skills");
const namePattern = /^[a-z0-9]+(-[a-z0-9]+)*$/;
const errors = [];
const seenNames = new Map();
let count = 0;

if (!existsSync(skillsDir)) {
  fail([`skills directory not found: ${skillsDir}`]);
}

const entries = await readdir(skillsDir, { withFileTypes: true });

for (const entry of entries) {
  if (!entry.isDirectory()) continue;

  const folder = entry.name;
  const skillFile = path.join(skillsDir, folder, "SKILL.md");
  const displayPath = path.join("skills", folder, "SKILL.md");

  if (!existsSync(skillFile)) {
    errors.push(`${displayPath}: missing SKILL.md`);
    continue;
  }

  count += 1;

  const content = await readFile(skillFile, "utf8");
  const frontmatter = parseFrontmatter(content, displayPath);
  if (!frontmatter) continue;

  const { raw, fields } = frontmatter;
  const name = fields.get("name");
  const description = fields.get("description");

  if (raw.length > 1024) {
    errors.push(`${displayPath}: frontmatter must be 1024 characters or less`);
  }

  if (!name) {
    errors.push(`${displayPath}: missing required name`);
  } else {
    if (!namePattern.test(name)) {
      errors.push(
        `${displayPath}: name "${name}" must match ${namePattern.toString()}`,
      );
    }
    if (name.length > 64) {
      errors.push(`${displayPath}: name "${name}" must be 64 characters or less`);
    }
    if (name !== folder) {
      errors.push(`${displayPath}: name "${name}" must match folder "${folder}"`);
    }
    if (seenNames.has(name)) {
      errors.push(
        `${displayPath}: duplicate skill name "${name}" also used by ${seenNames.get(name)}`,
      );
    } else {
      seenNames.set(name, displayPath);
    }
  }

  if (!description) {
    errors.push(`${displayPath}: missing required description`);
  } else if (description.length > 1024) {
    errors.push(`${displayPath}: description must be 1024 characters or less`);
  }
}

if (errors.length > 0) {
  fail(errors);
}

if (count === 0) {
  console.log(`No skills found in ${path.relative(root, skillsDir) || "skills"}. Scaffold is ready.`);
} else if (count === 1) {
  console.log("Validated 1 skill.");
} else {
  console.log(`Validated ${count} skills.`);
}

function parseFrontmatter(content, displayPath) {
  const lines = content.split(/\r?\n/);

  if (lines[0] !== "---") {
    errors.push(`${displayPath}: SKILL.md must start with YAML frontmatter`);
    return null;
  }

  const end = lines.indexOf("---", 1);
  if (end === -1) {
    errors.push(`${displayPath}: YAML frontmatter is not closed`);
    return null;
  }

  const raw = lines.slice(0, end + 1).join("\n");
  const fields = new Map();

  for (const line of lines.slice(1, end)) {
    if (!line.trim() || line.trim().startsWith("#")) continue;

    const match = /^([A-Za-z0-9_-]+):\s*(.*)$/.exec(line);
    if (!match) continue;

    fields.set(match[1], stripQuotes(match[2].trim()));
  }

  return { raw, fields };
}

function stripQuotes(value) {
  if (
    (value.startsWith('"') && value.endsWith('"')) ||
    (value.startsWith("'") && value.endsWith("'"))
  ) {
    return value.slice(1, -1);
  }

  return value;
}

function fail(messages) {
  for (const message of messages) {
    console.error(message);
  }
  process.exit(1);
}
