---
name: design-extractor
description: >
  Audits a frontend codebase for design token and component extraction opportunities,
  then produces a structured proposal before touching any code. Use this skill whenever the
  user says things like "extract my design tokens", "set up a token system", "clean up my
  CSS variables", "create shared components", "reduce duplication in my UI", "set up a design
  system", "my components have too much copy-paste", "add a Button component", "standardize
  my buttons", "add shadcn", "use cva for variants", or asks to refactor repeated UI patterns
  (nav items, form fields, modals, page headers, buttons, inputs). Works with any frontend
  stack — React, Vue, Svelte, plain HTML/CSS, Tailwind, CSS Modules, vanilla CSS. Trigger
  even if the user only mentions one aspect (just tokens OR just components OR just buttons)
  — the skill handles all and will focus on whichever is relevant.
---

# Design Token & Component Extractor

You are helping the user audit their codebase for design system extraction opportunities and
produce a clear proposal they can review before any code is written.

## What this skill does

1. **Discover** — identify the project's stack, styling approach, and component format
2. **Audit** — scan for inline style values, CSS variables, and repeated UI patterns
3. **Propose** — write a structured extraction plan covering tokens and components
4. **Implement** — after user approval, write the actual files

This is a plan-first workflow. Never write implementation code until the user has reviewed
and approved the proposal.

---

## Phase 0: Discover the stack

Before auditing anything, spend a moment understanding what you're working with. Look for:

- **Package manager**: `package.json`, `pnpm-lock.yaml`, `yarn.lock`, `Gemfile`, etc.
- **Styling approach**: Tailwind config (`tailwind.config.*`, `@import "tailwindcss"`), CSS
  Modules (`*.module.css`), styled-components/emotion imports, plain CSS, SCSS, etc.
- **Component format**: `.tsx`/`.jsx` (React), `.vue` (Vue), `.svelte`, `.html` templates, etc.
- **Existing token system**: CSS custom properties in `:root`, SCSS variables (`$brand-color`),
  JS theme objects, design token files (Style Dictionary, etc.)
- **Type checker**: `tsconfig.json` → TypeScript; otherwise JavaScript

If the user told you the stack already, confirm rather than re-discover. If anything is
ambiguous, make a reasonable assumption and note it in the proposal.

---

## Phase 1: Audit

### Token candidates — hard-coded values that appear in multiple places

Look for values that are repeated verbatim across files rather than referenced from a single
source. The exact patterns depend on the styling approach:

- **Tailwind projects**: arbitrary values like `text-[#3a1c71]`, `bg-[rgba(0,0,0,0.4)]`,
  `border-[var(--brand)]` used directly in class strings
- **CSS/SCSS**: hex/rgba values that appear in multiple rules without a variable
- **CSS custom properties already exist but lack semantic roles**: e.g., `--brand-blue`
  used as both a button color and a link color and a border — a single palette token
  doing the work of three semantic concepts
- **JS theme objects**: color strings repeated across styled-component definitions

Also check for **missing semantic layer** — palette tokens exist but there's no role-based
alias like `--color-primary`, `--color-on-surface`, `--color-border`.

### Component candidates — UI patterns repeated 3+ times with the same structure

What counts as duplication depends on the framework:

- **React/Vue/Svelte**: identical JSX/template blocks across multiple files
- **HTML templates**: repeated Jinja/ERB/Blade partials that aren't extracted
- **Any framework**: the same logical pattern (header with title + action, form field with
  label + input + error, modal overlay) copy-pasted with minor variations

Two distinct kinds of components emerge from this audit — treat them differently:

**Structural components** — JSX/template blocks copy-pasted with minor prop variations:
- Navigation link blocks (icon + label + active state)
- Page/section header (kicker text + title + action button)
- Form field wrapper (label + control + error message)
- Modal/dialog overlay (backdrop + centered panel + close button)
- Empty state block
- Card/list item rows

**Styled primitive components** — native HTML elements (`<button>`, `<input>`, `<select>`,
`<badge>`) whose `className` strings are repeated across files with variant-like differences
(e.g., a primary button vs an outline button vs a ghost icon button). These aren't structural
copy-paste — the JSX is often one line — but the inline Tailwind/CSS class string is
duplicated or slightly diverges across call sites. The right extraction is a primitive
component with a `variant` + `size` prop system, not a structural wrapper.

Signs you're looking at a styled primitive:
- The same native element (`<button>`, `<input>`) appears in 5+ places with long, mostly-identical `className` strings
- There are 2–4 visual variants (primary/outline/ghost/destructive) defined separately in different files
- Conditional class logic like `${isPrimary ? 'bg-primary ...' : 'border ...'}` repeated inline
- A local `buttonCls`, `inputCls`, etc. constant defined per-file

