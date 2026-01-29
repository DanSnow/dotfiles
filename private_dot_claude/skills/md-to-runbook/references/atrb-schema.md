# ATRB Schema Reference

Atuin Runbook (.atrb) files are YAML documents with a structured node-based format.

## Document Structure

```yaml
id: <uuid>
name: <string>
version: 1
forkedFrom: null
content:
  - <node>
  - <node>
  ...
```

## Node Types

### heading
```yaml
type: heading
props:
  level: 1-6
  backgroundColor: default
  textColor: default
  textAlignment: left
  isToggleable: false
content: [<text-span>...]
children: []
```

### paragraph
```yaml
type: paragraph
props:
  backgroundColor: default
  textColor: default
  textAlignment: left
content: [<text-span>...]
children: []
```

### checkListItem
```yaml
type: checkListItem
props:
  checked: true|false
  backgroundColor: default
  textColor: default
  textAlignment: left
content: [<text-span>...]
children: []
```

### bulletListItem / numberedListItem
```yaml
type: bulletListItem  # or numberedListItem
props:
  backgroundColor: default
  textColor: default
  textAlignment: left
content: [<text-span>...]
children: []
```

### codeBlock (display only)
```yaml
type: codeBlock
props:
  language: bash|text|python|...
content:
  - type: text
    text: <code-string>
    styles: {}
children: []
```

### run (executable terminal)
```yaml
type: run
props:
  type: bash
  name: Terminal 1
  code: |
    <executable-code>
  pty: ''
  global: false
  outputVisible: true
  dependency: '{}'
  terminalRows: 20
children: []
```

### table
```yaml
type: table
props:
  textColor: default
content:
  type: tableContent
  columnWidths: [null, null, ...]
  headerRows: 1
  rows:
    - cells:
        - type: tableCell
          content: [<text-span>...]
          props:
            colspan: 1
            rowspan: 1
            backgroundColor: default
            textColor: default
            textAlignment: left
children: []
```

### quote
```yaml
type: quote
props:
  backgroundColor: default
  textColor: default
content: [<text-span>...]
children: []
```

## Text Spans

```yaml
- type: text
  text: "plain text"
  styles: {}

- type: text
  text: "bold text"
  styles:
    bold: true

- type: text
  text: "inline code"
  styles:
    code: true

- type: link
  href: https://example.com
  content:
    - type: text
      text: "link text"
      styles: {}
```

## Key Differences: codeBlock vs run

| codeBlock | run |
|-----------|-----|
| Display-only documentation | Interactive terminal |
| Shows example output | Executes commands |
| Any language | bash/sh only |
| Static content | Captures output |

**Heuristic**: Bash blocks with actual commands (pnpm, npm, ./scripts/, etc.) become `run` nodes. Example output or non-bash code stays as `codeBlock`.
