#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "mistune>=3.0.0",
# ]
# ///
"""
Convert Markdown files to Atuin Runbook (.atrb) YAML format.

Usage:
    uv run md_to_atrb.py <input.md> [output.atrb]

If output is not specified, writes to input filename with .atrb extension.
"""

import argparse
import re
import sys
import uuid
from pathlib import Path
from typing import Any

import mistune


def generate_id() -> str:
    """Generate a UUID for node identification."""
    return str(uuid.uuid4())


# Patterns for detecting executable commands (vs documentation)
EXECUTABLE_PATTERNS = [
    r'^#\s',  # Comments
    r'^\s*pnpm\s',
    r'^\s*npm\s',
    r'^\s*yarn\s',
    r'^\s*npx\s',
    r'^\s*\./scripts/',
    r'^\s*doppler\s',
    r'^\s*CONVEX_URL=',
    r'^\s*ENCRYPTION_KEY=',
    r'^\s*cat\s',
    r'^\s*cd\s',
    r'^\s*pwd',
    r'^\s*ls\s',
    r'^\s*for\s+\w+\s+in',
    r'^\s*done',
]


def is_executable_code(code: str, language: str) -> bool:
    """Determine if a code block should be executable (run node) vs display-only."""
    if language not in ('bash', 'sh', 'shell', ''):
        return False

    lines = code.strip().split('\n')
    for line in lines:
        line = line.strip()
        if not line:
            continue
        for pattern in EXECUTABLE_PATTERNS:
            if re.match(pattern, line):
                return True
    return False


def extract_text(children: list) -> str:
    """Recursively extract plain text from AST children."""
    result = []
    for child in children:
        if child['type'] == 'text':
            result.append(child['raw'])
        elif 'children' in child:
            result.append(extract_text(child['children']))
        elif 'raw' in child:
            result.append(child['raw'])
    return ''.join(result)


def parse_inline_children(children: list) -> list[dict]:
    """Convert mistune inline AST to ATRB content spans."""
    spans = []

    for child in children:
        child_type = child['type']

        if child_type == 'text':
            spans.append({'type': 'text', 'text': child['raw'], 'styles': {}})

        elif child_type == 'codespan':
            spans.append({'type': 'text', 'text': child['raw'], 'styles': {'code': True}})

        elif child_type == 'strong':
            # Bold text - recursively process children
            inner_text = extract_text(child['children'])
            spans.append({'type': 'text', 'text': inner_text, 'styles': {'bold': True}})

        elif child_type == 'emphasis':
            inner_text = extract_text(child['children'])
            spans.append({'type': 'text', 'text': inner_text, 'styles': {'italic': True}})

        elif child_type == 'link':
            link_text = extract_text(child['children'])
            spans.append({
                'type': 'link',
                'href': child.get('attrs', {}).get('url', ''),
                'content': [{'type': 'text', 'text': link_text, 'styles': {}}]
            })

        elif child_type == 'softbreak':
            spans.append({'type': 'text', 'text': ' ', 'styles': {}})

        elif child_type == 'linebreak':
            spans.append({'type': 'text', 'text': '\n', 'styles': {}})

        elif 'children' in child:
            # Recursively process nested children
            spans.extend(parse_inline_children(child['children']))

        elif 'raw' in child:
            spans.append({'type': 'text', 'text': child['raw'], 'styles': {}})

    return spans


def parse_table(token: dict) -> dict | None:
    """Convert mistune table AST to ATRB table structure."""
    head = token.get('children', [])
    if not head:
        return None

    # Find header and body
    header_rows = []
    body_rows = []

    for child in head:
        if child['type'] == 'table_head':
            for row in child.get('children', []):
                header_rows.append(row)
        elif child['type'] == 'table_body':
            for row in child.get('children', []):
                body_rows.append(row)

    all_rows = header_rows + body_rows
    if not all_rows:
        return None

    num_cols = 0
    rows = []

    for i, row_token in enumerate(all_rows):
        cells = row_token.get('children', [])
        if i == 0:
            num_cols = len(cells)

        row = {'cells': []}
        for cell_token in cells:
            cell_children = cell_token.get('children', [])
            cell_content = parse_inline_children(cell_children) if cell_children else []

            cell = {
                'type': 'tableCell',
                'content': cell_content,
                'props': {
                    'colspan': 1,
                    'rowspan': 1,
                    'backgroundColor': 'default',
                    'textColor': 'default',
                    'textAlignment': 'left'
                }
            }
            row['cells'].append(cell)

        rows.append(row)

    return {
        'type': 'tableContent',
        'columnWidths': [None] * num_cols,
        'headerRows': len(header_rows),
        'rows': rows
    }


