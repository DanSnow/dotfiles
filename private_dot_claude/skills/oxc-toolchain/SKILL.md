---
name: oxc-toolchain
description: Set up oxlint (linting) + oxfmt (formatting) for JavaScript/TypeScript projects. Use when user asks to "migrate to oxlint", "switch to oxc", "use oxfmt", "set up oxlint", or wants to adopt the oxc toolchain for linting and formatting — whether migrating from ESLint, Biome, Prettier, or starting fresh.
---

# oxc Toolchain Setup

Set up oxlint (linting) + oxfmt (formatting). oxfmt fully replaces Prettier — no Prettier fallback needed.

## Supported File Types

oxfmt formats: JavaScript, JSX, TypeScript, TSX, JSON, JSONC, JSON5, YAML, TOML, HTML, Angular, Vue, CSS, SCSS, Less, Markdown, MDX, GraphQL, Ember, Handlebars

Built-in features that replace Prettier plugins: import sorting, Tailwind CSS class sorting, package.json field sorting, embedded formatting.

## Setup Steps

1. Install packages: `oxlint` and `oxfmt`
2. Remove Prettier and its plugins if present (`prettier`, `prettier-plugin-*`, `eslint-plugin-prettier`, `.prettierrc.*`, `.prettierignore`)
3. Create `.oxlintrc.json`
4. Add scripts to `package.json`
5. Update VSCode settings to use `oxc.oxc-vscode`
6. Run format and lint to verify

When migrating from an existing linter (ESLint, Biome), remove the old packages and config files. oxlint uses ESLint-compatible rule names (kebab-case), so existing rule knowledge transfers directly.

## .oxlintrc.json

```json
{
  "$schema": "./node_modules/oxlint/configuration_schema.json",
  "plugins": ["typescript", "import", "unicorn", "oxc", "jsdoc", "promise", "node"],
  "categories": {
    "correctness": "error",
    "suspicious": "warn",
    "perf": "warn"
  },
  "ignorePatterns": ["dist/", "node_modules/"],
  "rules": {}
}
```

### Built-in plugins

`eslint`, `react`, `unicorn`, `typescript`, `oxc`, `import`, `jsdoc`, `jest`, `vitest`, `jsx-a11y`, `nextjs`, `react-perf`, `promise`, `node`, `vue`

Enable plugins relevant to the project. For React projects add `react`, `react-perf`. For Next.js add `nextjs`. For test frameworks add `vitest` or `jest`.

### ESLint plugins via jsPlugins (experimental)

oxlint can run ESLint plugins natively via the `jsPlugins` field. Use this for plugins without a built-in equivalent (e.g. storybook):

```json
{
  "jsPlugins": [{ "name": "storybook", "specifier": "eslint-plugin-storybook" }],
  "rules": {
    "storybook/no-redundant-story-name": "warn"
  }
}
```

The ESLint plugin package must be installed as a devDependency. Rules are referenced as `<name>/<rule-name>`.

### Categories

Control rule severity by category instead of individually:

- `correctness` — code that is outright wrong or useless (recommended: `"error"`)
- `suspicious` — code that is most likely wrong (recommended: `"warn"`)
- `pedantic` — strict lints with occasional false positives
- `perf` — performance improvements (recommended: `"warn"`)
- `style` — idiomatic code style
- `restriction` — prevent use of certain language/library features
- `nursery` — new rules under development

## Package.json Scripts

```json
{
  "lint": "oxlint",
  "format": "oxfmt --write .",
  "format:check": "oxfmt --check ."
}
```

## VSCode Settings

```json
{
  "editor.defaultFormatter": "oxc.oxc-vscode",
  "prettier.enable": false,
  "editor.codeActionsOnSave": {
    "source.fixAll.oxc": "always"
  }
}
```

Recommend `oxc.oxc-vscode` in `.vscode/extensions.json`.

## CLI Reference

```bash
# Lint
oxlint              # check
oxlint --fix         # auto-fix

# Format
oxfmt --write .      # fix
oxfmt --check .      # check only
```
