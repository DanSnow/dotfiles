---
name: md-to-runbook
description: Convert Markdown documentation to Atuin Runbook (.atrb) format with interactive terminals. Use when converting runbooks, migration docs, or step-by-step guides to executable runbook format. Triggers on "convert to runbook", "make runbook", "create .atrb", or when working with Atuin runbook files.
---

# Markdown to Runbook Conversion

Convert markdown documentation to Atuin Runbook (.atrb) YAML format with interactive terminal blocks.

## Quick Start

```bash
uv run ~/.claude/skills/md-to-runbook/scripts/md_to_atrb.py <input.md> [output.atrb]
```

## What Gets Converted

| Markdown | ATRB Node | Notes |
|----------|-----------|-------|
| `# Heading` | `heading` | Levels 1-6 supported |
| Paragraphs | `paragraph` | |
| `- [ ] item` | `checkListItem` | Unchecked checkbox |
| `- [x] item` | `checkListItem` | Checked checkbox |
| `- item` | `bulletListItem` | |
| `1. item` | `numberedListItem` | |
| ` ```bash ` (commands) | `run` | Interactive terminal |
| ` ```text ` (output) | `codeBlock` | Display only |
| Tables | `table` | Full cell formatting |
| `> quote` | `quote` | |
| `**bold**` | `styles: {bold: true}` | |
| `` `code` `` | `styles: {code: true}` | |

## Executable vs Display Code Blocks

Bash blocks with actual commands become interactive `run` nodes:
- Commands: `pnpm`, `npm`, `yarn`, `npx`
- Scripts: `./scripts/...`, `doppler run`
- Shell ops: `cat`, `cd`, `pwd`, `ls`, `for...done`
- Env vars: `CONVEX_URL=...`, `ENCRYPTION_KEY=...`

Example output or non-bash code stays as display-only `codeBlock`.

## Options

```bash
# Specify output path
uv run md_to_atrb.py input.md output.atrb

# Override runbook name (default: first heading or filename)
uv run md_to_atrb.py input.md --name "My Runbook"
```

## Schema Reference

See [references/atrb-schema.md](references/atrb-schema.md) for full ATRB node type documentation.