**How to scan:**
- Grep for repeated literal values: hex colors, rgba strings, specific class combinations
- Grep for structural markers: `fixed inset-0`, `position: fixed`, repeated label+input patterns
- Read the main layout/shell component and a few route/page files to spot copy-paste blocks
- Run a duplication checker if available (e.g., `jscpd`, `fdupes`) — but don't require it

---

## Phase 2: Proposal

Write the proposal as a structured document in the conversation. Do NOT write any files.

### Proposal structure

```
## Design Token & Component Extraction Proposal

### Stack
[One-line summary of what you found: framework, styling, TypeScript/JS, existing token setup]

### Token Layer

**Current state:** [what exists, what's missing]

**Proposed tokens:**
| Token name | Value | Role |
|------------|-------|------|
| --color-primary | #328f97 | Primary action color |
| --color-on-primary | #ffffff | Text/icon on primary bg |
| ... | ... | ... |

**Contrast check:** [for button foreground/background pairs, state the WCAG AA ratio and pass/fail]

**Dark mode / theming:** [note if dark mode overrides are needed or if theming is out of scope]

### Styled Primitive Components

[Include this section when native elements have per-file className duplication with visual variants]

**Button** → `src/components/ui/Button.tsx`
Variants: `default` (primary CTA), `outline` (secondary), `ghost` (icon-only), `destructive`
Sizes: `default`, `sm`, `lg`, `icon`
Implementation: `cva` + headless primitive (`@base-ui/react/button`, `@radix-ui/react-slot`, or plain `<button>`)
Replaces: inline `className` strings in [list files]
Call sites: N occurrences

[Repeat for Input, Badge, etc. if applicable]

### Structural Component Extraction

**ComponentName** → `path/to/ComponentName.ext`
Props: `prop1: type`, `prop2?: type`
Replaces: list of files that contain the duplicated pattern
Instances reduced: N → 1

...

### Migration plan (ordered)
1. ...
2. ...

### What stays the same
- [visual behavior, any explicit non-goals]
```

Be specific — not "add a primary color variable" but "`--color-primary: #328f97`". Not "extract
a modal component" but "`Modal.tsx` accepting `title`, `onClose`, `children`". The proposal
should be precise enough that someone else could implement it from the document alone.

For contrast ratios: state the hex pair and the ratio. WCAG AA requires 4.5:1 for normal text,
3:1 for large text (18pt+ or 14pt bold). If you can't calculate exactly, flag it for the user
to verify.

---

## Phase 3: Implementation (after approval)

Once the user approves (or approves with modifications), implement in this order:

**Tokens first** — adding the semantic layer is cheap and immediately benefits all the
component work that follows:

1. Add semantic aliases to the base/light theme (`:root`, `$variables`, theme object — whatever
   the project uses)
2. Mirror in dark mode / alternate themes if applicable
3. If Tailwind v4: register via `@theme { --color-primary: var(--color-primary); }`
   If Tailwind v3: add to `extend.colors` in `tailwind.config.js`
   If CSS Modules/plain CSS: variables are usable immediately
4. Update primary button classes to use semantic tokens

**Styled primitives second** — these unlock consistent variant usage across all the
structural components you're about to write:
- Check for `cva` (`class-variance-authority`) in `package.json`; if absent, ask before installing
- Check for an existing headless UI primitive to render as (e.g., `@base-ui/react/button`,
  `@radix-ui/react-slot`, `@headlessui/react`) — prefer reusing what's already installed
  over adding a raw `<button>` or a new dependency
- Define `buttonVariants` with `cva`, using the project's actual design tokens as values
  (not generic Tailwind utilities — look at what the inline classes actually use)
- Export both the component and `buttonVariants` so call sites that can't use the component
  (e.g., `BaseDialog.Close`) can still apply the class string via `buttonVariants({ ... })`
- Migrate all call sites; run the type-checker after

**Structural components by duplication count** — most-repeated first:
- For each component: read all instances → extract minimal shared interface → write the
  component → update all call sites → run type-checker

**After all changes:**
- Run type-checker (`tsc --noEmit`, `vue-tsc`, etc.) and fix any errors
- Report final duplication % if a checker is available
- Ask before installing any new dependencies (headless UI libraries, etc.)

---

## Notes on common stacks

**Tailwind v4 (CSS-first config):**
Register semantic tokens as Tailwind color utilities:
```css
@theme {
  --color-primary: var(--color-primary);   /* enables bg-primary, text-primary, etc. */
  --color-border: var(--color-border);
}
```

**Tailwind v3 (JS config):**
```js
// tailwind.config.js
theme: { extend: { colors: { primary: 'var(--color-primary)' } } }
```

**SCSS:**
```scss
$color-primary: #328f97;
// then use @forward / @use to share across files
```

**CSS custom properties only:**
Works in any framework — define in `:root`, override in `[data-theme="dark"]` or a theme class.

**WCAG AA quick reference:**
- 4.5:1 minimum for normal text (body, buttons, labels)
- 3:1 minimum for large text (18px+) and UI components (borders, icons)
- Always check both default and hover/focus states