class MarkdownToATRB:
    """Convert markdown to ATRB format using mistune AST."""

    def __init__(self, name: str = "Untitled"):
        self.name = name
        self.nodes: list[dict] = []
        self.terminal_counter = 0

    def parse(self, markdown: str) -> dict:
        """Parse markdown content and return ATRB document."""
        md = mistune.create_markdown(renderer=None)
        ast = md(markdown)

        for token in ast:
            self.process_token(token)

        return self.build_document()

    def process_token(self, token: dict):
        """Process a single AST token."""
        token_type = token['type']

        if token_type == 'heading':
            level = token.get('attrs', {}).get('level', 1)
            children = token.get('children', [])
            content = parse_inline_children(children)
            self.add_heading(content, level)

        elif token_type == 'paragraph':
            children = token.get('children', [])
            content = parse_inline_children(children)
            self.add_paragraph(content)

        elif token_type == 'list':
            ordered = token.get('attrs', {}).get('ordered', False)
            for item in token.get('children', []):
                self.process_list_item(item, ordered)

        elif token_type == 'block_code':
            raw = token.get('raw', '')
            info = token.get('attrs', {}).get('info', '')
            language = info.split()[0] if info else ''

            if is_executable_code(raw, language):
                self.add_run_block(raw)
            else:
                self.add_code_block(raw, language)

        elif token_type == 'table':
            table_content = parse_table(token)
            if table_content:
                self.add_table(table_content)

        elif token_type == 'block_quote':
            children = token.get('children', [])
            # Extract text from nested paragraphs
            text_parts = []
            for child in children:
                if child['type'] == 'paragraph':
                    text_parts.append(extract_text(child.get('children', [])))
            self.add_quote(' '.join(text_parts))

        elif token_type == 'thematic_break':
            # Horizontal rule - add empty paragraph as separator
            self.add_paragraph([])

    def process_list_item(self, item: dict, ordered: bool):
        """Process a list item token."""
        children = item.get('children', [])

        # Check for checkbox pattern
        checkbox_checked = None
        content = []

        for child in children:
            if child['type'] == 'paragraph':
                inline_children = child.get('children', [])
                if inline_children:
                    first_child = inline_children[0]
                    if first_child['type'] == 'text':
                        text = first_child.get('raw', '')
                        # Check for checkbox
                        checkbox_match = re.match(r'^\[([ xX])\]\s*', text)
                        if checkbox_match:
                            checkbox_checked = checkbox_match.group(1).lower() == 'x'
                            # Remove checkbox from text
                            first_child['raw'] = text[checkbox_match.end():]

                content = parse_inline_children(inline_children)

        if checkbox_checked is not None:
            self.add_checklist_item(content, checkbox_checked)
        elif ordered:
            self.add_numbered_item(content)
        else:
            self.add_bullet_item(content)

    def add_heading(self, content: list, level: int):
        """Add a heading node."""
        node = {
            'id': generate_id(),
            'type': 'heading',
            'props': {
                'backgroundColor': 'default',
                'textColor': 'default',
                'textAlignment': 'left',
                'level': level,
                'isToggleable': False
            },
            'content': content,
            'children': []
        }
        self.nodes.append(node)

    def add_paragraph(self, content: list):
        """Add a paragraph node."""
        node = {
            'id': generate_id(),
            'type': 'paragraph',
            'props': {
                'backgroundColor': 'default',
                'textColor': 'default',
                'textAlignment': 'left'
            },
            'content': content,
            'children': []
        }
        self.nodes.append(node)

    def add_checklist_item(self, content: list, checked: bool):
        """Add a checklist item node."""
        node = {
            'id': generate_id(),
            'type': 'checkListItem',
            'props': {
                'backgroundColor': 'default',
                'textColor': 'default',
                'textAlignment': 'left',
                'checked': checked
            },
            'content': content,
            'children': []
        }
        self.nodes.append(node)

    def add_bullet_item(self, content: list):
        """Add a bullet list item node."""
        node = {
            'id': generate_id(),
            'type': 'bulletListItem',
            'props': {
                'backgroundColor': 'default',
                'textColor': 'default',
                'textAlignment': 'left'
            },
            'content': content,
            'children': []
        }
        self.nodes.append(node)

    def add_numbered_item(self, content: list):
        """Add a numbered list item node."""
        node = {
            'id': generate_id(),
            'type': 'numberedListItem',
            'props': {
                'backgroundColor': 'default',
                'textColor': 'default',
                'textAlignment': 'left'
            },
            'content': content,
            'children': []
        }
        self.nodes.append(node)

    def add_code_block(self, code: str, language: str = ''):
        """Add a code block node (display only)."""
        node = {
            'id': generate_id(),
            'type': 'codeBlock',
            'props': {
                'language': language or 'text'
            },
            'content': [{'type': 'text', 'text': code.rstrip('\n'), 'styles': {}}],
            'children': []
        }
        self.nodes.append(node)

    def add_run_block(self, code: str):
        """Add an executable run block node."""
        self.terminal_counter += 1
        node = {
            'id': generate_id(),
            'type': 'run',
            'props': {
                'type': 'bash',
                'name': f'Terminal {self.terminal_counter}',
                'code': code.rstrip('\n') + '\n',
                'pty': '',
                'global': False,
                'outputVisible': True,
                'dependency': '{}',
                'terminalRows': 20
            },
            'children': []
        }
        self.nodes.append(node)

    def add_table(self, content: dict):
        """Add a table node."""
        node = {
            'id': generate_id(),
            'type': 'table',
            'props': {
                'textColor': 'default'
            },
            'content': content,
            'children': []
        }
        self.nodes.append(node)

    def add_quote(self, text: str):
        """Add a blockquote node."""
        node = {
            'id': generate_id(),
            'type': 'quote',
            'props': {
                'backgroundColor': 'default',
                'textColor': 'default'
            },
            'content': [{'type': 'text', 'text': text, 'styles': {}}] if text else [],
            'children': []
        }
        self.nodes.append(node)

    def build_document(self) -> dict:
        """Build the final ATRB document."""
        return {
            'id': str(uuid.uuid4()),
            'name': self.name,
            'version': 1,
            'forkedFrom': None,
            'content': self.nodes
        }


def format_yaml_document(doc: dict) -> str:
    """Format the full document as YAML."""
    lines = []
    lines.append(f"id: {doc['id']}")
    lines.append(f"name: {doc['name']}")
    lines.append(f"version: {doc['version']}")
    lines.append(f"forkedFrom: null")
    lines.append("content:")

    for node in doc['content']:
        lines.append(format_node(node, 0))

    return '\n'.join(lines)


def format_node(node: dict, indent: int) -> str:
    """Format a single node as YAML."""
    prefix = '  ' * indent
    lines = []

    lines.append(f"{prefix}- id: {node['id']}")
    lines.append(f"{prefix}  type: {node['type']}")

    # Format props
    lines.append(f"{prefix}  props:")
    for k, v in node['props'].items():
        v_str = format_value(v, indent + 2)
        lines.append(f"{prefix}    {k}: {v_str}")

    # Format content
    content = node.get('content', [])
    if isinstance(content, dict):
        # Table content
        lines.append(f"{prefix}  content:")
        lines.append(f"{prefix}    type: {content['type']}")
        lines.append(f"{prefix}    columnWidths:")
        for w in content.get('columnWidths', []):
            lines.append(f"{prefix}    - {format_value(w, 0)}")
        lines.append(f"{prefix}    headerRows: {content.get('headerRows', 1)}")
        lines.append(f"{prefix}    rows:")
        for row in content.get('rows', []):
            lines.append(f"{prefix}    - cells:")
            for cell in row.get('cells', []):
                lines.append(f"{prefix}      - type: {cell['type']}")
                lines.append(f"{prefix}        content:")
                for span in cell.get('content', []):
                    lines.append(format_text_span(span, indent + 5))
                lines.append(f"{prefix}        props:")
                for pk, pv in cell.get('props', {}).items():
                    lines.append(f"{prefix}          {pk}: {format_value(pv, 0)}")
    elif content:
        lines.append(f"{prefix}  content:")
        for span in content:
            lines.append(format_text_span(span, indent + 1))
    else:
        lines.append(f"{prefix}  content: []")

    # Format children
    children = node.get('children', [])
    if children:
        lines.append(f"{prefix}  children:")
        for child in children:
            lines.append(format_node(child, indent + 2))
    else:
        lines.append(f"{prefix}  children: []")

    return '\n'.join(lines)


def format_text_span(span: dict, indent: int) -> str:
    """Format a text span."""
    prefix = '  ' * indent
    lines = []

    span_type = span.get('type', 'text')
    lines.append(f"{prefix}- type: {span_type}")

    if span_type == 'link':
        lines.append(f"{prefix}  href: {span.get('href', '')}")
        lines.append(f"{prefix}  content:")
        for sub_span in span.get('content', []):
            lines.append(format_text_span(sub_span, indent + 2))
    else:
        text = span.get('text', '')
        lines.append(f"{prefix}  text: {format_value(text, 0)}")
        styles = span.get('styles', {})
        if styles:
            lines.append(f"{prefix}  styles:")
            for k, v in styles.items():
                lines.append(f"{prefix}    {k}: {format_value(v, 0)}")
        else:
            lines.append(f"{prefix}  styles: {{}}")

    return '\n'.join(lines)


def format_value(v: Any, indent: int) -> str:
    """Format a single value for YAML."""
    if v is None:
        return 'null'
    elif isinstance(v, bool):
        return 'true' if v else 'false'
    elif isinstance(v, (int, float)):
        return str(v)
    elif isinstance(v, str):
        if '\n' in v:
            # Multi-line string
            prefix = '  ' * (indent + 1)
            lines = v.split('\n')
            result = '|\n'
            for line in lines:
                result += prefix + line + '\n'
            return result.rstrip()
        elif v == '':
            return "''"
        elif v in ('true', 'false', 'null', 'yes', 'no'):
            return f"'{v}'"
        elif any(c in v for c in [':', '#', "'", '"', '{', '[', '|', '>', '!']):
            escaped = v.replace("'", "''")
            return f"'{escaped}'"
        else:
            return v
    else:
        return str(v)


def main():
    parser = argparse.ArgumentParser(
        description='Convert Markdown to Atuin Runbook (.atrb) format'
    )
    parser.add_argument('input', help='Input markdown file')
    parser.add_argument('output', nargs='?', help='Output .atrb file (default: input with .atrb extension)')
    parser.add_argument('--name', help='Runbook name (default: extracted from first heading or filename)')

    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: Input file not found: {input_path}", file=sys.stderr)
        sys.exit(1)

    output_path = Path(args.output) if args.output else input_path.with_suffix('.atrb')

    # Read input
    markdown = input_path.read_text(encoding='utf-8')

    # Extract name from first heading or use filename
    name = args.name
    if not name:
        heading_match = re.search(r'^#\s+(.+)$', markdown, re.MULTILINE)
        if heading_match:
            name = heading_match.group(1)
        else:
            name = input_path.stem

    # Convert
    converter = MarkdownToATRB(name=name)
    doc = converter.parse(markdown)

    # Format and write output
    yaml_output = format_yaml_document(doc)
    output_path.write_text(yaml_output, encoding='utf-8')

    print(f"✅ Converted {input_path} -> {output_path}")
    print(f"   Name: {name}")
    print(f"   Nodes: {len(doc['content'])}")


if __name__ == '__main__':
    main()
